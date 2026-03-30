def hello := "world"


/- Define some constants. -/

def m : Nat := 1
def n : Nat := 0
def b1 : Bool := true
def b2 : Bool := false

/- Check their types. -/

#check m
#check n
#check n + 0
#check m * (n + 0)
#check b1
#check b1 && b2
#check b1 || b2
#check true

/- Evaluate -/

#eval 5 * 4
#eval m + 2
#eval b1 && b2

#check List

#check let y := 2 + 2; let z := y + y; z * z#eval  let y := 2 + 2; let z := y + y; z * z

open Classical

-- distributivity
example (p q r : Prop) : p ∧ (q ∨ r) ↔ (p ∧ q) ∨ (p ∧ r) :=
  Iff.intro
    (fun h : p ∧ (q ∨ r) =>
      have hp : p := h.left
      Or.elim (h.right)
        (fun hq : q =>
          show (p ∧ q) ∨ (p ∧ r) from Or.inl ⟨hp, hq⟩)
        (fun hr : r =>
          show (p ∧ q) ∨ (p ∧ r) from Or.inr ⟨hp, hr⟩))
    (fun h : (p ∧ q) ∨ (p ∧ r) =>
      Or.elim h
        (fun hpq : p ∧ q =>
          have hp : p := hpq.left
          have hq : q := hpq.right
          show p ∧ (q ∨ r) from ⟨hp, Or.inl hq⟩)
        (fun hpr : p ∧ r =>
          have hp : p := hpr.left
          have hr : r := hpr.right
          show p ∧ (q ∨ r) from ⟨hp, Or.inr hr⟩))

-- an example that requires classical reasoning
example (p q : Prop) : ¬(p ∧ ¬q) → (p → q) :=
  fun h : ¬(p ∧ ¬q) =>
  fun hp : p =>
  show q from
    Or.elim (em q)
      (fun hq : q => hq)
      (fun hnq : ¬q => absurd (And.intro hp hnq) h)

inductive Weekday where
  | sunday : Weekday
  | monday : Weekday
  | tuesday : Weekday
  | wednesday : Weekday
  | thursday : Weekday
  | friday : Weekday
  | saturday : Weekday


/- Define a function that takes a weekday and returns the next weekday. -/
def nextDay : Weekday → Weekday
  | Weekday.sunday => Weekday.monday
  | Weekday.monday => Weekday.tuesday
  | Weekday.tuesday => Weekday.wednesday
  | Weekday.wednesday => Weekday.thursday
  | Weekday.thursday => Weekday.friday
  | Weekday.friday => Weekday.saturday
  | Weekday.saturday => Weekday.sunday

/- Define a function that takes a weekday and returns the previous weekday. -/
def prevDay : Weekday → Weekday
  | Weekday.sunday => Weekday.saturday
  | Weekday.monday => Weekday.sunday
  | Weekday.tuesday => Weekday.monday
  | Weekday.wednesday => Weekday.tuesday
  | Weekday.thursday => Weekday.wednesday
  | Weekday.friday => Weekday.thursday
  | Weekday.saturday => Weekday.friday
