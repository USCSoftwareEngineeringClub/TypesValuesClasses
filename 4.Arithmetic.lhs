All the stuff we need from before:

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FunctionalDependencies #-}
> {-# LANGUAGE UndecidableInstances #-}
> import Prelude hiding (even, odd, pred)
> data True
> data False
> data Zero
> data Succ n
> type Three = Succ (Succ (Succ Zero))

But here we redefine the classes with functional dependencies,
preventing us from defining both (Even Zero True) and (Even Zero
False), for example.

> class Even n b | n -> b where
>   even :: n -> b
> class Odd n b | n -> b where
>   odd :: n -> b

The '|' says that the class is constrained by n -> b, in other words
b is uniquely determined by n. You can read '|' here as 'such that'.

Note: This is also why we need 'UndecidableInstances' above, as it is
now not guaranteed that any type-level computation will terminate.

> instance             Even Zero     True
> instance Odd n b =>  Even (Succ n) b
> instance             Odd  Zero     False
> instance Even n b => Odd  (Succ n) b

try this out in ghci with the following:

:type even (undefined :: Three)
:type odd (undefined :: Three)

Notice we don't need to specify the whole type due to the functional
dependency.

Arithmetic
==========

If we define arithmetic on values we end up with functions that look
like this:

add Zero b = b
add (Succ a) b = Succ (add a b)

mul Zero b = b
mul (Succ a) b = add b (mul a b)

These can be 'lifted' to the type level as follows:

Addition
--------

The class instance says a and b uniquely determine c

> class Add a b c | a b -> c where
>   add :: a -> b -> c

The instances say anything plus zero is itself

> instance              Add Zero     b b

and if I can add a and b to get c, then adding (a + 1) + b = c + 1

> instance Add a b c => Add (Succ a) b (Succ c)

Multiplication
--------------

Again, a and b uniquely determine c

> class Mul a b c | a b -> c where
>   mul :: a -> b -> c

Anything times zero is zero

> instance                           Mul Zero b Zero

If a * b = c, and b + c = d, then (a + 1) * b = d

> instance (Mul a b c, Add b c d) => Mul (Succ a) b d

Let's also define an alias for undefined to make typing easier:

> u = undefined

Try the following in ghci:

:t add (u::Three) (u::Three)

:t mul (u::Three) (u::Three)

Power
-----
Static computations are those performed by the compiler. Dynamic
computations are run-time computations.

We can illustrate combining these with the power function. The typical
value-level power function is as follows (with Zero and Succ as
values, not types):

data Nat
  = Zero | Succ Nat
  deriving (Show, Eq)

pow b Zero = one
pow b (Succ n) = mul b (pow b n)

The static version looks like this:

> type One = Succ Zero

> class Pow a b c | a b -> c where
>   pow :: a -> b -> c


Anything to the zero power is one, and if a ** b = c and a * c = d,
then a * c = a * a ** b = a ** (b + 1)

> instance                           Pow a Zero One
> instance (Pow a b c, Mul a c d) => Pow a (Succ b) d

If we use Int for the base, we can ensure the base is calculated at
runtime while the exponent is determined at compile-time:

> class Pred a b | a -> b -- Predecessor relation
>   where pred :: a -> b
> instance Pred (Succ n) n

> class Power n
>   where power :: Int -> n -> Int
> instance Power Zero
>   where power _ _ = 1 -- Anything to the zero is one
> instance Power n => Power (Succ n)
>   where power x n = x * power x (pred n)

An example:

power 2 (mul (u :: Three) (u :: Three))
