consult(database).


packet(X, Y) :-
    allow(X, Y),
    write('Packet allowed').

packet(X, Y) :-
    reject(X, Y),
    write('Packet rejected').

packet(X, Y) :-
    drop(X, Y).

allow(X, Y) :-
    adapter(X),
    ethernet(Y).

drop(X, Y) :-
    \+adapter(X),
    \+reject_adapter(X).

reject(X, Y) :-
    \+adapter(X),
    reject_adapter(X).
