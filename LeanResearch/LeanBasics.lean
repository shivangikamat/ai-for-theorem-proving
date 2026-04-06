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

-- Added an example of a simple proof

example : 3 * 3 = 9 :=
  rfl

-- Added an example of a recursive function

def fibonacci (n : Nat) : Nat :=
  if n == 0 then 0
  else if n == 1 then 1
  else fibonacci (n - 1) + fibonacci (n - 2)
  termination_by fibonacci => n

-- Added an example of a list operation

def sumList (lst : List Nat) : Nat :=
  lst.foldl (· + ·) 0
