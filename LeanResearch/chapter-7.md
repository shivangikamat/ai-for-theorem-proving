# Chapter 7: Inductive Types

## 7.1 Enumerated Types
The simplest inductive types are enumerated types, which consist of a finite list of elements. For example:

```lean
inductive Weekday where
  | sunday
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
```

This creates a type `Weekday` with seven constructors. The elimination principle, `Weekday.rec`, allows defining functions on `Weekday` by specifying values for each constructor. For example:

```lean
def numberOfDay (d : Weekday) : Nat :=
  match d with
  | sunday    => 1
  | monday    => 2
  | tuesday   => 3
  | wednesday => 4
  | thursday  => 5
  | friday    => 6
  | saturday  => 7
```

### Namespaces and Functions
Functions can be grouped in the same namespace as the inductive type:

```lean
namespace Weekday

def next (d : Weekday) : Weekday :=
  match d with
  | sunday    => monday
  | monday    => tuesday
  | tuesday   => wednesday
  | wednesday => thursday
  | thursday  => friday
  | friday    => saturday
  | saturday  => sunday

end Weekday
```

## 7.2 Constructors with Arguments
Inductive types can have constructors with arguments. For example, the product type and sum type are defined as:

```lean
inductive Prod (α : Type u) (β : Type v)
  | mk : α → β → Prod α β

inductive Sum (α : Type u) (β : Type v) where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

### Example: Product Type
The `Prod` type represents pairs. Functions like `fst` and `snd` extract the components:

```lean
def fst {α : Type u} {β : Type v} (p : Prod α β) : α :=
  match p with
  | Prod.mk a b => a

def snd {α : Type u} {β : Type v} (p : Prod α β) : β :=
  match p with
  | Prod.mk a b => b
```

### Example: Sum Type
The `Sum` type represents a disjoint union:

```lean
def sum_example (s : Sum Nat Nat) : Nat :=
  match s with
  | Sum.inl n => 2 * n
  | Sum.inr n => 2 * n + 1
```

## 7.3 Inductively Defined Propositions
Inductive types can live in `Prop`, defining logical connectives:

```lean
inductive False : Prop

inductive True : Prop where
  | intro : True

inductive And (a b : Prop) : Prop where
  | intro : a → b → And a b

inductive Or (a b : Prop) : Prop where
  | inl : a → Or a b
  | inr : b → Or a b
```

## 7.4 Defining the Natural Numbers
The natural numbers are defined inductively:

```lean
inductive Nat where
  | zero : Nat
  | succ : Nat → Nat
```

### Recursive Functions
Addition can be defined recursively:

```lean
def add (m n : Nat) : Nat :=
  match n with
  | Nat.zero   => m
  | Nat.succ n => Nat.succ (add m n)
```

### Inductive Proofs
Proofs by induction use the recursion principle:

```lean
theorem zero_add (n : Nat) : 0 + n = n :=
  Nat.recOn n
    (show 0 + 0 = 0 from rfl)
    (fun n ih => by simp [ih])
```

## 7.5 Other Recursive Data Types
Lean supports other recursive types, such as lists:

```lean
inductive List (α : Type u) where
  | nil  : List α
  | cons (h : α) (t : List α) : List α
```

### Example: Append
The `append` function concatenates two lists:

```lean
def append (as bs : List α) : List α :=
  match as with
  | nil       => bs
  | cons a as => cons a (append as bs)
```

## 7.6 Tactics for Inductive Types
Lean provides tactics for working with inductive types:

- `cases`: Splits the goal into cases based on constructors.
- `induction`: Performs induction on an inductive type.
- `injection`: Exploits the injectivity of constructors.

### Example: Induction

```lean
theorem zero_add (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ n ih => rw [Nat.add_succ, ih]
```

## 7.7 Inductive Families
Inductive families define indexed types. For example, vectors of fixed length:

```lean
inductive Vect (α : Type u) : Nat → Type u where
  | nil  : Vect α 0
  | cons : α → {n : Nat} → Vect α n → Vect α (n + 1)
```

## 7.8 Axiomatic Details
Inductive types must satisfy positivity constraints, ensuring constructors build elements from the bottom up. For example:

```lean
inductive Tree (α : Type u) where
  | mk : α → List (Tree α) → Tree α
```

## 7.9 Mutual and Nested Inductive Types
Lean supports mutually defined inductive types:

```lean
mutual
  inductive Even : Nat → Prop where
    | even_zero : Even 0
    | even_succ : (n : Nat) → Odd n → Even (n + 1)

  inductive Odd : Nat → Prop where
    | odd_succ : (n : Nat) → Even n → Odd (n + 1)
end
```

Nested inductive types are also supported:

```lean
inductive Tree (α : Type u) where
  | mk : α → List (Tree α) → Tree α
```

## 7.10 Exercises
1. Define operations on natural numbers, such as multiplication and exponentiation, and prove their properties.
2. Define operations on lists, such as `length` and `reverse`, and prove properties like:
   - `length (xs ++ ys) = length xs + length ys`
   - `reverse (reverse xs) = xs`
3. Define a type of propositional formulas and functions for evaluation and substitution.