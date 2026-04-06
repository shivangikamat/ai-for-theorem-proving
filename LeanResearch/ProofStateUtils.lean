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

-- Added a function to check if a ProofState has multiple goals

def hasMultipleGoals (ps : ProofState) : Bool :=
  ps.multipleGoals.length > 1

-- Added a function to check if a ProofState has exactly one goal

def hasExactlyOneGoal (ps : ProofState) : Bool :=
  ps.multipleGoals.length == 1

-- Added a function to check if a ProofState has any goals

def hasAnyGoals (ps : ProofState) : Bool :=
  !ps.multipleGoals.isEmpty

-- Added a function to get the first goal from a ProofState

def getFirstGoal (ps : ProofState) : Option String :=
  ps.multipleGoals.head?

-- Added a function to get the last goal from a ProofState

def getLastGoal (ps : ProofState) : Option String :=
  ps.multipleGoals.getLast?

-- Added a utility function to print a ProofState

def printProofState (ps : ProofState) : IO Unit :=
  IO.println s!"ProofState: {ps}"

-- Added a function to count the number of goals in a ProofState

def countGoals (ps : ProofState) : Nat :=
  ps.multipleGoals.length

-- Added a function to clear all goals in a ProofState

def clearGoals (ps : ProofState) : ProofState :=
  { ps with multipleGoals := [] }

-- Added a function to update the current goal in a ProofState

def updateCurrentGoal (ps : ProofState) (newGoal : String) : ProofState :=
  { ps with currentGoal := newGoal }

-- Added a function to append a new goal to a ProofState

def appendGoal (ps : ProofState) (newGoal : String) : ProofState :=
  { ps with multipleGoals := ps.multipleGoals ++ [newGoal] }

-- Added a function to check if the current goal is empty

def isCurrentGoalEmpty (ps : ProofState) : Bool :=
  ps.currentGoal.isEmpty

-- Added a function to replace all goals in a ProofState

def replaceGoals (ps : ProofState) (newGoals : List String) : ProofState :=
  { ps with multipleGoals := newGoals }

-- Added a function to check if a ProofState is valid

def isValidProofState (ps : ProofState) : Bool :=
  !ps.currentGoal.isEmpty && !ps.multipleGoals.isEmpty

-- Added a function to reverse the goals in a ProofState

def reverseGoals (ps : ProofState) : ProofState :=
  { ps with multipleGoals := ps.multipleGoals.reverse }

-- Added a function to get the goal count as a string

def goalCountAsString (ps : ProofState) : String :=
  toString ps.multipleGoals.length

-- Added a function to check if all goals are empty

def areAllGoalsEmpty (ps : ProofState) : Bool :=
  ps.multipleGoals.all String.isEmpty

-- Placeholder for additional utilities
def placeholderUtility : IO Unit :=
  IO.println "More utilities to be added here."
