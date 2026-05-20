# Short Benchmark Note

## Task

First benchmark task: tactic-family prediction.

Input per proof step:
- theorem
- file
- step_index
- main_goal
- local_context

Target:
- tactic_family

We keep next_tactic text for future next-tactic generation experiments.

## Final schema

Canonical fields in each cleaned JSONL row:
- file: string
- theorem: string
- step_index: integer (0-based)
- main_goal: string
- local_context: list of strings
- next_tactic: string
- tactic_family: normalized label string

The JSON Schema is in LeanResearch/schema.json.

## Final tactic-family label set

Current pilot label set:
- apply
- assumption
- by_contra
- cases
- constructor
- contradiction
- exact
- exact_mod_cast
- grind
- have
- intro
- left
- linarith
- obtain
- refine
- rfl
- right
- ring
- rintro
- rw
- simp
- simp_all
- simp_rw
- term

## Dataset status

Cleaned dataset file:
- data/pilot_pairs_checked.jsonl

CSV snapshot for quick inspection:
- data/pilot_pairs_checked.csv

The expanded pilot emphasizes diversity of tactic families rather than raw size.

Raw editable source file:
- data/pilot_pairs.jsonl

Normalization command:

```bash
python scripts/check_pilot.py --input data/pilot_pairs.jsonl --output-jsonl data/pilot_pairs_checked.jsonl --output-csv data/pilot_pairs_checked.csv
```

## Evaluation protocol

- Split strategy: theorem-level random split
- Default split: 70/30 train/test by theorem
- Seed: 42
- Primary metric: accuracy
- Secondary metric: macro-F1

Theorem-level split avoids placing steps from the same theorem in both train and test.

Latest run summary:
- rows: 92
- unique theorem names covered: 38
- train/test rows: 55 / 37
- label distribution: exact 17, intro 16, rw 9, have 7, apply 6, simp 5, term 4, constructor 4, cases 4, rintro 3, refine 2, rfl 2, assumption 2, grind 1, obtain 1, simp_rw 1, left 1, right 1, by_contra 1, contradiction 1, linarith 1, ring 1, exact_mod_cast 1, simp_all 1

## Baselines

Implemented in baselines.py:
- majority_class
- keyword_heuristic
- text_naive_bayes (bag-of-words over main_goal + local_context)

Run command:

```bash
python baselines.py --data data/pilot_pairs_checked.jsonl --output data/baseline_results.json
```

Latest baseline results (seed 42, theorem-level split):
- majority_class: accuracy 0.162, macro-F1 0.016
- keyword_heuristic: accuracy 0.270, macro-F1 0.103
- text_naive_bayes: accuracy 0.216, macro-F1 0.046

## Current limitations

- Pilot size is still small; metric variance is high.
- Several tactic families are represented by only one or two examples.
- Text-only features ignore proof state internals beyond surface-form goal/context.
- Data is semi-manual, so there may be stylistic annotation bias.
- The keyword heuristic is deliberately hand-written and should be treated as a sanity-check baseline, not a learned model.
