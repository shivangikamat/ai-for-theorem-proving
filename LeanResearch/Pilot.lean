import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Algebra.Algebra.Rat
import Mathlib.Data.Nat.Prime.Int
import Mathlib.Data.Rat.Sqrt
import Mathlib.Data.Real.Sqrt
import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Tactic.IntervalCases

open Rat Real

/-- A real number is irrational if it is not equal to any rational number. -/
def Irrational (x : ℝ) :=
  x ∉ Set.range ((↑) : ℚ → ℝ)

theorem irrational_iff_ne_rational (x : ℝ) : Irrational x ↔ ∀ a b : ℤ, b ≠ 0 → x ≠ a / b := by
  simp [Irrational, Rat.forall, eq_comm]

theorem Irrational.ne_rational {x : ℝ} (hx : Irrational x) (a b : ℤ) : x ≠ a / b := by
  rintro rfl; exact hx ⟨a / b, by simp⟩

theorem exists_rat_of_not_irrational {x : ℝ} (hx : ¬ Irrational x) : ∃ (q : ℚ), x = q := by
  grind [Irrational]

/-- A transcendental real number is irrational. -/
theorem Transcendental.irrational {r : ℝ} (tr : Transcendental ℚ r) : Irrational r := by
  rintro ⟨a, rfl⟩
  exact tr (isAlgebraic_algebraMap a)

@[simp] theorem not_irrational_zero : ¬Irrational 0 := not_not_intro ⟨0, Rat.cast_zero⟩
@[simp] theorem not_irrational_one : ¬Irrational 1 := not_not_intro ⟨1, Rat.cast_one⟩

theorem irrational_sqrt_ratCast_iff_of_nonneg {q : ℚ} (hq : 0 ≤ q) :
    Irrational (√q) ↔ ¬IsSquare q := by
  refine Iff.not (?_ : Exists _ ↔ Exists _)
  constructor
  · rintro ⟨y, hy⟩
    refine ⟨y, Rat.cast_injective (α := ℝ) ?_⟩
    rw [Rat.cast_mul, hy, mul_self_sqrt (Rat.cast_nonneg.2 hq)]
  · rintro ⟨q', rfl⟩
    exact ⟨|q'|, mod_cast (sqrt_mul_self_eq_abs q').symm⟩

theorem irrational_sqrt_ratCast_iff {q : ℚ} :
    Irrational (√q) ↔ ¬IsSquare q ∧ 0 ≤ q := by
  obtain hq | hq := le_or_gt 0 q
  · simp_rw [irrational_sqrt_ratCast_iff_of_nonneg hq, and_iff_left hq]
  · rw [sqrt_eq_zero_of_nonpos (Rat.cast_nonpos.2 hq.le)]
    simp_rw [not_irrational_zero, false_iff, not_and, not_le, hq, implies_true]

theorem irrational_sqrt_intCast_iff_of_nonneg {z : ℤ} (hz : 0 ≤ z) :
    Irrational (√z) ↔ ¬IsSquare z := by
  rw [← Rat.isSquare_intCast_iff, ← irrational_sqrt_ratCast_iff_of_nonneg (mod_cast hz),
    Rat.cast_intCast]

theorem irrational_sqrt_intCast_iff {z : ℤ} :
    Irrational (√z) ↔ ¬IsSquare z ∧ 0 ≤ z := by
  rw [← Rat.cast_intCast, irrational_sqrt_ratCast_iff, Rat.isSquare_intCast_iff,
    Int.cast_nonneg_iff]

theorem irrational_sqrt_natCast_iff {n : ℕ} : Irrational (√n) ↔ ¬IsSquare n := by
  rw [← Rat.isSquare_natCast_iff, ← irrational_sqrt_ratCast_iff_of_nonneg n.cast_nonneg,
    Rat.cast_natCast]

theorem irrational_sqrt_ofNat_iff {n : ℕ} [n.AtLeastTwo] :
    Irrational √(ofNat(n)) ↔ ¬IsSquare ofNat(n) :=
  irrational_sqrt_natCast_iff

theorem Nat.Prime.irrational_sqrt {p : ℕ} (hp : Nat.Prime p) : Irrational (√p) :=
  irrational_sqrt_natCast_iff.mpr hp.not_isSquare

/-- **Irrationality of the Square Root of 2** -/
theorem irrational_sqrt_two : Irrational (√2) := by
  simpa using Nat.prime_two.irrational_sqrt

namespace LeanResearch

-- 1. Basic Logic and Nat
theorem id_nat (n : Nat) : n = n := by
  rfl

theorem and_comm (a b : Prop) : a ∧ b → b ∧ a := by
  intro h
  exact ⟨h.right, h.left⟩

theorem imp_trans (a b c : Prop) : (a → b) → (b → c) → a → c := by
  intro hab hbc ha
  exact hbc (hab ha)

theorem double_neg (p : Prop) : p → ¬¬p := by
  intro hp hnp
  exact hnp hp

theorem imp_trans_apply (a b c : Prop) : (a → b) → (b → c) → a → c := by
  intro hab hbc ha
  apply hbc
  apply hab
  exact ha

theorem add_zero_rw (n : Nat) : n + 0 = n := by
  rw [Nat.add_zero]

theorem and_true_simp (p : Prop) : (p ∧ True) ↔ p := by
  simp

-- 2. Irrationality of Sqrt 2
theorem irrational_sqrt_two : Irrational (√2) := by
  simpa using Nat.prime_two.irrational_sqrt

-- 3. Coequivalence Logic
/-- A definition of Coequivalence (negation of Equivalence) -/
structure Coequivalence (r : α → α → Prop) : Prop where
  coreflexive : ∀ x, ¬ r x x
  symm : ∀ {x y}, r x y → r y x
  cotrans : ∀ {x y z}, r x z → r x y ∨ r y z

-- 6. Number Theory
theorem prime_number_theorem :
  ∀ n : ℕ, ∃ p : ℕ, p >= n ∧ Nat.Prime p := by
  intro n
  exact Nat.exists_infinite_primes n

theorem Nat.primeFactorsList_unique_fixed {n : ℕ} {l : List ℕ}
    (h₁ : l.prod = n) (h₂ : ∀ p ∈ l, Nat.Prime p) :
  l.Perm n.primeFactorsList := by
  apply Nat.primeFactorsList_unique
  · exact h₁
  · intro p hp
    exact (h₂ p hp)

end LeanResearch
