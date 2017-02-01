The prolog program below:

  % Normally we wouldn't define numbers in terms of their even/oddness,
  % but use that information to define a relation:

  even(zero,true).
  even(succ(N),B) :- odd(N, B).
  odd(zero, false).
  odd(succ(N),B) :- even(N, B).

can be directly translated to type-level Haskell (with some extensions)

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> import Prelude hiding (even, odd)

Now we need some boolean types

> data True
> data False

And our old natural numbers

> data Zero
> data Succ n
> type Three = Succ (Succ (Succ Zero))

Again we include the operations even though the types are what matter

> class Even n b where
>   even :: n -> b -- Only because we must!

> class Odd n b where
>   odd :: n -> b -- C'est la vie.

> instance             Even Zero     True
> instance Odd n b =>  Even (Succ n) b
> instance             Odd  Zero     False
> instance Even n b => Odd  (Succ n) b

We can check this in ghci by issuing commands like the following:

:type odd (undefined :: Three) :: True
:type odd (undefined :: Three) :: False
:type even (undefined :: Three) :: False


This is just to get the interactive panel working:

> instance Show Zero where
>   show _ = "Success!"
> instance Show (Succ n) where
>   show _ = "Success"
