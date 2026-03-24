# Chapter 9: Structures and Records

## 9. Structures and Records

Lean's foundational system includes inductive types, which form the basis for constructing a substantial edifice of mathematics. Structures, or records, are non-recursive inductive types with a single constructor. They are widely used in Lean to define types with multiple fields, such as `Point` or `Prod`. Lean provides convenient tools for defining and working with structures, including automatic generation of projection functions and support for inheritance.

## 9.1. Declaring Structures

The `structure` command is used to define structures in Lean. For example:

```lean
structure Point (α : Type u) where
  mk ::
  x : α
  y : α
```

This generates the following:

- A type `Point`.
- A constructor `Point.mk`.
- Projections `Point.x` and `Point.y`.

Example usage:

```lean
def p := Point.mk 10 20
#eval p.x  -- 10
#eval p.y  -- 20
```

Dot notation simplifies access to fields and functions:

```lean
structure Point (α : Type u) where
  x : α
  y : α

def Point.add (p q : Point Nat) :=
  Point.mk (p.x + q.x) (p.y + q.y)

def p : Point Nat := Point.mk 1 2
def q : Point Nat := Point.mk 3 4

#eval p.add q  -- { x := 4, y := 6 }
```

## 9.2. Objects

Lean provides convenient notation for creating objects of a structure type:

```lean
structure Point (α : Type u) where
  x : α
  y : α

#check { x := 10, y := 20 : Point Nat }
#check { y := 20, x := 10 : Point Nat }
```

Fields can be marked as implicit, and Lean will infer unspecified fields if possible. Record updates allow modifying specific fields:

```lean
structure Point (α : Type u) where
  x : α
  y : α

def p : Point Nat := { x := 1, y := 2 }

#eval { p with y := 3 }  -- { x := 1, y := 3 }
#eval { p with x := 4 }  -- { x := 4, y := 2 }
```

## 9.3. Inheritance

Structures can extend other structures, simulating inheritance. For example:

```lean
structure Point (α : Type u) where
  x : α
  y : α

inductive Color where
  | red | green | blue

structure ColorPoint (α : Type u) extends Point α where
  c : Color
```

Multiple inheritance is also supported:

```lean
structure Point (α : Type u) where
  x : α
  y : α
  z : α

structure RGBValue where
  red : Nat
  green : Nat
  blue : Nat

structure RedGreenPoint (α : Type u) extends Point α, RGBValue where
  no_blue : blue = 0

def p : Point Nat := { x := 10, y := 10, z := 20 }

def rgp : RedGreenPoint Nat :=
  { p with red := 200, green := 40, blue := 0, no_blue := rfl }

example : rgp.x   = 10 := rfl
example : rgp.red = 200 := rfl
```

Inheritance allows combining fields from multiple structures and adding constraints or additional fields.