# Chapter 12: Axioms and Computation

## 12. Axioms and Computation

Lean extends the Calculus of Constructions (CIC) with additional axioms and rules, enabling more theorems to be proven and simplifying proofs. However, these extensions can impact the computational content of definitions and theorems. Lean supports both computational and classical reasoning, allowing users to choose between computational purity and classical methods.

### Key Components:
1. **Propositional Extensionality**: Allows equivalent propositions to be substituted for one another.
2. **Quotient Construction**: Implies function extensionality and supports reasoning about equivalence classes.
3. **Choice Principle**: Produces data from existential propositions but is incompatible with computational interpretation.

## 12.1. Historical and Philosophical Context

Historically, mathematics was computational, focusing on algorithmic solutions. The 19th century introduced abstract reasoning, separating computation from conceptual understanding. Lean supports both constructive and classical approaches, enabling computationally pure reasoning while allowing classical methods.

### Computational Purity:
- Avoids `Prop` entirely.
- Closed terms of type `Nat` evaluate to numerals.
- Proof-irrelevant `Prop` and irreducible theorems separate concerns, enabling reasoning without affecting computation.

## 12.2. Propositional Extensionality

The axiom of propositional extensionality asserts:

```lean
axiom propext {a b : Prop} : (a ↔ b) → a = b
```

This allows equivalent propositions to be treated as equal, enabling substitution in any context. Examples:

```lean
theorem thm₁ (h : a ↔ b) : (c ∧ a ∧ d → e) ↔ (c ∧ b ∧ d → e) :=
  propext h ▸ Iff.refl _

theorem thm₂ (p : Prop → Prop) (h : a ↔ b) (h₁ : p a) : p b :=
  propext h ▸ h₁
```

## 12.3. Function Extensionality

Function extensionality asserts that functions agreeing on all inputs are equal:

```lean
axiom funext {α : Sort u} {β : α → Sort v} {f g : (x : α) → β x}
  (h : ∀ x, f x = g x) : f = g
```

This is consistent with classical set theory but may conflict with constructive views of functions as algorithms. Function extensionality follows from the quotient construction.

### Example:

```lean
def Set (α : Type u) := α → Prop

def empty : Set α := fun _ => False

def inter (a b : Set α) : Set α :=
  fun x => x ∈ a ∧ x ∈ b

theorem inter_self (a : Set α) : a ∩ a = a :=
  setext fun x => Iff.intro (fun ⟨h, _⟩ => h) (fun h => ⟨h, h⟩)
```

## 12.4. Quotients

Quotients allow reasoning about equivalence classes. Lean provides the following constants:

```lean
axiom Quot : {α : Sort u} → (α → α → Prop) → Sort u
axiom Quot.mk : {α : Sort u} → (r : α → α → Prop) → α → Quot r
axiom Quot.ind : ∀ {α : Sort u} {r : α → α → Prop} {β : Quot r → Prop},
  (∀ a, β (Quot.mk r a)) → (q : Quot r) → β q
axiom Quot.lift : {α : Sort u} → {r : α → α → Prop} → {β : Sort u} →
  (f : α → β) → (∀ a b, r a b → f a = f b) → Quot r → β
```

### Example:

```lean
def mod7Rel (x y : Nat) : Prop := x % 7 = y % 7

def f (x : Nat) : Bool := x % 7 = 0

theorem f_respects (a b : Nat) (h : mod7Rel a b) : f a = f b := by
  simp [mod7Rel, f] at *
  rw [h]

#check (Quot.lift f f_respects : Quot mod7Rel → Bool)
```

## 12.5. Choice

The choice principle asserts:

```lean
axiom choice {α : Sort u} : Nonempty α → α
```

This allows the construction of an element from a nonempty type but blocks meaningful computation. It is equivalent to indefinite description:

```lean
noncomputable def indefiniteDescription {α : Sort u} (p : α → Prop) (h : ∃ x, p x) : {x // p x} :=
  choice <| let ⟨x, px⟩ := h; ⟨⟨x, px⟩⟩
```

## 12.6. The Law of the Excluded Middle

The law of the excluded middle states:

```lean
Classical.em : ∀ (p : Prop), p ∨ ¬p
```

Using Diaconescu's theorem, this can be derived from `choice`, `propext`, and `funext`. Consequences include double-negation elimination, proof by contradiction, and decidability of all propositions.

### Example:

```lean
noncomputable def linv [Inhabited α] (f : α → β) : β → α :=
  fun b : β => if ex : (∃ a : α, f a = b) then choose ex else default

theorem linv_comp_self {f : α → β} [Inhabited α]
                       (inj : ∀ {a b}, f a = f b → a = b)
                       : linv f ∘ f = id :=
  funext fun a =>
    have ex  : ∃ a₁ : α, f a₁ = f a := ⟨a, rfl⟩
    have feq : f (choose ex) = f a  := choose_spec ex
    calc linv f (f a)
      _ = choose ex := rfl
      _ = a         := inj feq
```

Lean's design balances computational and classical reasoning, enabling users to choose the approach that best suits their needs.