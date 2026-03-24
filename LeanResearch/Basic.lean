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
