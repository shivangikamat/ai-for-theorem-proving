# Short Benchmark Note

## Proposed first task

I propose **tactic-family prediction** as the first benchmark task.

For each proof step, the model takes:
- theorem name
- source file
- step index
- current main goal
- local context

and predicts a tactic-family label (for example: `intro`, `apply`, `exact`, `rw`, `simp`).

## Why this first

- It is simpler and cleaner than full next-tactic prediction.
- It reduces sensitivity to exact argument formatting.
- It is easier to evaluate on a small pilot dataset.

## Evaluation

- Primary metric: accuracy.
- Secondary metric: macro-F1 (especially if class frequencies are imbalanced).

## Scope for the pilot

- Keep the representation at single-step granularity.
- Use the current main goal and local context as inputs.
- Keep the full tactic text in the dataset for future next-tactic experiments.

## Representation decisions

Multiple goals:
- For the pilot, we serialize only the current main goal at each step.
- If a tactic creates subgoals, each subsequent step is recorded as a new row with its own current main goal.

Tactic granularity:
- We keep two fields: full tactic text (`next_tactic`) and normalized family (`tactic_family`).
- Current benchmark uses `tactic_family`; `next_tactic` is retained for later next-tactic prediction.

Normalization of tactics and contexts:
- `tactic_family` is normalized from the head tactic token (for example, `intro`, `apply`, `exact`, `rw`, `simp`).
- `local_context` is stored as an ordered list of pretty-printed hypotheses.
- Goal and context text are kept in Lean-style surface form with minimal rewriting.
