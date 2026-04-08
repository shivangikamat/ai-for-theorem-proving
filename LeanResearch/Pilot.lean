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

end LeanResearch
