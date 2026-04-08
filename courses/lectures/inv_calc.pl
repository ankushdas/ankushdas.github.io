exists(A, [A | Gamma]).

exists(A, [B | Gamma]) :- exists(A, Gamma).

inv_prove(Gamma, A) :- invR([], Gamma, A).

invR(Gamma, Omega, and(A, B)) :-
    invR(Gamma, Omega, A),
    invR(Gamma, Omega, B).

invR(Gamma, Omega, or(A, B)) :-
    invL(Gamma, Omega, or(A, B)).

invR(Gamma, Omega, impl(A, B)) :-
    invR(Gamma, [A | Omega], B).

invR(Gamma, Omega, atom(P)) :- invL(Gamma, Omega, atom(P)).

invL(Gamma, [and(A, B) | Omega], C) :-
    invL(Gamma, [A, B | Omega], C).

invL(Gamma, [or(A, B) | Omega], C) :-
    invL(Gamma, [A | Omega], C),
    invL(Gamma, [B | Omega], C).

invL(Gamma, [impl(A, B) | Omega], C) :-
    invL([impl(A, B) | Gamma], Omega, C).

invL(Gamma, [atom(P) | Omega], C) :-
    invL([atom(P) | Gamma], Omega, C).

invL(Gamma, [], C) :-
    choice(Gamma, C).

choice(Gamma, C) :- choiceR(Gamma, C).

choice(Gamma, C) :- choiceL(Gamma, C).

choiceR(Gamma, or(A, B)) :- invR(Gamma, [], A).

choiceR(Gamma, or(A, B)) :- invR(Gamma, [], B).

choiceR(Gamma, atom(P)) :- exists(atom(P), Gamma).

choiceL(Gamma, C) :-
    exists(impl(A, B), Gamma),
    invR(Gamma, [], A),
    invL(Gamma, [B], C).