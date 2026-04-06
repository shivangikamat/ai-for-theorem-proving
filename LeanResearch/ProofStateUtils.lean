-- ProofState Utilities

-- This file contains utility functions for working with ProofState.
import Lean
import LeanResearch.Phase1
open Lean Meta

-- Function to merge two ProofStates (example utility)
def mergeProofStates (ps1 ps2 : ProofState) : ProofState := {
  currentGoal := ps1.currentGoal ++ " | " ++ ps2.currentGoal,
  localContext := ps1.localContext ++ ps2.localContext,
  nextTactic := ps1.nextTactic ++ " | " ++ ps2.nextTactic,
  theoremIdentifier := ps1.theoremIdentifier ++ " | " ++ ps2.theoremIdentifier,
  multipleGoals := ps1.multipleGoals ++ ps2.multipleGoals
}

-- Added a utility function to check if a ProofState is empty

def isProofStateEmpty (ps : ProofState) : Bool :=
  ps.currentGoal.isEmpty && ps.localContext.isEmpty && ps.nextTactic.isEmpty && ps.theoremIdentifier.isEmpty && ps.multipleGoals.isEmpty

-- Added a utility function to print a ProofState

def printProofState (ps : ProofState) : IO Unit :=
  IO.println s!"ProofState: {ps}"

-- Placeholder for additional utilities
def placeholderUtility : IO Unit :=
  IO.println "More utilities to be added here."
