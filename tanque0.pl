% Tanque 0
:- module(tanque0, [obter_controles/2]).

%% Explicação:
% Sensores:
% X: posição horizontal do tanque
% Y: posiçao vertical do tanque
% ANGLE: angulo de inclinacao do robo: 0 para virado para frente até PI*2 (~6.28)
% Sensores: esquerda (S1,S2), centro (S3), direita (S4,S5), ré (S6)
%   S1,S2,S3,S4,S5,S6: valores de 0 à 1, onde 0 indica sem obstáculo e 1 indica tocando o tanque
% SCORE: inteiro com a "vida" do tanque. Em zero, ele perdeu
% Controles:
% [FORWARD, REVERSE, LEFT, RIGHT, BOOM]
% FORWARD: 1 para ir pra frente e 0 para não ir
% REVERSE: 1 para ir pra tras e 0 para não ir
% LEFT: 1 para ir pra esquerda e 0 para não ir
% RIGHT: 1 para ir pra direita e 0 para não ir
% BOOM: 1 para tentar disparar (BOOM), pois ele só pode disparar uma bala a cada segundo
% obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
%     FORWARD is 1,
%     REVERSE is 0,
%     LEFT is 1,
%     RIGHT is 0,
%     BOOM is 1.

%%% Faça seu codigo a partir daqui, sendo necessario sempre ter o predicado:
%%%% obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :- ...

troca(0, 1).
troca(1, 0).

% maiorQue - retorna a quantidade de números em uma lista que são maiores que o número especificado.
% X -> número a comparar.
% L -> lista.
% Y -> quantidade de elementos na lista que são maiores que X.
maiorQue(X, [], 0).
maiorQue(X, [A | B], Y) :- A =< X, maiorQue(X, B, Y1), Y is Y1.
maiorQue(X, [A | B], Y) :- A > X, maiorQue(X, B, Y1), Y is Y1 + 1.
% -------------------------------------------------------

% eZero - verifica se todos os números na lista são zero.
eZero([]).
eZero([A | B]) :- A =:= 0, eZero(B).
% -------------------------------------------------------
pertoDaBorda1(Y) :- Y < 100.
pertoDaBorda2(X) :- X > 700.
pertoDaBorda3(Y) :- Y > 500.
pertoDaBorda4(X) :- X < 100.

% Se a traseira estive muito próxima a um obstáculo e se estiver perto de uma das bordas,
% ande para frente atirando.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    S6 >= 0.7,
    (pertoDaBorda1(Y); pertoDaBorda2(X); pertoDaBorda3(Y); pertoDaBorda4(X)),
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 0,
    BOOM is 1.

% Se o tanque estiver preso entre dois obstáculos.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    S6 >= 0.5,
    maiorQue(0.5, [S1, S2, S3, S4, S5], Q),
    Q > 2,
    FORWARD is 0,
    REVERSE is 0,
    LEFT is 1,
    RIGHT is 0,
    BOOM is 1.

% Se pelo menos um dos dois sendores da esquerda for maior que 0.5 (está muito perto) e o restante for zero,
% vire para a esquerda atirando.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    maiorQue(0.5, [S1, S2], Y),
    eZero([S3, S4, S5]),
    Y > 0,
    FORWARD is 0,
    REVERSE is 0,
    LEFT is 1,
    RIGHT is 0,
    BOOM is 1.

% Se pelo menos um dos dois sendores da esquerda for maior que 0 e o restante for zero,
% vire para a esquerda.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    maiorQue(0, [S1, S2], Y),
    eZero([S3, S4, S5]),
    Y > 0,
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 1,
    RIGHT is 0,
    BOOM is 0.

% Se pelo menos um dos dois sendores da direita for maior que 0.5 (está muito perto) e o restante for zero,
% vire para a direita atirando.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    maiorQue(0.5, [S4, S5], Y),
    eZero([S1, S2, S3]),
    Y > 0,
    FORWARD is 0,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 1,
    BOOM is 1.

% Se pelo menos um dos dois sendores da direita for maior que 0 e o restante for zero,
% vire para a direita.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    maiorQue(0, [S4, S5], Y),
    eZero([S1, S2, S3]),
    Y > 0,
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 1,
    BOOM is 0.

% Se há algo muito próximo a traseira e os sensores dianteiros são 0, vá para frente.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    S6 >= 0.5,
    eZero([S1, S2, S3, S4, S5]),
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 0,
    BOOM is 0.

% Se todos os sensores dianteiros estão muito altos, vá para trás enquanto atira.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    maiorQue(0.5, [S1, S2, S3, S4, S5], A),
    A =:= 5,
    FORWARD is 0,
    REVERSE is 1,
    LEFT is 0,
    RIGHT is 0,
    BOOM is 1.

% Se nenhum sensor está ativo, vá para frente.
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    eZero([S1, S2, S3, S4, S5, S6]),
    FORWARD is 1,
    REVERSE is 0,
    LEFT is 0,
    RIGHT is 0,
    BOOM is 0.

obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,SCORE], [FORWARD, REVERSE, LEFT, RIGHT, BOOM]) :-
    random_between(0,1,AA),
    troca(AA, BB),
    random_between(0,1,CC),
    FORWARD is AA,
    REVERSE is BB,
    LEFT is AA,
    RIGHT is BB,
    BOOM is CC.

% Para evitar erros, o tanque para:
obter_controles(_, [0,0,0,0,0]).
