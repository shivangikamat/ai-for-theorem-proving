# Chapter 8: Induction and Recursion

## 8. Induction and Recursion

In the previous chapter, we saw that inductive definitions provide a powerful means of introducing new types in Lean. Moreover, the constructors and the recursors provide the only means of defining functions on these types. By the propositions-as-types correspondence, this means that induction is the fundamental method of proof.

Lean provides natural ways of defining recursive functions, performing pattern matching, and writing inductive proofs. It allows you to define a function by specifying equations that it should satisfy, and it allows you to prove a theorem by specifying how to handle various cases that can arise. Behind the scenes, these descriptions are “compiled” down to primitive recursors, using a procedure that we refer to as the “equation compiler.” The equation compiler is not part of the trusted code base; its output consists of terms that are checked independently by the kernel.

## 8.1. Pattern Matching

Pattern matching provides a convenient way to define functions and prove theorems by cases. It simplifies the use of recursors and makes definitions more readable. For example, the natural numbers can be defined as follows:

```lean
open Nat

def sub1 : Nat → Nat
  | 0     => 0
  | x + 1 => x

def isZero : Nat → Bool
  | 0     => true
  | x + 1 => false
```

Pattern matching works with any inductive type, such as products and option types. It can also be used for proofs by cases and nested pattern matching. For example:

```lean
def not : Bool → Bool
  | true  => false
  | false => true

theorem not_not : ∀ (b : Bool), not (not b) = b
  | true  => rfl
  | false => rfl
```

## 8.2. Wildcards and Overlapping Patterns

Wildcards (`_`) can be used in patterns to ignore certain values. Overlapping patterns are resolved by Lean using the first applicable equation. For example:

```lean
def foo : Nat → Nat → Nat
  | 0, _ => 0
  | _, 0 => 1
  | _, _ => 2
```

## 8.3. Structural Recursion and Induction

Lean supports structural recursion, where recursive calls are made on structurally smaller arguments. For example:

```lean
def add : Nat → Nat → Nat
  | m, 0     => m
  | m, n + 1 => add m n + 1

def fib : Nat → Nat
  | 0     => 1
  | 1     => 1
  | n + 2 => fib (n + 1) + fib n
```

## 8.4. Local Recursive Declarations

Local recursive functions can be defined using `let rec` or `where` clauses. For example:

```lean
def replicate (n : Nat) (a : α) : List α :=
  let rec loop : Nat → List α → List α
    | 0, as => as
    | n+1, as => loop n (a :: as)
  loop n []
```

## 8.5. Well-Founded Recursion and Induction

When structural recursion cannot be used, well-founded recursion ensures termination using a well-founded relation. For example:

```lean
def div (x y : Nat) : Nat :=
  if h : 0 < y ∧ y ≤ x then
    div (x - y) y + 1
  else
    0
```

## 8.6. Functional Induction

Lean generates induction principles for recursive functions, allowing proofs to follow the recursive structure of the function. For example:

```lean
def ack : Nat → Nat → Nat
  | 0, y => y + 1
  | x + 1, 0 => ack x 1
  | x + 1, y + 1 => ack x (ack (x + 1) y)

theorem ack_gt_zero : ack n m > 0 := by
  fun_induction ack <;> simp [*, ack]
```

## 8.7. Mutual Recursion

Lean supports mutual recursion, where functions are defined in terms of each other. For example:

```lean
mutual
  def even : Nat → Bool
    | 0   => true
    | n+1 => odd n

  def odd : Nat → Bool
    | 0   => false
    | n+1 => even n
end
```

## 8.8. Dependent Pattern Matching

Dependent pattern matching simplifies working with indexed inductive families. For example:

```lean
def head : {n : Nat} → Vect α (n+1) → α
  | cons a as => a

def tail : {n : Nat} → Vect α (n+1) → Vect α n
  | cons a as => as
```

## 8.9. Inaccessible Patterns

Inaccessible patterns (`.(t)`) are used to clarify definitions and control dependent pattern matching. For example:

```lean
def inverse {f : α → β} : (b : β) → ImageOf f b → α
  | .(f a), imf a => a
```

## 8.10. Match Expressions

Match expressions allow pattern matching anywhere in an expression. For example:

```lean
def isNotZero (m : Nat) : Bool :=
  match m with
  | 0     => false
  | n + 1 => true
```

## 8.11. Exercises

1. Define addition, multiplication, and exponentiation on natural numbers using the equation compiler.
2. Define basic operations on lists (e.g., reverse) and prove properties like `reverse (reverse xs) = xs`.
3. Implement course-of-value recursion on natural numbers.
4. Define a function to append two vectors using dependent pattern matching.
5. Define and evaluate arithmetic expressions using the `Expr` type, and implement constant fusion.