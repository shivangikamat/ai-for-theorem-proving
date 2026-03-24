# Chapter 5: Tactics

## 5.1 Entering Tactic Mode

- **Tactic Mode**: Allows constructing proofs incrementally using commands.
- **Example**:
  ```lean
  theorem test (p q : Prop) (hp : p) (hq : q) : p ∧ q ∧ p := by
    apply And.intro
    exact hp
    apply And.intro
    exact hq
    exact hp
  ```
- **Commands**:
  - `apply`: Applies a function to match the goal.
  - `exact`: Matches the goal exactly with the given term.
  - `case`: Focuses on specific subgoals.
  - `.`: Structures proofs with indentation.

## 5.2 Basic Tactics

- **`intro`**: Introduces variables or hypotheses.
  ```lean
  example (α : Type) : α → α := by
    intro a
    exact a
  ```
- **`assumption`**: Matches the goal with an existing hypothesis.
- **`rfl`**: Solves goals involving reflexive equality.
- **`repeat`**: Repeats a tactic until failure.
- **`revert`**: Moves hypotheses back into the goal.
- **`generalize`**: Replaces terms in the goal with variables.

## 5.3 More Tactics

- **`cases`**: Decomposes disjunctions, conjunctions, or inductive types.
  ```lean
  example (p q : Prop) : p ∨ q → q ∨ p := by
    intro h
    cases h with
    | inl hp => apply Or.inr; exact hp
    | inr hq => apply Or.inl; exact hq
  ```
- **`constructor`**: Applies the first applicable constructor.
- **`exists`**: Provides a witness for existential quantifiers.
- **`contradiction`**: Finds contradictions in the context.
- **`match`**: Matches patterns in tactic blocks.

## 5.4 Structuring Tactic Proofs

- **Mixing Term and Tactic Styles**: Combine `have`, `show`, and `by` blocks.
  ```lean
  example (p q r : Prop) : p ∧ (q ∨ r) → (p ∧ q) ∨ (p ∧ r) := by
    intro h
    exact
      have hp : p := h.left
      have hqr : q ∨ r := h.right
      show (p ∧ q) ∨ (p ∧ r) by
        cases hqr with
        | inl hq => exact Or.inl ⟨hp, hq⟩
        | inr hr => exact Or.inr ⟨hp, hr⟩
  ```
- **`have` and `let`**: Introduce auxiliary facts or local definitions.
- **Nested Blocks**: Use `.` or `{}` to structure proofs.

## 5.5 Tactic Combinators

- **Sequencing**: `t₁; t₂` applies `t₁` then `t₂`.
- **Parallel Sequencing**: `t₁ <;> t₂` applies `t₂` to all subgoals of `t₁`.
- **`first`**: Tries multiple tactics until one succeeds.
- **`try`**: Ensures a tactic always succeeds.
- **`all_goals`**: Applies a tactic to all goals.
- **`any_goals`**: Applies a tactic to at least one goal.

## 5.6 Rewriting

- **`rw`**: Rewrites goals or hypotheses using equalities.
  ```lean
  example (k : Nat) (f : Nat → Nat) (h₁ : f 0 = 0) (h₂ : k = 0) : f k = 0 := by
    rw [h₂, h₁]
  ```
- **Direction**: Use `←` to rewrite in reverse.
- **Targeting Hypotheses**: `rw [t] at h` rewrites hypothesis `h`.

## 5.7 Using the Simplifier

- **`simp`**: Simplifies goals using known identities.
  ```lean
  example (x y z : Nat) : (x + 0) * (0 + y * 1 + z * 0) = x * y := by
    simp
  ```
- **Custom Rules**: Add `[simp]` attribute to lemmas.
- **Targeting Hypotheses**: `simp at h` simplifies `h`.
- **Wildcard**: `simp at *` simplifies all hypotheses and the goal.

## 5.8 Split Tactic

- **`split`**: Decomposes match or if-then-else expressions.
  ```lean
  def f (x y z : Nat) : Nat :=
    match x, y, z with
    | 5, _, _ => y
    | _, 5, _ => y
    | _, _, 5 => y
    | _, _, _ => 1

  example (x y z : Nat) : x ≠ 5 → y ≠ 5 → z ≠ 5 → z = w → f x y w = 1 := by
    intros; simp [f]; split <;> first | contradiction | rfl
  ```

## 5.9 Extensible Tactics

- **Custom Tactics**: Define new tactics using `syntax` and `macro_rules`.
  ```lean
  syntax "triv" : tactic

  macro_rules
    | `(tactic| triv) => `(tactic| assumption)
  ```

## 5.10 Exercises

1. Redo exercises from Chapters 3 and 4 using tactics.
2. Use tactic combinators to prove:
   ```lean
   example (p q r : Prop) (hp : p)
           : (p ∨ q ∨ r) ∧ (q ∨ p ∨ r) ∧ (q ∨ r ∨ p) := by
     sorry
   ```