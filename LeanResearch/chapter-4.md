# Chapter 4: Quantifiers and Equality

## 4.1 The Universal Quantifier

- **Unary and Binary Predicates**: A unary predicate `p` on a type `α` is represented as `α → Prop`. A binary relation `r` on `α` is represented as `α → α → Prop`.
- **Universal Quantifier**: `∀ x : α, p x` asserts that `p x` holds for every `x : α`.
  - **Introduction Rule**: Given a proof of `p x` in a context where `x : α` is arbitrary, we obtain a proof of `∀ x : α, p x`.
  - **Elimination Rule**: Given a proof of `∀ x : α, p x` and any term `t : α`, we obtain a proof of `p t`.
- **Propositions-as-Types**: The universal quantifier corresponds to dependent arrow types `(x : α) → β x`.
- **Examples**:
  ```lean
  example (α : Type) (p q : α → Prop) :
      (∀ x : α, p x ∧ q x) → ∀ y : α, p y :=
    fun h : ∀ x : α, p x ∧ q x =>
    fun y : α =>
    show p y from (h y).left
  ```
- **Implicit Arguments**: Arguments can be made implicit to simplify expressions.

## 4.2 Equality

- **Equality as an Equivalence Relation**:
  - Reflexivity: `Eq.refl`
  - Symmetry: `Eq.symm`
  - Transitivity: `Eq.trans`
- **Projection Notation**: Simplifies expressions, e.g., `(hab.trans hcb.symm).trans hcd`.
- **Substitution**: `Eq.subst` allows substitution of equal terms in proofs.
- **Congruence Rules**:
  - `congrArg`: Replace the argument of a function.
  - `congrFun`: Replace the function being applied.
  - `congr`: Replace both the function and the argument.
- **Examples**:
  ```lean
  example (α : Type) (a b : α) (p : α → Prop)
          (h1 : a = b) (h2 : p a) : p b :=
    Eq.subst h1 h2
  ```

## 4.3 Calculational Proofs

- **Syntax**:
  ```lean
  calc
    <expr>_0  'op_1'  <expr>_1  ':='  <proof>_1
    '_'       'op_2'  <expr>_2  ':='  <proof>_2
  ```
- **Example**:
  ```lean
  theorem T
      (h1 : a = b)
      (h2 : b = c + 1)
      (h3 : c = d)
      (h4 : e = 1 + d) :
      a = e :=
    calc
      a = b      := h1
      _ = c + 1  := h2
      _ = d + 1  := congrArg Nat.succ h3
      _ = 1 + d  := Nat.add_comm d 1
      _ = e      := Eq.symm h4
  ```
- **Tactics**:
  - `rw`: Rewrite using equalities.
  - `simp`: Simplify using known identities.

## 4.4 The Existential Quantifier

- **Definition**: `∃ x : α, p x` asserts the existence of an `x` such that `p x` holds.
- **Introduction Rule**: To prove `∃ x : α, p x`, provide a term `t` and a proof of `p t`.
- **Elimination Rule**: From `∃ x : α, p x`, derive `q` by showing `q` follows from `p w` for an arbitrary `w`.
- **Examples**:
  ```lean
  example : ∃ x : Nat, x > 0 :=
    Exists.intro 1 (Nat.zero_lt_succ 0)
  ```
- **Anonymous Constructor Notation**: `⟨t, h⟩` for `Exists.intro t h`.
- **Match Statement**: Deconstructs existential assertions.
  ```lean
  example (h : ∃ x, p x ∧ q x) : ∃ x, q x ∧ p x :=
    match h with
    | ⟨w, hw⟩ => ⟨w, hw.right, hw.left⟩
  ```

## 4.5 More on the Proof Language

- **Anonymous `have` Expressions**: Introduce auxiliary goals without labels.
- **`by assumption`**: Automatically prove goals using local context.
- **French Quotation Marks**: `‹p›` refers to a proposition `p` in the context.
- **Example**:
  ```lean
  variable (f : Nat → Nat)
  variable (h : ∀ x : Nat, f x ≤ f (x + 1))

  example : f 0 ≤ f 3 :=
    have : f 0 ≤ f 1 := h 0
    have : f 0 ≤ f 2 := Nat.le_trans ‹f 0 ≤ f 1› (h 1)
    show f 0 ≤ f 3 from Nat.le_trans ‹f 0 ≤ f 2› (h 2)
  ```

## 4.6 Exercises

1. Prove equivalences involving universal quantifiers:
   - `(∀ x, p x ∧ q x) ↔ (∀ x, p x) ∧ (∀ x, q x)`
   - `(∀ x, p x → q x) → (∀ x, p x) → (∀ x, q x)`
   - `(∀ x, p x) ∨ (∀ x, q x) → ∀ x, p x ∨ q x`

2. Prove equivalences involving existential quantifiers:
   - `(∃ x, p x ∧ q x) ↔ (∃ x, p x) ∧ (∃ x, q x)`
   - `(∃ x, p x ∨ q x) ↔ (∃ x, p x) ∨ (∃ x, q x)`

3. Solve the barber paradox:
   ```lean
   variable (men : Type) (barber : men)
   variable (shaves : men → men → Prop)

   example (h : ∀ x : men, shaves barber x ↔ ¬ shaves x x) : False :=
     sorry
   ```

4. Define and prove properties of primes and Fermat primes:
   ```lean
   def prime (n : Nat) : Prop := sorry
   def Fermat_prime (n : Nat) : Prop := sorry
   ```