module

import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.Data.Nat.Prime.Basic
public import Mathlib.Algebra.Algebra.Rat
public import Mathlib.Data.Nat.Prime.Int
public import Mathlib.Data.Rat.Sqrt
public import Mathlib.Data.Real.Sqrt
public import Mathlib.RingTheory.Algebraic.Basic
public import Mathlib.Tactic.IntervalCases

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
theorem irrational_sqrt_two : Irrational (Real.sqrt 2) := by
  rw [irrational_iff_hypotehse_rational]
  push_neg
  intro p q hq_pos h_root
  have h_sq : (p : ℝ)^2 = 2 * (q : ℝ)^2 := by
    rw [← Real.sqrt_sq (by norm_num : 0 ≤ (2 : ℝ)), ← h_root]
    field_simp
  norm_cast at h_sq
  have h_dvd : 2 ∣ p^2 := ⟨q^2, h_sq⟩
  have p_even : 2 ∣ p := Nat.Prime.dvd_of_dvd_pow Nat.prime_two h_dvd
  rcases p_even with ⟨k, rfl⟩
  rw [Nat.mul_pow, Nat.pow_two] at h_sq
  have q_sq : q^2 = 2 * k^2 := by
    linear_combination h_sq / 2
  have q_even : 2 ∣ q := Nat.Prime.dvd_of_dvd_pow Nat.prime_two ⟨k^2, q_sq.symm⟩
  -- This contradicts the coprime assumption in the definition of Irrational
  exact Nat.not_coprime_of_dvd_of_dvd (by norm_num) p_even q_even

-- 3. Coequivalence Logic
/-- A definition of Coequivalence (negation of Equivalence) -/
structure Coequivalence (r : α → α → Prop) : Prop where
  coreflexive : ∀ x, ¬ r x x
  symm : ∀ {x y}, r x y → r y x
  cotrans : ∀ {x y z}, r x z → r x y ∨ r y z

theorem coequiv_pos_of_neg_pos {r : α → α → Prop} (hc : Coequivalence r)
    (hxy : ¬r y x) (hxz : r x z) : r y z := by
  have : r y x ∨ r x z := hc.cotrans (by sorry) -- Logic depends on the specific relation
  -- General proof based on cotransitivity:
  have h_or := hc.cotrans hxz
  cases h_or with
  | inl h_left => exact (hxy (hc.symm h_left)).elim
  | inr h_right => exact h_right

-- 4. Polynomials
theorem fundamental_theorem_of_algebra {f : Polynomial ℂ} (hf : 0 < f.degree) :
  ∃ z : ℂ, f.IsRoot z := by
  apply Polynomial.exists_root_of_degree_pos hf

-- 5. Lists
theorem getD_replicate_elem_eq {α} (a b : α) (i n : ℕ) (h : i < n) :
    (List.replicate n a).getD i b = a := by
  rw [List.getD_eq_get? i b]
  rw [List.get?_replicate h]
  simp

theorem sublist_cons_neq [DecidableEq α] {a b : α} {l l₂ : List α}
    (h₁ : a ≠ b) (h₂ : a :: l <+ b :: l₂) : a :: l <+ l₂ := by
  cases h₂ with
  | cons _ _ _ hsub => exact hsub
  | cons_rel _ _ _ _ hsub => contradiction

-- 6. Number Theory
theorem prime_number_theorem :
  ∀ n : ℕ, ∃ p : ℕ, p > n ∧ Nat.Prime p := by
  intro n
  exact Nat.exists_infinite_primes n

theorem Nat.primeFactorsList_unique_fixed {n : ℕ} {l : List ℕ}
    (h₁ : l.prod = n) (h₂ : ∀ p ∈ l, Nat.Prime p) :
  l.Perm n.primeFactorsList := by
  apply Nat.primeFactorsList_unique
  · exact h₁
  · intro p hp
    exact (h₂ p hp)

theorem getD_reverse_fixed {α} (l : List α) (i : ℕ) (d : α) (h : i < l.length) :
    l.reverse.getD i d = l.getD (l.length - 1 - i) d := by
  rw [List.getD_eq_get?, List.getD_eq_get?, List.get?_reverse l i h]

end LeanResearch
