# Chapter 3: Propositions and Proofs

## 3.1 Propositions as Types
- **Propositions as Types**: Propositions (`Prop`) are types, and proofs are their inhabitants.
  ```lean
  #check And
  And (a b : Prop) : Prop
  ```
- **Constructors for Propositions**:
  - `And`, `Or`, `Not`, `Implies`.
  ```lean
  #check And p q
  p ∧ q : Prop
  ```
- **Proofs as Terms**: Proofs are terms of type `Proof p`.
  ```lean
  axiom and_commut (p q : Prop) : Proof (Implies (And p q) (And q p))
  ```
- **Simplifications**:
  - `Proof p` is conflated with `p`.
  - `Implies p q` is equivalent to `p → q`.
  - This is the **Curry-Howard isomorphism**.

## 3.2 Working with Propositions as Types
- **Theorem Command**: Introduces a new theorem.
  ```lean
  theorem t1 : p → q → p := fun hp : p => fun hq : q => hp
  ```
- **Proofs as Functions**: Proofs use lambda abstraction.
  ```lean
  theorem t1 (hp : p) (hq : q) : p := hp
  ```
- **Using Theorems**: Theorems can be applied like functions.
  ```lean
  theorem t2 : q → p := t1 hp
  ```
- **Axioms**: Postulate the existence of a proof.
  ```lean
  axiom unsound : False
  ```
- **Generalization**: Use `∀` to generalize over propositions.
  ```lean
  theorem t1 : ∀ {p q : Prop}, p → q → p :=
    fun {p q : Prop} (hp : p) (hq : q) => hp
  ```

## 3.3 Propositional Logic
- **Logical Connectives**:
  - `True`, `False`, `¬` (not), `∧` (and), `∨` (or), `→` (implies), `↔` (iff).
  ```lean
  #check p → q → p ∧ q
  ```
- **Conjunction**:
  - `And.intro`: Constructs a proof of `p ∧ q`.
  - `And.left`, `And.right`: Extract components of `p ∧ q`.
  ```lean
  example (h : p ∧ q) : q ∧ p :=
    And.intro (And.right h) (And.left h)
  ```
- **Disjunction**:
  - `Or.intro_left`, `Or.intro_right`: Construct proofs of `p ∨ q`.
  - `Or.elim`: Proof by cases.
  ```lean
  example (h : p ∨ q) : q ∨ p :=
    Or.elim h (fun hp => Or.inr hp) (fun hq => Or.inl hq)
  ```
- **Negation and Falsity**:
  - `¬p` is defined as `p → False`.
  - `False.elim`: Derives any proposition from `False`.
  ```lean
  example (hp : p) (hnp : ¬p) : q := False.elim (hnp hp)
  ```
- **Logical Equivalence**:
  - `Iff.intro`: Constructs a proof of `p ↔ q`.
  - `Iff.mp`, `Iff.mpr`: Forward and backward directions.
  ```lean
  theorem and_swap : p ∧ q ↔ q ∧ p :=
    Iff.intro
      (fun h => And.intro (And.right h) (And.left h))
      (fun h => And.intro (And.right h) (And.left h))
  ```

## 3.4 Introducing Auxiliary Subgoals
- **`have` Construct**: Introduces intermediate steps in a proof.
  ```lean
  example (h : p ∧ q) : q ∧ p :=
    have hp : p := h.left
    have hq : q := h.right
    show q ∧ p from And.intro hq hp
  ```
- **`suffices` Construct**: Reason backwards from a goal.
  ```lean
  example (h : p ∧ q) : q ∧ p :=
    have hp : p := h.left
    suffices hq : q from And.intro hq hp
    show q from And.right h
  ```

## 3.5 Classical Logic
- **Law of Excluded Middle**: `p ∨ ¬p`.
  ```lean
  open Classical
  #check em p
  ```
- **Double-Negation Elimination**:
  ```lean
  theorem dne {p : Prop} (h : ¬¬p) : p :=
    Or.elim (em p)
      (fun hp => hp)
      (fun hnp => absurd hnp h)
  ```
- **Proof by Cases**:
  ```lean
  example (h : ¬¬p) : p :=
    byCases
      (fun h1 : p => h1)
      (fun h1 : ¬p => absurd h1 h)
  ```
- **Proof by Contradiction**:
  ```lean
  example (h : ¬¬p) : p :=
    byContradiction
      (fun h1 : ¬p => absurd h1 h)
  ```

## 3.6 Examples of Propositional Validities
- **Common Identities**:
  - Commutativity: `p ∧ q ↔ q ∧ p`, `p ∨ q ↔ q ∨ p`.
  - Associativity: `(p ∧ q) ∧ r ↔ p ∧ (q ∧ r)`.
  - Distributivity: `p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r)`.
  ```lean
  example (p q r : Prop) : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) :=
    Iff.intro
      (fun h =>
        have hp : p := h.left
        Or.elim (h.right)
          (fun hq => Or.inl ⟨hp, hq⟩)
          (fun hr => Or.inr ⟨hp, hr⟩))
      (fun h =>
        Or.elim h
          (fun hpq => ⟨hpq.left, Or.inl hpq.right⟩)
          (fun hpr => ⟨hpr.left, Or.inr hpr.right⟩))
  ```
- **Classical Reasoning**:
  ```lean
  example (p q : Prop) : ¬(p ∧ ¬q) → (p → q) :=
    fun h => fun hp =>
      Or.elim (em q)
        (fun hq => hq)
        (fun hnq => absurd (And.intro hp hnq) h)
  ```