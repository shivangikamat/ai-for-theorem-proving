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
- intro
- exact
- apply
- rw
- simp
- cases
- have
- assumption
- rfl
- simpa
- rwa
- exact_mod_cast
- by_contra

## Dataset status

Cleaned dataset file:
- data/pilot_pairs_checked.jsonl

CSV snapshot for quick inspection:
- data/pilot_pairs_checked.csv

The expanded pilot emphasizes diversity of tactic families rather than raw size.

## Evaluation protocol

- Split strategy: theorem-level random split
- Default split: 70/30 train/test by theorem
- Seed: 42
- Primary metric: accuracy
- Secondary metric: macro-F1

Theorem-level split avoids placing steps from the same theorem in both train and test.

Latest run summary:
- rows: 51
- train/test rows: 36 / 15
- label distribution: intro 13, exact 10, have 6, apply 5, rw 4, cases 4, simp 2, assumption 2, rfl 1, simpa 1, rwa 1, exact_mod_cast 1, by_contra 1

## Baselines

Implemented in baselines.py:
- majority_class
- keyword_heuristic
- text_naive_bayes (bag-of-words over main_goal + local_context)

Run command:

python baselines.py --data data/pilot_pairs_checked.jsonl --output data/baseline_results.json

Latest baseline results (seed 42, theorem-level split):
- majority_class: accuracy 0.400, macro-F1 0.095
- keyword_heuristic: accuracy 0.467, macro-F1 0.194
- text_naive_bayes: accuracy 0.200, macro-F1 0.067

## Current limitations

- Pilot size is still small; metric variance is high.
- Some tactics are underrepresented classes.
- Text-only features ignore proof state internals beyond surface-form goal/context.
- Data is semi-manual, so there may be stylistic annotation bias.

## Next extensions

- Increase theorem coverage across additional Lean files.
- Add stratified multi-seed evaluation.
- Add stronger linear baseline (for example, logistic regression) once dependency setup is fixed.
