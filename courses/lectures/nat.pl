plus(0, Y, Y).

plus(succ(X), Y, succ(Z)) :- plus(X, Y, Z).

mult(0, Y, 0).

mult(succ(X), Y, Z) :- mult(X, Y, N), plus(N, Y, Z).