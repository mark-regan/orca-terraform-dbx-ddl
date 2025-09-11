#!/usr/bin/env python3
import argparse
import json
import logging
import os
import re
import sys
import time
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import HTTPError, URLError
import subprocess

try:
    from azure.identity import AzureCliCredential, DefaultAzureCredential
except Exception:  # noqa: BLE001
    AzureCliCredential = None  # type: ignore
    DefaultAzureCredential = None  # type: ignore


def acquire_aad_token() -> str:
    """Acquire an AAD access token for the Databricks resource using azure.identity.

    Order of precedence:
      1) DBX_TOKEN env var (use as-is)
      2) AzureCliCredential (OIDC login in pipeline makes this available)
      3) DefaultAzureCredential (covers managed identity and others)
      4) Fallback to `az account get-access-token --resource=https://databricks.azure.net/`
    """
    # 1) Explicit override
    token = os.environ.get("DBX_TOKEN", "").strip()
    if token:
        return token

    # Scope for Databricks resource app ID
    scope = "2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default"

    # 2) Azure CLI Credential
    if AzureCliCredential is not None:
        try:
            cli = AzureCliCredential()
            return cli.get_token(scope).token
        except Exception:
            pass

    # 3) Default Azure Credential
    if DefaultAzureCredential is not None:
        try:
            dac = DefaultAzureCredential()
            return dac.get_token(scope).token
        except Exception:
            pass

    # 4) Fallback to az CLI command
    try:
        out = subprocess.check_output(
            [
                "az",
                "account",
                "get-access-token",
                "--resource=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d",
                "--query",
                "accessToken",
                "-o",
                "tsv",
            ],
            text=True,
        ).strip()
        if not out:
            raise RuntimeError("Empty token from Azure CLI")
        return out
    except Exception as e:  # noqa: BLE001
        raise RuntimeError(f"Failed to acquire AAD token: {e}")


def http_json(method: str, url: str, token: str, body: dict | None = None) -> dict:
    data = None
    if body is not None:
        data = json.dumps(body).encode("utf-8")
    req = Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    req.add_header("Content-Type", "application/json")
    try:
        logging.debug("HTTP %s %s", method, url)
        with urlopen(req, timeout=60) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except HTTPError as e:
        try:
            detail = e.read().decode("utf-8")
        except Exception:
            detail = str(e)
        logging.error("HTTP %s error: %s %s", method, e.code, e.reason)
        raise RuntimeError(f"HTTP {e.code} {e.reason}: {detail}")
    except URLError as e:
        logging.error("Request error on %s: %s", url, e)
        raise RuntimeError(f"Request error: {e}")


def ensure_warehouse_id(warehouse_id: str | None) -> str:
    if not warehouse_id:
        raise RuntimeError("Missing required --warehouse-id (set in variable group)")
    return warehouse_id


VAR_PATTERN = re.compile(r"\$\{([A-Za-z0-9_]+)\}")


def render_sql(text: str) -> str:
    def repl(m: re.Match[str]) -> str:
        name = m.group(1)
        return os.environ.get(name, "")

    return VAR_PATTERN.sub(repl, text)


def split_sql_statements(sql: str) -> list[str]:
    """Split SQL into individual statements by semicolon, respecting quotes and comments."""
    stmts: list[str] = []
    buf: list[str] = []
    in_single = False
    in_double = False
    in_line_comment = False
    in_block_comment = False
    i = 0
    n = len(sql)
    while i < n:
        ch = sql[i]
        nxt = sql[i + 1] if i + 1 < n else ""

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                buf.append(ch)
            i += 1
            continue

        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue

        # start of comments
        if not in_single and not in_double:
            if ch == "-" and nxt == "-":
                in_line_comment = True
                i += 2
                continue
            if ch == "/" and nxt == "*":
                in_block_comment = True
                i += 2
                continue

        # toggle quotes
        if ch == "'" and not in_double:
            in_single = not in_single
            buf.append(ch)
            i += 1
            continue
        if ch == '"' and not in_single:
            in_double = not in_double
            buf.append(ch)
            i += 1
            continue

        # statement terminator
        if ch == ";" and not in_single and not in_double:
            stmt = "".join(buf).strip()
            if stmt:
                stmts.append(stmt)
            buf = []
            i += 1
            continue

        buf.append(ch)
        i += 1

    # last trailing buffer
    tail = "".join(buf).strip()
    if tail:
        stmts.append(tail)
    return stmts


def extract_file_tags(path: Path) -> list[str]:
    try:
        with path.open("r", encoding="utf-8") as f:
            for i, line in enumerate(f):
                if i >= 20:
                    break
                m = re.match(r"\s*--\s*tags\s*:(.*)", line, flags=re.IGNORECASE)
                if m:
                    tags = [t.strip().lower() for t in m.group(1).split(",") if t.strip()]
                    return tags
    except Exception:
        pass
    return []


def load_deploy_config(env_dir: Path, common_dir: Path) -> tuple[list[str], bool]:
    tags: list[str] = []
    include_common = True
    cfg_path = None
    if (env_dir / "deploy.json").exists():
        cfg_path = env_dir / "deploy.json"
    elif (common_dir / "deploy.json").exists():
        cfg_path = common_dir / "deploy.json"
    if cfg_path:
        try:
            with cfg_path.open("r", encoding="utf-8") as f:
                cfg = json.load(f)
            tags = [str(t).strip().lower() for t in cfg.get("tags", []) if str(t).strip()]
            ic = cfg.get("includeCommon", True)
            include_common = bool(ic) if ic is not None else True
        except Exception as e:
            raise RuntimeError(f"Failed to load {cfg_path}: {e}")
    return tags, include_common


def has_continue_on_fail(path: Path) -> bool:
    try:
        with path.open("r", encoding="utf-8") as f:
            for i, line in enumerate(f):
                if i >= 20:
                    break
                if re.match(r"\s*--\s*continue_on_fail\b", line, flags=re.IGNORECASE):
                    return True
    except Exception:
        pass
    return False


def main() -> int:
    ap = argparse.ArgumentParser(description="Run Databricks SQL deployment")
    ap.add_argument("--env", required=True, choices=["dev", "test", "uat", "prod"], help="Environment name")
    ap.add_argument("--host", required=True, help="Databricks workspace host, e.g. https://adb-xxx.azuredatabricks.net")
    ap.add_argument("--root", default="table_deploy_pipeline/sql", help="SQL root directory")
    ap.add_argument("--out", required=True, help="Output directory for results")
    ap.add_argument("--warehouse-id", required=True, help="SQL Warehouse ID (required)")
    ap.add_argument("--log-level", default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR"], help="Log verbosity")
    ap.add_argument("--wait-timeout", default="", help="Optional statement wait_timeout (e.g., 120s). If empty, omit.")
    args = ap.parse_args()

    logging.basicConfig(stream=sys.stdout, level=getattr(logging, args.log_level), format="%(asctime)s %(levelname)s %(message)s")

    host = args.host.rstrip("/")
    root = Path(args.root)
    env_dir = root / args.env
    common_dir = root / "common"
    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)

    logging.info("Starting SQL deploy: env=%s host=%s root=%s out=%s", args.env, host, root, out_dir)
    if not env_dir.exists() and not common_dir.exists():
        logging.error("No SQL directories found at %s or %s", env_dir, common_dir)
        return 1

    logging.info("Acquiring AAD token for Databricks resource")
    token = acquire_aad_token()
    logging.info("Token acquired")
    warehouse_id = ensure_warehouse_id(args.warehouse_id)
    logging.info("Using warehouse_id=%s", warehouse_id)

    tags_filter, include_common = load_deploy_config(env_dir, common_dir)
    logging.info("Deploy config: include_common=%s tags=%s", include_common, tags_filter)

    metadata = {
        "environment": args.env,
        "databricks_host": host,
        "warehouse_id": warehouse_id,
        "sql_root": str(root),
        "include_common": include_common,
        "tags": tags_filter,
        "start_epoch_s": int(time.time()),
    }
    (out_dir / "metadata.json").write_text(json.dumps(metadata), encoding="utf-8")

    files: list[Path] = []
    if include_common and common_dir.exists():
        common_files = sorted(common_dir.rglob("*.sql"))
        logging.info("Found %d 'common' SQL files", len(common_files))
        files += common_files
    if env_dir.exists():
        env_files = sorted(env_dir.rglob("*.sql"))
        logging.info("Found %d '%s' SQL files", len(env_files), args.env)
        files += env_files
    if not files:
        logging.warning("No .sql files found to execute.")
        (out_dir / "summary.json").write_text(json.dumps({"ran": 0, "failures": 0}), encoding="utf-8")
        metadata["end_epoch_s"] = int(time.time())
        (out_dir / "metadata.json").write_text(json.dumps(metadata), encoding="utf-8")
        return 0

    def matches_tags(path: Path) -> bool:
        if not tags_filter:
            return True
        file_tags = extract_file_tags(path)
        ft = set([t.lower() for t in file_tags])
        for t in tags_filter:
            if t.lower() in ft:
                return True
        return False

    results_path = out_dir / "result.jsonl"
    ran = 0
    failures = 0
    abort_deploy = False
    for f in files:
        if not matches_tags(f):
            logging.debug("Skipping (no matching tag): %s", f)
            continue
        logging.info("Executing: %s", f)
        sql_text = f.read_text(encoding="utf-8")
        rendered = render_sql(sql_text)
        statements = split_sql_statements(rendered)
        logging.info("Split into %d statement(s)", len(statements))
        cof = has_continue_on_fail(f)
        if cof:
            logging.info("continue_on_fail detected for file: %s", f)
        for idx, stmt in enumerate(statements, start=1):
            stmt_preview = (stmt[:200] + "...") if len(stmt) > 200 else stmt
            payload = {
                "warehouse_id": warehouse_id,
                "statement": stmt,
            }
            if args.wait_timeout:
                payload["wait_timeout"] = args.wait_timeout
            logging.debug("Submitting statement %d: %s", idx, stmt_preview)
            start_ts = int(time.time())
            error_detail = None
            stmt_id = ""
            status = "SUBMIT_FAILED"
            try:
                submit = http_json("POST", f"{host}/api/2.0/sql/statements", token, payload)
                stmt_id = submit.get("statement_id", "")
                if not stmt_id:
                    raise RuntimeError(f"Submit response missing statement_id: {submit}")
                while True:
                    time.sleep(2)
                    st = http_json("GET", f"{host}/api/2.0/sql/statements/{stmt_id}", token)
                    status = st.get("status", {}).get("state", "")
                    if status in ("SUCCEEDED", "FAILED", "CANCELED"):
                        if status != "SUCCEEDED":
                            error_detail = st
                        break
                logging.info("Statement %d result: %s (id=%s)", idx, status, stmt_id)
            except Exception as e:
                logging.exception("Error executing statement %d in file %s", idx, f)
                error_detail = str(e)

            end_ts = int(time.time())
            ran += 1
            if status in ("FAILED", "CANCELED", "SUBMIT_FAILED"):
                failures += 1
                if not cof:
                    logging.error("Aborting deployment due to failure in %s (no continue_on_fail)", f)
                    abort_deploy = True
            ran += 0  # already incremented per filtered statement
            rec = {
                "file": str(f),
                "statement_index": idx,
                "statement_preview": stmt_preview,
                "status": status or "UNKNOWN",
                "statement_id": stmt_id or None,
                "start_epoch_s": start_ts,
                "end_epoch_s": end_ts,
                "duration_s": end_ts - start_ts,
                "tags": extract_file_tags(f),
            }
            if error_detail is not None:
                try:
                    rec["error"] = error_detail if isinstance(error_detail, str) else error_detail
                except Exception:
                    rec["error"] = str(error_detail)
            with results_path.open("a", encoding="utf-8") as rf:
                rf.write(json.dumps(rec) + "\n")
            if abort_deploy:
                break
        if abort_deploy:
            break

    (out_dir / "summary.json").write_text(json.dumps({"ran": ran, "failures": failures}), encoding="utf-8")
    metadata["end_epoch_s"] = int(time.time())
    (out_dir / "metadata.json").write_text(json.dumps(metadata), encoding="utf-8")
    logging.info("Completed: ran=%d failures=%d", ran, failures)
    # If any failures, attempt rollback scripts tagged with rollback-{tag}
    if failures > 0 and tags_filter:
        logging.warning("Failures detected. Beginning rollback for tags=%s", tags_filter)
        rollback_tags = {f"rollback-{t.lower()}" for t in tags_filter}
        searched: list[Path] = []
        if common_dir.exists():
            searched += sorted(common_dir.rglob("*.sql"))
        if env_dir.exists():
            searched += sorted(env_dir.rglob("*.sql"))
        rollback_files: list[Path] = []
        for fp in searched:
            f_tags = set(extract_file_tags(fp))
            if any(tag in f_tags for tag in rollback_tags):
                rollback_files.append(fp)
        logging.info("Found %d rollback script(s)", len(rollback_files))
        for rf in rollback_files:
            logging.info("Rollback executing: %s", rf)
            try:
                r_sql = render_sql(rf.read_text(encoding="utf-8"))
                r_statements = split_sql_statements(r_sql)
                for ridx, rstmt in enumerate(r_statements, start=1):
                    payload = {"warehouse_id": warehouse_id, "statement": rstmt}
                    if args.wait_timeout:
                        payload["wait_timeout"] = args.wait_timeout
                    start_ts = int(time.time())
                    r_status = "SUBMIT_FAILED"
                    r_error = None
                    r_stmt_id = ""
                    try:
                        s = http_json("POST", f"{host}/api/2.0/sql/statements", token, payload)
                        r_stmt_id = s.get("statement_id", "")
                        if not r_stmt_id:
                            raise RuntimeError(f"Submit response missing statement_id: {s}")
                        while True:
                            time.sleep(2)
                            st = http_json("GET", f"{host}/api/2.0/sql/statements/{r_stmt_id}", token)
                            r_status = st.get("status", {}).get("state", "")
                            if r_status in ("SUCCEEDED", "FAILED", "CANCELED"):
                                if r_status != "SUCCEEDED":
                                    r_error = st
                                break
                        logging.info("Rollback statement result: %s (id=%s)", r_status, r_stmt_id)
                    except Exception as ex:
                        logging.exception("Error in rollback statement %d of %s", ridx, rf)
                        r_error = str(ex)
                    end_ts = int(time.time())
                    rec = {
                        "file": str(rf),
                        "rollback": True,
                        "statement_index": ridx,
                        "status": r_status,
                        "statement_id": r_stmt_id or None,
                        "start_epoch_s": start_ts,
                        "end_epoch_s": end_ts,
                        "duration_s": end_ts - start_ts,
                        "tags": extract_file_tags(rf),
                    }
                    if r_error is not None:
                        rec["error"] = r_error if isinstance(r_error, str) else r_error
                    with results_path.open("a", encoding="utf-8") as frec:
                        frec.write(json.dumps(rec) + "\n")
            except Exception:
                logging.exception("Failed reading or running rollback file: %s", rf)

    return 0 if failures == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
