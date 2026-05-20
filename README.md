# Research in AI for theorem proving

## Overview

This project aims to explore proof-state representations and tactic predictions using the Lean theorem prover. It includes utilities, dataset generation, and integration with external tools.
LeanDojo is used as a bridge between Lean source files and machine learning workflows.


## Installation

To get started with this project, clone the repository and build it using the Lean build tool:

```
git clone <repository-url>
cd lean_research
lake build
```

## Usage

The current pilot benchmark workflow is:

```bash
python3 scripts/check_pilot.py \
  --input data/pilot_pairs.jsonl \
  --output-jsonl data/pilot_pairs_checked.jsonl \
  --output-csv data/pilot_pairs_checked.csv

python3 baselines.py \
  --data data/pilot_pairs_checked.jsonl \
  --output data/baseline_results.json
```

The cleaned dataset is `data/pilot_pairs_checked.jsonl`, the schema is
`LeanResearch/schema.json`, and the short benchmark summary is
`LeanResearch/benchmark_note.md`.

## LeanDojo

LeanDojo is a research toolkit for interacting with Lean projects programmatically. It can replay proofs, collect tactic states, and expose structured traces that are useful for dataset creation and model training.

In this repository, LeanDojo is used to:
- extract proof states from Lean files,
- pair proof contexts with tactic actions,
- and support experiments on tactic prediction.

## Examples

Here is an example of a simple Lean function:

```lean
def square (x : Nat) : Nat :=
  x * x

example : square 3 = 9 :=
  rfl
```
