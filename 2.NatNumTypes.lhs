We can do a similar thing on the type level:

Notice that these are types that cannot be instantiated!

> data Zero
> data Succ n

'type' is just a type synonym (like typedef in C)

> type Three = Succ (Succ (Succ Zero))

'class' are like interfaces in Java. Here we think of them as 'types of types'

Ultimately, we want the following (which is valid Haskell):

class Even n
class Odd n

combined with instances:

> instance Even Zero
> instance Odd n  => Even (Succ n)
> instance Even n => Odd (Succ n)

but then we have no way of checking if a type is actually Even or Odd,
so we do

> class Even n where
>   isEven :: n
> class Odd n where
>   isOdd :: n

This is just to get the interactive panel working:

> instance Show Zero where
>   show _ = "Success"
> instance Show (Succ n) where
>   show _ = "Success"
