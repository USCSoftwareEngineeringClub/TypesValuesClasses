Again, all the stuff we need from before:

> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FunctionalDependencies #-}
> {-# LANGUAGE UndecidableInstances #-}
> data True
> data False
> data Zero
> data Succ n
> type One = Succ Zero
> type Three = Succ (Succ (Succ Zero))
> class Add a b c | a b -> c where
>   add :: a -> b -> c
> instance              Add Zero     b b
> instance Add a b c => Add (Succ a) b (Succ c)
> class Mul a b c | a b -> c where
>   mul :: a -> b -> c
> instance                           Mul Zero b Zero
> instance (Mul a b c, Add b c d) => Mul (Succ a) b d
> u = undefined

Constructors for the type-level list. Notice the type variables on the
left.

> data Nil = Nil deriving Show
> data Cons x xs = Cons deriving Show

For example, we can generate a descending sequence.

> class DownFrom n xs | n -> xs where
>   downfrom :: n -> xs

The list of numbers that are 'down from 0' is the empty list

> instance DownFrom Zero Nil

If there is an instance of a list that is down from n, then we can
construct the list that is down from n + 1:

> instance DownFrom n xs => DownFrom (Succ n) (Cons n xs)

You can test this with the following command in ghci:

:type downfrom (u :: Three)

Notice that if you don't ask for the type, you will get an error since
we have no values.

For insertion sort, we also need comparisons:

> class Lte a b c | a b -> c where
>   lte :: a -> b -> c

Zero is less than or equal to any natural number

> instance Lte Zero b True

Any successor is larger than zero.

> instance Lte (Succ n) Zero False

if a <= b, then a + 1 <= b + 1

> instance Lte a b c => Lte (Succ a) (Succ b) c

Test it like so:

:type lte (u :: Zero) (u :: One)
:type lte (u :: One) (u :: Zero)

Finally, the list functions we need for insertion sort:

> class Insert x xs ys | x xs -> ys where
>   insert :: x -> xs -> ys

Anything inserted into the empty list is a singleton list:

> instance Insert x Nil (Cons x Nil)
> instance (Lte x1 x2 b, InsertCons b x1 x2 xs ys) => Insert x1 (Cons x2 xs) ys

Insert deals with inserting single elements, InsertCons deals with
combining lists

> class InsertCons b x1 x2 xs ys | b x1 x2 xs -> ys
> instance InsertCons True x1 x2 xs (Cons x1 (Cons x2 xs))
> instance Insert x1 xs ys => InsertCons False x1 x2 xs (Cons x2 ys)

> class Sort xs ys | xs -> ys where
>   sort :: xs -> ys
> instance Sort Nil Nil
> instance (Sort xs ys, Insert x ys zs) => Sort (Cons x xs) zs
