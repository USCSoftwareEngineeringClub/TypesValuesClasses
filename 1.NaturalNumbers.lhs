> import Prelude hiding (even, odd)

Define the natural number datatype:

> data Nat
>     = Zero | Succ Nat
>     deriving (Show, Eq)

An example of a natural number that isn't zero. Notice the type
declaration comes first.

> three :: Nat
> three
>   = Succ (Succ (Succ Zero))

We can also define some functions that test whether a number is even
or odd. We do this with two mutually recursive functions:

> even Zero     = True
> even (Succ n) = odd n

> odd Zero     = False
> odd (Succ n) = even n
