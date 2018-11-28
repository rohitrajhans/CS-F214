not_empty(L) :-
    length(L, K),
    K>0.

isAdapterValid(X) :-
    char_code(X, Code),
    Code =< 72,
    Code >= 65.

allow() :-
    write('Packet is rejected'),
    false.

allow(L) :-
    adapter_validation(L),
    format('Packet with adapter ~w is allowed', [L]).

adapter_validation([]) :-
    true.

adapter_validation([H|T]) :-
    not_empty([H|T]),
    isAdapterValid(H),
    adapter_validation(T).
    

/* checkIfCharValid(X) :-
    char_code(X, Code),
    Code >= 65,
    Code =< 91.
*/
