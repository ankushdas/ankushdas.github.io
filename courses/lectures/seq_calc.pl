exists(A, [A | Gamma]).

exists(A, [B | Gamma]) :- exists(A, Gamma).

% andR rule
prove(Gamma, and(A, B)) :- prove(Gamma, A), prove(Gamma, B).

% andL1 rule
prove(Gamma, C) :-
    exists(and(A, B), Gamma),
    prove([A | Gamma], C).

% andL2 rule
prove(Gamma, C) :-
    exists(and(A, B), Gamma),
    prove([B | Gamma], C).

% orL rule
prove(Gamma, C) :-
    exists(or(A, B), Gamma),
    prove([A | Gamma], C),
    prove([B | Gamma], C).

% orR1 rule
prove(Gamma, or(A, B)) :-
    prove(Gamma, A).

% orR2 rule
prove(Gamma, or(A, B)) :-
    prove(Gamma, B).


% id rule
prove(Gamma, atom(P)) :- exists(atom(P), Gamma).
