#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path


def getenv_any(*names: str, default: str | None = None) -> str | None:
    for n in names:
        v = os.getenv(n)
        if v:
            return v
    return default


def load_json(p: Path, default):
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except Exception:
        return default


def load_jsonl(p: Path):
    items = []
    try:
        with p.open("r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    items.append(json.loads(line))
                except Exception:
                    pass
    except Exception:
        pass
    return items


def main() -> int:
    ap = argparse.ArgumentParser(description="Assemble deployment.json from results")
    ap.add_argument("--env", required=True)
    ap.add_argument("--in", dest="in_dir", required=True, help="Input results directory")
    ap.add_argument("--out", dest="out_dir", required=True, help="Output directory for deployment.json")
    args = ap.parse_args()

    in_dir = Path(args.in_dir)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    results = load_jsonl(in_dir / "result.jsonl")
    summary = load_json(in_dir / "summary.json", {"ran": 0, "failures": 0})
    meta = load_json(in_dir / "metadata.json", {})

    build = {
        "id": int(getenv_any("BUILD_BUILDID", "Build.BuildId", default="0")),
        "number": getenv_any("BUILD_BUILDNUMBER", "Build.BuildNumber", default=""),
        "definition": getenv_any("BUILD_DEFINITIONNAME", "Build.DefinitionName", default=""),
        "branch": getenv_any("BUILD_SOURCEBRANCH", "Build.SourceBranch", default=""),
        "commit": getenv_any("BUILD_SOURCEVERSION", "Build.SourceVersion", default=""),
    }

    payload = {
        "environment": args.env,
        "build": build,
        "config": {
            "sql_root": meta.get("sql_root"),
            "tags": meta.get("tags", []),
        },
        "databricks": {
            "host": meta.get("databricks_host"),
            "warehouse_id": meta.get("warehouse_id"),
            "include_common": meta.get("include_common"),
        },
        "timing": {
            "start_epoch_s": meta.get("start_epoch_s"),
            "end_epoch_s": meta.get("end_epoch_s"),
        },
        "summary": summary,
        "results": results,
    }

    (out_dir / "deployment.json").write_text(json.dumps(payload), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

