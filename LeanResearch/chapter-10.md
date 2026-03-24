# Chapter 10: Type Classes

## 10. Type Classes

Type classes enable ad-hoc polymorphism in Lean by allowing functions to operate on multiple types through a process called typeclass resolution. For example, addition can be defined generically for any type that implements the `Add` type class:

```lean
class Add (α : Type) where
  add : α → α → α

instance : Add Nat where
  add := Nat.add

def double [Add α] (x : α) : α :=
  Add.add x x

#eval double 10  -- 20
```

Type classes allow implicit arguments to be synthesized automatically, making them powerful for overloading operations and enabling modular design.

## 10.1. Chaining Instances

Typeclass resolution supports chaining, where instances depend on other instances. For example:

```lean
instance [Inhabited α] [Inhabited β] : Inhabited (α × β) where
  default := (default, default)

#eval (default : Nat × Bool)  -- (0, true)
```

This recursive resolution allows complex dependencies between instances.

## 10.2. ToString

The `ToString` type class enables polymorphic string conversion. For example:

```lean
structure Person where
  name : String
  age  : Nat

instance : ToString Person where
  toString p := p.name ++ "@" ++ toString p.age

#eval toString { name := "Leo", age := 542 : Person }  -- "Leo@542"
```

## 10.3. Numerals

Numerals in Lean are polymorphic and rely on the `OfNat` type class:

```lean
structure Rational where
  num : Int
  den : Nat
  inv : den ≠ 0

instance : OfNat Rational n where
  ofNat := { num := n, den := 1, inv := by decide }

#eval (2 : Rational)  -- 2/1
```

## 10.4. Output Parameters

Output parameters allow typeclass resolution to infer additional information. For example:

```lean
class HMul (α : Type u) (β : Type v) (γ : outParam (Type w)) where
  hMul : α → β → γ

instance : HMul Nat Nat Nat where
  hMul := Nat.mul

#eval hMul 4 3  -- 12
```

## 10.5. Default Instances

Default instances provide fallback behavior for typeclass resolution. For example:

```lean
@[default_instance]
instance : HMul Int Int Int where
  hMul := Int.mul
```

## 10.6. Local Instances

Local instances are active only within a specific scope:

```lean
structure Point where
  x : Nat
  y : Nat

section

local instance : Add Point where
  add a b := { x := a.x + b.x, y := a.y + b.y }

def double (p : Point) :=
  p + p

end
```

## 10.7. Scoped Instances

Scoped instances are active only when a namespace is open:

```lean
namespace Point

scoped instance : Add Point where
  add a b := { x := a.x + b.x, y := a.y + b.y }

def double (p : Point) :=
  p + p

end
```

## 10.8. Decidable Propositions

The `Decidable` type class determines whether a proposition is true or false. For example:

```lean
def step (a b x : Nat) : Nat :=
  if x < a ∨ x > b then 0 else 1
```

The `Decidable` type class enables computational definitions while supporting classical reasoning when needed.

## 10.9. Managing Type Class Inference

Typeclass inference can be managed using tools like `inferInstance` and priorities:

```lean
def foo : Add Nat := inferInstance
instance (priority := default + 1) i1 : Foo where
  a := 1
  b := 1
```

## 10.10. Coercions using Type Classes

Lean supports coercions between types using the `Coe` type class. For example:

```lean
instance : Coe Bool Prop where
  coe b := b = true

#eval if true then 5 else 3  -- 5
```

Coercions can also be defined for dependent types and functions, enabling seamless integration of different types.