# Chapter 2: Dependent Type Theory

## 2.1 Simple Type Theory
- **Type Theory Basics**: Every expression has an associated type.
  - Example: `x + 0` is a natural number, `f` is a function on natural numbers.
- **Defining Constants**: Use `def` to declare constants.
  ```lean
  def m : Nat := 1       -- m is a natural number
  def n : Nat := 0
  ```
- **Checking Types**: Use `#check` to query types.
  ```lean
  #check m
  m : Nat
  ```
- **Evaluating Expressions**: Use `#eval` to evaluate.
  ```lean
  #eval 5 * 4
  20
  ```
- **Building New Types**:
  - `a -> b`: Type of functions from `a` to `b`.
  - `a × b`: Cartesian product (pairs of `a` and `b`).
  ```lean
  #check Nat → Nat
  Nat → Nat : Type
  ```
- **Unicode in Lean**:
  - `→` entered as `\to` or `\r`.
  - `×` entered as `\times`.
  - Greek letters like `α` entered as `\a`.
- **Function Application**: `f x` applies function `f` to `x`.
  ```lean
  #check Nat.add 3
  Nat.add 3 : Nat → Nat
  ```
- **Pairs**: `(m, n)` creates a pair, `p.1` and `p.2` extract components.
  ```lean
  #check (5, 9).1
  (5, 9).fst : Nat
  ```

## 2.2 Types as Objects
- **Types as First-Class Citizens**: Types like `Nat` and `Bool` are objects.
  ```lean
  #check Nat
  Nat : Type
  ```
- **Declaring New Constants for Types**:
  ```lean
  def α : Type := Nat
  def β : Type := Bool
  ```
- **Type Hierarchy**: Infinite hierarchy of types.
  ```lean
  #check Type
  Type : Type 1
  ```
  - `Type 0` (or `Type`) is the universe of small types.
  - `Type 1` contains `Type 0`, `Type 2` contains `Type 1`, etc.
- **Polymorphic Functions**: Functions like `List` work across type universes.
  ```lean
  #check List
  List.{u} (α : Type u) : Type u
  ```
- **Defining Polymorphic Constants**: Use `universe` to declare universe variables.
  ```lean
  universe u
  def F (α : Type u) : Type u := Prod α α
  ```

## 2.3 Function Abstraction and Evaluation
- **Lambda Abstraction**: Use `fun` or `λ` to define functions.
  ```lean
  #check fun (x : Nat) => x + 5
  fun x => x + 5 : Nat → Nat
  ```
- **Function Evaluation**: Pass parameters to evaluate.
  ```lean
  #eval (λ x : Nat => x + 5) 10
  15
  ```
- **Examples**:
  ```lean
  #check fun x : Nat => fun y : Bool => if not y then x + 1 else x + 2
  ```
- **Identity and Composition**:
  ```lean
  def f (n : Nat) : String := toString n
  def g (s : String) : Bool := s.length > 0
  ```
- **General Lambda Expressions**:
  ```lean
  #check fun (α β γ : Type) (g : β → γ) (f : α → β) (x : α) => g (f x)
  ```

## 2.4 Definitions
- **Defining Functions**: Use `def` to declare named objects.
  ```lean
  def double (x : Nat) : Nat :=
    x + x
  ```
- **Type Inference**: Lean can infer types.
  ```lean
  def double :=
    fun (x : Nat) => x + x
  ```
- **Multiple Parameters**:
  ```lean
  def add (x y : Nat) :=
    x + y
  ```
- **Local Definitions**: Use `let` for local definitions.
  ```lean
  def twice_double (x : Nat) : Nat :=
    let y := x + x; y * y
  ```

## 2.5 Variables and Sections
- **Variables**: Use `variable` to declare reusable variables.
  ```lean
  variable (α β γ : Type)
  ```
- **Sections**: Limit variable scope with `section`.
  ```lean
  section useful
    variable (α β γ : Type)
  end useful
  ```

## 2.6 Namespaces
- **Grouping Definitions**: Use `namespace` to group related definitions.
  ```lean
  namespace Foo
    def a : Nat := 5
  end Foo
  ```
- **Accessing Namespaces**: Use `Foo.a` to access.
  ```lean
  #check Foo.a
  ```
- **Opening Namespaces**: Use `open` to bring definitions into scope.
  ```lean
  open Foo
  ```

## 2.7 Dependent Type Theory
- **Dependent Types**: Types can depend on parameters.
  ```lean
  def cons (α : Type) (a : α) (as : List α) : List α :=
    List.cons a as
  ```
- **Dependent Function Types**: `(a : α) → β a` denotes functions where output type depends on input.
  ```lean
  #check @List.cons
  ```
- **Dependent Cartesian Products**: `(a : α) × β a` generalizes Cartesian products.
  ```lean
  def f (α : Type u) (β : α → Type v) (a : α) (b : β a) : (a : α) × β a :=
    ⟨a, b⟩
  ```

## 2.8 Implicit Arguments
- **Implicit Arguments**: Use `_` to let Lean infer arguments.
  ```lean
  #check Lst.cons _ 0 (Lst.nil _)
  ```
- **Curly Braces**: Declare arguments as implicit by default.
  ```lean
  def Lst.cons {α : Type u} (a : α) (as : Lst α) : Lst α := List.cons a as
  ```
- **Explicit Arguments**: Use `@` to make all arguments explicit.
  ```lean
  #check @id Nat 1
  ```