import json
from pathlib import Path
import csv

INPUT_FILE = Path("data/pilot_pairs.jsonl")
OUTPUT_JSONL = Path("data/pilot_pairs_checked.jsonl")
OUTPUT_CSV = Path("data/pilot_pairs_checked.csv")

BASE_REQUIRED_FIELDS = {
    "theorem",
    "file",
    "step_index",
    "local_context",
    "next_tactic",
}

GOAL_FIELDS = ["main_goal", "goal", "state_main_goal"]

TACTIC_FAMILY_MAP = {
    "intro": "intro",
    "intros": "intro",
    "exact": "exact",
    "apply": "apply",
    "rw": "rw",
    "rewrite": "rw",
    "simp": "simp",
    "cases": "cases",
    "have": "have",
    "assumption": "assumption",
    "rfl": "rfl",
    "simpa": "simpa",
    "rwa": "rwa",
    "exact_mod_cast": "exact_mod_cast",
    "by_contra": "by_contra",
}


def extract_tactic_family(tactic: str) -> str:
    tactic = tactic.strip()
    if not tactic:
        return "unknown"
    head = tactic.split()[0].strip(";,")
    return TACTIC_FAMILY_MAP.get(head, head)


def validate_entry(entry: dict, line_no: int) -> list[str]:
    errors = []

    missing = BASE_REQUIRED_FIELDS - entry.keys()
    if missing:
        errors.append(f"Line {line_no}: missing fields {sorted(missing)}")

    if not any(field in entry for field in GOAL_FIELDS):
        errors.append(
            f"Line {line_no}: missing goal field (expected one of {GOAL_FIELDS})"
        )

    if "step_index" in entry and not isinstance(entry["step_index"], int):
        errors.append(f"Line {line_no}: step_index should be an int")

    if "local_context" in entry and not isinstance(entry["local_context"], list):
        errors.append(f"Line {line_no}: local_context should be a list")

    for field in GOAL_FIELDS:
        if field in entry and not isinstance(entry[field], str):
            errors.append(f"Line {line_no}: {field} should be a string")

    if "next_tactic" in entry and not isinstance(entry["next_tactic"], str):
        errors.append(f"Line {line_no}: next_tactic should be a string")

    return errors


def normalize_entry(entry: dict) -> dict:
    normalized = dict(entry)

    if "main_goal" not in normalized:
        if "state_main_goal" in normalized:
            normalized["main_goal"] = normalized.pop("state_main_goal")
        elif "goal" in normalized:
            normalized["main_goal"] = normalized.pop("goal")

    normalized["tactic_family"] = extract_tactic_family(
        normalized.get("next_tactic", "")
    )

    normalized["local_context"] = [str(x) for x in normalized.get("local_context", [])]

    keep = {
        "file": normalized.get("file", ""),
        "theorem": normalized.get("theorem", ""),
        "step_index": normalized.get("step_index", 0),
        "main_goal": normalized.get("main_goal", ""),
        "local_context": normalized.get("local_context", []),
        "next_tactic": normalized.get("next_tactic", ""),
        "tactic_family": normalized.get("tactic_family", "unknown"),
    }

    return keep


def main() -> None:
    if not INPUT_FILE.exists():
        print(f"Error: {INPUT_FILE} does not exist.")
        return

    output_entries = []
    all_errors = []

    with INPUT_FILE.open("r", encoding="utf-8") as f:
        for line_no, line in enumerate(f, start=1):
            line = line.strip()

            if not line:
                continue

            try:
                entry = json.loads(line)
            except json.JSONDecodeError as e:
                all_errors.append(f"Line {line_no}: invalid JSON ({e})")
                continue

            if not isinstance(entry, dict):
                all_errors.append(f"Line {line_no}: entry is not a JSON object")
                continue

            all_errors.extend(validate_entry(entry, line_no))
            output_entries.append(normalize_entry(entry))

    if all_errors:
        print("Found problems:")
        for err in all_errors:
            print(" -", err)
    else:
        print("No formatting problems found.")

    with OUTPUT_JSONL.open("w", encoding="utf-8") as f:
        for entry in output_entries:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    with OUTPUT_CSV.open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(
            [
                "file",
                "theorem",
                "step_index",
                "main_goal",
                "local_context",
                "next_tactic",
                "tactic_family",
            ]
        )
        for entry in output_entries:
            writer.writerow(
                [
                    entry["file"],
                    entry["theorem"],
                    entry["step_index"],
                    entry["main_goal"],
                    "[" + "; ".join(entry["local_context"]) + "]",
                    entry["next_tactic"],
                    entry["tactic_family"],
                ]
            )

    print(f"Wrote cleaned file to: {OUTPUT_JSONL}")
    print(f"Wrote CSV snapshot to: {OUTPUT_CSV}")


if __name__ == "__main__":
    main()