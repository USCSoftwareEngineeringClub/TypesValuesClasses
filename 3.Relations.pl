% Normally we wouldn't define numbers in terms of their even/oddness,
% but use that information to define a relation:

even(zero,true).
even(succ(N),B) :- odd(N, B).
odd(zero, false).
odd(succ(N),B) :- even(N, B).
