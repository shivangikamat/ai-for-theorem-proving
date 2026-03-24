# Chapter 11: The Conversion Tactic Mode

## 11. The Conversion Tactic Mode

The `conv` keyword in Lean allows you to enter conversion mode within a tactic block. This mode enables precise navigation and rewriting within assumptions, goals, and even inside function abstractions or dependent arrows.

## 11.1. Basic Navigation and Rewriting

Conversion mode provides tools for navigating and rewriting specific parts of a goal. For example:

```lean
example (a b c : Nat) : a * (b * c) = a * (c * b) := by
  conv =>
    lhs
    congr
    . rfl
    . rw [Nat.mul_comm]
```

### Key Commands:
- `lhs`: Navigate to the left-hand side of a relation.
- `rhs`: Navigate to the right-hand side of a relation.
- `congr`: Create subgoals for each argument of the current head function.
- `rfl`: Close the goal using reflexivity.

Rewriting under binders is also possible:

```lean
example : (fun x : Nat => 0 + x) = (fun x => x) := by
  conv =>
    lhs
    intro x
    rw [Nat.zero_add]
```

## 11.2. Pattern Matching

Pattern matching simplifies navigation in conversion mode. For example:

```lean
example (a b c : Nat) : a * (b * c) = a * (c * b) := by
  conv in b * c =>
    rw [Nat.mul_comm]
```

This is equivalent to:

```lean
example (a b c : Nat) : a * (b * c) = a * (c * b) := by
  conv =>
    pattern b * c
    rw [Nat.mul_comm]
```

Wildcards can also be used:

```lean
example (a b c : Nat) : a * (b * c) = a * (c * b) := by
  conv in _ * c => rw [Nat.mul_comm]
```

## 11.3. Structuring Conversion Tactics

Curly brackets and `.` can structure conversion tactics:

```lean
example (a b c : Nat) : (0 + a) * (b * c) = a * (c * b) := by
  conv =>
    lhs
    congr
    . rw [Nat.zero_add]
    . rw [Nat.mul_comm]
```

## 11.4. Other Tactics Inside Conversion Mode

### Additional Commands:
- `arg i`: Navigate to the i-th argument of an application.
- `args`: Alias for `congr`.
- `simp`: Simplify the current goal.
- `enter [args]`: Iterate `arg` and `intro` with the given arguments.
- `done`: Fail if there are unsolved goals.
- `trace_state`: Display the current tactic state.
- `whnf`: Put the term in weak head normal form.
- `tactic => <tactic sequence>`: Return to regular tactic mode.

### Examples:

#### Using `arg`:

```lean
example (a b c : Nat) : a * (b * c) = a * (c * b) := by
  conv =>
    lhs
    arg 2
    rw [Nat.mul_comm]
```

#### Using `simp`:

```lean
def f (x : Nat) :=
  if x > 0 then x + 1 else x + 2

example (g : Nat → Nat)
    (h₁ : g x = x + 1) (h₂ : x > 0) :
    g x = f x := by
  conv =>
    rhs
    simp [f, h₂]
  exact h₁
```

#### Using `tactic =>`:

```lean
example (g : Nat → Nat → Nat)
        (h₁ : ∀ x, x ≠ 0 → g x x = 1)
        (h₂ : x ≠ 0)
        : g x x + x = 1 + x := by
  conv =>
    lhs
    arg 1
    rw [h₁]
    . skip
    . tactic => exact h₂
```

#### Using `apply`:

```lean
example (g : Nat → Nat → Nat)
        (h₁ : ∀ x, x ≠ 0 → g x x = 1)
        (h₂ : x ≠ 0)
        : g x x + x = 1 + x := by
  conv =>
    lhs
    arg 1
    rw [h₁]
    . skip
    . apply h₂
```

