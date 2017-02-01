% Natural numbers in prolog!

even(zero).
even(succ(N)) :- odd(N).
odd(succ(N)) :- even(N).
