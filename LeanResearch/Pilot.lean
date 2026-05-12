import Mathlib.Data.Real.Sqrt
import Mathlib.Data.Polynomial
import Mathlib.Data.Nat.Prime

namespace LeanResearch


theorem id_nat (n : Nat) : n = n := by
  rfl

theorem and_comm (a b : Prop) : a ∧ b → b ∧ a := by
  intro h
  exact And.intro h.right h.left

theorem imp_trans (a b c : Prop) : (a → b) → (b → c) → a → c := by
  intro hab
  intro hbc
  intro ha
  exact hbc (hab ha)

theorem double_neg (p : Prop) : p → ¬¬p := by
  intro hp
  intro hnp
  exact hnp hp

theorem imp_trans_apply (a b c : Prop) : (a → b) → (b → c) → a → c := by
  intro hab
  intro hbc
  intro ha
  apply hbc
  apply hab
  exact ha

theorem add_zero_rw (n : Nat) : n + 0 = n := by
  rw [Nat.add_zero]

theorem and_true_simp (p : Prop) : (p ∧ True) ↔ p := by
  simp

theorem irrational_sqrt_two : Irrational (Real.sqrt 2) := by
  intro h
  cases h with p q hq
  have hq' : (p : ℝ) ^ 2 = 2 * q ^ 2 := by
    rw [← hq, Real.sqrt_sq]
    exact_mod_cast Nat.zero_lt_bit0 Nat.zero_lt_one
  have hcoprime : Nat.coprime p q := h.coprime
  have : 2 ∣ p := by
    rw [← Nat.dvd_add_iff_left (Nat.dvd_mul_left 2 q)]
    exact_mod_cast hq'.symm
  cases this with k hk
  rw [hk] at hq'
  have : 2 ∣ q := by
    rw [← Nat.dvd_add_iff_left (Nat.dvd_mul_left 2 k)]
    exact_mod_cast hq'.symm
  exact hcoprime.not_dvd_left this

theorem coequiv_pos_of_neg_pos (hc : Coequivalence r) (hxy : ¬r y x) (hxz: r x z) : r y z := by
  have : (r x y) ∨ (r y z) := hc.cotrans hxz
  cases this
  case inr => assumption
  exact cotransitive_pos_of_neg_pos hc.cotransitive (mt hc.symm hxy) hxz

theorem fundamental_theorem_of_algebra {f : Polynomial ℂ} (hf : 0 < f.degree) :
  ∃ z : ℂ, f.IsRoot z := by
  apply Polynomial.exists_root_of_degree_pos hf

theorem getD_replicate_elem_eq {a} (i n) (h : i < n) :
    getD (replicate n a) i b = a := by
  rw [getD, get?_eq_get, get_replicate]
  simp; simp; assumption

/--If the first element of two lists are different, then a sublist relation can be reduced -/
theorem sublist_cons_neq [DecidableEq α] {l l₂ : List α} (h₁: ¬a = b) (h₂ : a :: l <+ b :: l₂) : a :: l <+ l₂ := by
  apply isSublist_iff_sublist.mp
  have := isSublist_iff_sublist.mpr h₂
  rwa [isSublist, if_neg h₁] at this

theorem prime_number_theorem :
  ∀ n : ℕ, ∃ p : ℕ, p > n ∧ Nat.Prime p := by
  intro n
  have h : ∃ p, p > n ∧ Nat.Prime p :=
    Nat.exists_infinite_primes n
  exact h

theorem Nat.primeFactorsList_unique {n : ℕ}  {l : List ℕ}  (h₁ : l.prod = n) (h₂ : ∀ (p : ℕ), p ∈ l → Prime p) :
  l.Perm n.primeFactorsList
