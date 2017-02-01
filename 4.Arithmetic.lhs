All the stuff we need from before:

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FunctionalDependencies #-}
> {-# LANGUAGE UndecidableInstances #-}
> import Prelude hiding (even, odd)
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
