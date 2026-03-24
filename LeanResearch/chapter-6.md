# Chapter 6: Interacting with Lean

## 6.1 Messages
Lean produces three kinds of messages:

- **Errors**: Indicate inconsistencies in the code, such as syntax errors or type mismatches.
- **Warnings**: Highlight potential issues, like the presence of `sorry`, but do not prevent code execution.
- **Information**: Provide feedback from commands like `#check` and `#eval` without indicating problems.

The `#guard_msgs` command ensures that specific messages are produced. For example:

```lean
#guard_msgs in
def x : Nat := "Not a number"
```

Including a message category (e.g., `error`) after `#guard_msgs` filters messages by type.

## 6.2 Importing Files
Lean automatically imports the `Init` library. Additional files can be imported manually using the `import` statement:

```lean
import Bar.Baz.Blah
```

Imports are transitive, so importing a file also imports its dependencies.

## 6.3 More on Sections
Sections group related elements and declare variables that are automatically inserted where needed. For example:

```lean
section
variable (x y : Nat)

def double := x + x

theorem t1 : double (x + y) = double x + double y := by simp [double]
end
```

Variables are included only in declarations where they are used.

## 6.4 More on Namespaces
Namespaces organize identifiers hierarchically. The `namespace` command prefixes definitions, while `open` creates temporary aliases:

```lean
namespace Foo
def bar : Nat := 1
end Foo

open Foo
#check bar -- Foo.bar
```

The `protected` keyword prevents alias creation, and `open` supports selective imports, exclusions, and renaming.

## 6.5 Attributes
Attributes modify the behavior of definitions. For example, `[simp]` marks theorems for use by the simplifier:

```lean
@[simp] theorem List.isPrefix_self (as : List α) : isPrefix as as := ⟨[], by simp⟩
```

Attributes can be global or local, and the `instance` command assigns attributes like `LE` to definitions.

## 6.6 More on Implicit Arguments
Curly braces `{}` denote implicit arguments, while double braces `{{}}` delay insertion until explicit arguments follow. For example:

```lean
def reflexive {α : Type u} (r : α → α → Prop) : Prop := ∀ (a : α), r a a
```

Square brackets `[]` are used for type classes.

## 6.7 Notation
Lean allows custom notations with precedence levels:

```lean
infixl:65 " + " => HAdd.hAdd
```

Mixfix notations and placeholders enable flexible syntax:

```lean
notation:max "(" e ")" => e
notation:10 Γ " ⊢ " e " : " τ => Typing Γ e τ
```

## 6.8 Coercions
Lean automatically inserts coercions, such as converting `Nat` to `Int`:

```lean
variable (m n : Nat)
#check i + m -- i + ↑m : Int
```

## 6.9 Displaying Information
Commands like `#check`, `#eval`, and `#print` query Lean's state. For example:

```lean
#check Eq.symm
#print Eq.symm
```

## 6.10 Setting Options
The `set_option` command customizes Lean's behavior. For example:

```lean
set_option pp.explicit true
set_option pp.universes true
```

## 6.11 Using the Library
Lean's standard library is organized hierarchically. Definitions and theorems follow naming conventions, such as `Nat.zero_add` and `Nat.mul_one`.

## 6.12 Auto Bound Implicit Arguments
Unbound identifiers in function headers are automatically added as implicit arguments:

```lean
def compose (g : β → γ) (f : α → β) (x : α) : γ := g (f x)
```

Disable this feature with `set_option autoImplicit false`.

## 6.13 Implicit Lambdas
Lean introduces implicit lambdas for functions awaiting implicit arguments. Disable this feature with `@` or explicit lambdas.

## 6.14 Sugar for Simple Functions
Lean supports concise function definitions using placeholders:

```lean
#check (· + 1)
#eval [1, 2, 3].foldl (· * ·) 1
```

## 6.15 Named Arguments
Named arguments improve readability and allow reordering:

```lean
def sum (xs : List Nat) := xs.foldl (init := 0) (·+·)
#eval sum [1, 2, 3, 4]
```

Ellipses (`..`) provide missing explicit arguments:

```lean
def getBinderName : Term → Option String
  | Term.lambda (name := n) .. => some n
  | _ => none
```