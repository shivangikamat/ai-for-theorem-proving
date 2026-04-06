-- Lean Basics

-- This file contains basic examples and explanations for Lean.

-- Example of a simple definition
def addTwoNumbers (a b : Nat) : Nat :=
  a + b

-- Example of a theorem
example : 2 + 2 = 4 :=
  rfl

-- Added an example of a simple function
def multiplyTwoNumbers (a b : Nat) : Nat :=
  a * b