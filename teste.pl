maiorQue(X, [], 0).
maiorQue(X, [A | B], Y) :- A =< X, maiorQue(X, B, Y1), Y is Y1.
maiorQue(X, [A | B], Y) :- A > X, maiorQue(X, B, Y1), Y is Y1 + 1.

eZero([]).
eZero([A | B]) :- A =:= 0, eZero(B).

show(X) :- format('~5f', [pi / 2]).