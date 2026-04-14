# lean_research

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

After building the project, you can explore the following modules:
- `Phase1`: Initial setup for proof-state extraction.
- `ProofStateUtils`: Utilities for manipulating proof states.
- `DatasetGenerator`: Functions for generating datasets.
- `LeanDojoIntegration`: Integration with LeanDojo.

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

