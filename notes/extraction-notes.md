# Pilot extraction note

## Goal
Create a small dataset of proof-state / next-tactic pairs from a small Lean file.

## Repository subset
I used `LeanResearch/Pilot.lean`, which contains short theorem proofs with simple single-line tactics.

## Record format
Each record stores:
- file
- theorem name
- step index
- main goal
- local context
- next tactic

## Current status
Initial records were created manually from visible proof states in Lean.

## Difficulties
- deciding how to represent multiple goals
- determining whether to normalize tactic text
- visible proof state does not capture the full internal elaboration