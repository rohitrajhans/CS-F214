packet() :-
    false.

packet(X) :-
    adapter(X).

adapter(X) :-
    char_code(X,Y),
    Y < 73.

adapter(X) :-
    char_code(X,Y),
    Y > 72,
    format('Packet with adapter "any" is rejected', [X]).