% Natural numbers in prolog!
% Thomas Panetti helped
even(zero).
even(succ(N)) :- odd(N).
odd(succ(N)) :- even(N).
