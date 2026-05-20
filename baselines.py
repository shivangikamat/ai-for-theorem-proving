import argparse
import json
import math
import random
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Iterable


def load_jsonl(path: Path) -> list[dict]:
    rows: list[dict] = []
    with path.open("r", encoding="utf-8") as f:
        for line_no, raw_line in enumerate(f, start=1):
            line = raw_line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError as exc:
                raise ValueError(f"Invalid JSON on line {line_no} of {path}: {exc}") from exc
            rows.append(row)
    return rows


def theorem_split(rows: list[dict], test_ratio: float, seed: int) -> tuple[list[dict], list[dict]]:
    theorem_names = sorted({row["theorem"] for row in rows})
    rng = random.Random(seed)
    rng.shuffle(theorem_names)
    n_test = max(1, int(round(len(theorem_names) * test_ratio)))
    test_theorems = set(theorem_names[:n_test])
    train = [row for row in rows if row["theorem"] not in test_theorems]
    test = [row for row in rows if row["theorem"] in test_theorems]
    return train, test


def accuracy(y_true: list[str], y_pred: list[str]) -> float:
    if not y_true:
        return 0.0
    correct = sum(1 for y, p in zip(y_true, y_pred) if y == p)
    return correct / len(y_true)


def macro_f1(y_true: list[str], y_pred: list[str]) -> float:
    labels = sorted(set(y_true) | set(y_pred))
    if not labels:
        return 0.0
    f1_scores: list[float] = []
    for label in labels:
        tp = sum(1 for y, p in zip(y_true, y_pred) if y == label and p == label)
        fp = sum(1 for y, p in zip(y_true, y_pred) if y != label and p == label)
        fn = sum(1 for y, p in zip(y_true, y_pred) if y == label and p != label)
        precision = tp / (tp + fp) if (tp + fp) else 0.0
        recall = tp / (tp + fn) if (tp + fn) else 0.0
        f1 = 2 * precision * recall / (precision + recall) if (precision + recall) else 0.0
        f1_scores.append(f1)
    return sum(f1_scores) / len(f1_scores)


def majority_predictor(train_rows: list[dict], n: int) -> list[str]:
    majority_label = Counter(row["tactic_family"] for row in train_rows).most_common(1)[0][0]
    return [majority_label for _ in range(n)]


def heuristic_predict(row: dict, fallback_label: str) -> str:
    text = f"{row['main_goal']} {' '.join(row['local_context'])}".lower()
    goal = row["main_goal"].lower()

    if "false" in text:
        return "contradiction"
    if "^" in goal and "=" in goal:
        return "ring"
    if ("≤" in goal or "<" in goal) and any(op in goal for op in ["+", "-", "*"]):
        return "omega"
    if "↔" in goal or " true" in text:
        return "simp"
    if "∧" in goal and "→" not in goal:
        return "constructor"
    if "∧" in goal and "→" in goal:
        return "intro"
    if "∀" in goal or "→" in goal:
        return "intro"
    if "∃" in goal or "isroot" in text:
        return "apply"
    if "=" in goal and ("+" in goal or "*" in goal):
        return "rw"
    if "∨" in goal:
        return "cases"

    return fallback_label


TOKEN_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*|[¬∧∨→↔=<>]+")


def tokenize(text: str) -> list[str]:
    return [tok.lower() for tok in TOKEN_RE.findall(text)]


def build_text(row: dict) -> str:
    context = " ".join(row["local_context"])
    return f"{row['main_goal']} {context}"


class NaiveBayesTextClassifier:
    def __init__(self) -> None:
        self.class_priors: dict[str, float] = {}
        self.class_token_counts: dict[str, Counter[str]] = {}
        self.class_total_tokens: dict[str, int] = {}
        self.vocab: set[str] = set()

    def fit(self, texts: Iterable[str], labels: Iterable[str]) -> None:
        texts = list(texts)
        labels = list(labels)

        class_counts = Counter(labels)
        total = len(labels)
        self.class_priors = {c: math.log(cnt / total) for c, cnt in class_counts.items()}

        token_counts: dict[str, Counter[str]] = defaultdict(Counter)
        total_tokens: dict[str, int] = defaultdict(int)

        for text, label in zip(texts, labels):
            toks = tokenize(text)
            token_counts[label].update(toks)
            total_tokens[label] += len(toks)
            self.vocab.update(toks)

        self.class_token_counts = dict(token_counts)
        self.class_total_tokens = dict(total_tokens)

    def predict_one(self, text: str) -> str:
        toks = tokenize(text)
        if not self.class_priors:
            raise ValueError("Classifier is not fitted.")

        vocab_size = max(1, len(self.vocab))
        best_label = None
        best_score = float("-inf")

        for label, prior in self.class_priors.items():
            score = prior
            counts = self.class_token_counts.get(label, Counter())
            denom = self.class_total_tokens.get(label, 0) + vocab_size
            for tok in toks:
                score += math.log((counts.get(tok, 0) + 1) / denom)
            if score > best_score:
                best_score = score
                best_label = label

        assert best_label is not None
        return best_label

    def predict(self, texts: Iterable[str]) -> list[str]:
        return [self.predict_one(text) for text in texts]


def evaluate(rows: list[dict], test_ratio: float, seed: int) -> dict:
    train_rows, test_rows = theorem_split(rows, test_ratio=test_ratio, seed=seed)
    if not train_rows or not test_rows:
        raise ValueError("Split produced empty train/test set. Expand data or adjust test_ratio.")

    y_test = [r["tactic_family"] for r in test_rows]

    majority_preds = majority_predictor(train_rows, len(test_rows))
    majority_metrics = {
        "accuracy": accuracy(y_test, majority_preds),
        "macro_f1": macro_f1(y_test, majority_preds),
    }

    fallback = Counter(r["tactic_family"] for r in train_rows).most_common(1)[0][0]
    heuristic_preds = [heuristic_predict(row, fallback) for row in test_rows]
    heuristic_metrics = {
        "accuracy": accuracy(y_test, heuristic_preds),
        "macro_f1": macro_f1(y_test, heuristic_preds),
    }

    model = NaiveBayesTextClassifier()
    model.fit([build_text(r) for r in train_rows], [r["tactic_family"] for r in train_rows])
    text_preds = model.predict([build_text(r) for r in test_rows])
    text_metrics = {
        "accuracy": accuracy(y_test, text_preds),
        "macro_f1": macro_f1(y_test, text_preds),
    }

    return {
        "split": {
            "strategy": "theorem-level random split",
            "seed": seed,
            "test_ratio": test_ratio,
            "n_rows": len(rows),
            "n_train": len(train_rows),
            "n_test": len(test_rows),
            "n_train_theorems": len({r['theorem'] for r in train_rows}),
            "n_test_theorems": len({r['theorem'] for r in test_rows}),
        },
        "label_distribution": dict(Counter(r["tactic_family"] for r in rows)),
        "baselines": {
            "majority_class": majority_metrics,
            "keyword_heuristic": heuristic_metrics,
            "text_naive_bayes": text_metrics,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Run pilot baselines for tactic-family prediction.")
    parser.add_argument(
        "--data",
        type=Path,
        default=Path("data/pilot_pairs_checked.jsonl"),
        help="Path to cleaned JSONL dataset.",
    )
    parser.add_argument("--test-ratio", type=float, default=0.3, help="Theorem-level test split ratio.")
    parser.add_argument("--seed", type=int, default=42, help="Random seed for theorem split.")
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("data/baseline_results.json"),
        help="Where to write evaluation JSON results.",
    )
    args = parser.parse_args()

    rows = load_jsonl(args.data)
    result = evaluate(rows, test_ratio=args.test_ratio, seed=args.seed)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8") as f:
        json.dump(result, f, indent=2, ensure_ascii=False)

    print(f"Rows: {result['split']['n_rows']}")
    print(f"Train/Test rows: {result['split']['n_train']}/{result['split']['n_test']}")
    print("Label distribution:", result["label_distribution"])
    for name, metrics in result["baselines"].items():
        print(
            f"{name}: accuracy={metrics['accuracy']:.3f}, macro_f1={metrics['macro_f1']:.3f}"
        )
    print(f"Wrote results to: {args.output}")


if __name__ == "__main__":
    main()
