packet(X, Y) :-
    is_packet_accepted(X, Y),
    write('Packet accepted').

is_packet_accepted(X,Y) :-
    allow(L, M),
    validate_adapter(X,L),
    validate_ethernet(Y,M).

validate_adapter('', L) :-
    validate_adapter('Z', L).

validate_adapter(X, L) :-
    split_string(L, "-", "", T),
    length(T, I),
    I=2,
    memberOfRange(X,T).
    
validate_adapter(X, L) :-
    split_string(L, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfList(X, T).

validate_adapter(X, L) :-
    string_length(L, I),
    I=1,
    char_code(X, XC),
    char_code(L, PC),
    XC=PC.

validate_ethernet([V|[P|_]], L) :-
    validate_vid(V, L),
    validate_proto(P, L).

validate_vid(X, [E|_]) :-
    split_string(E, "-", "", T),
    length(T, I),
    I=2,
    memberOfNumberRange(X,T).

validate_vid(X, [E|_]) :-
    split_string(E, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfNumberList(X, T).

validate_vid(X, [E|_]) :-
    string_to_list(E, S),
    checkValidNumber(S),
    atom_number(E, EN),
    X=EN.

validate_proto(X, [_|[E|_]]) :-
    split_string(E, "-", "", T),
    length(T, I),
    I=2,
    memberOfNumberRange(X,T).

validate_proto(X, [_|[E|_]]) :-
    split_string(E, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfNumberList(X, T).

validate_proto(X, [_|[E|_]]) :-
    string_to_list(E, S),
    checkValidNumber(S),
    atom_number(E, EN),
    X=EN.

memberOfList(_, []) :-
    false.

memberOfList(X, [H|T]) :-
    char_code(H, HC),
    char_code(X, XC),
    HC = XC;
    memberOfList(X, T).

memberOfRange(X, [S|[E|_]]) :-
    char_code(S, SC),
    char_code(E, EC),
    char_code(X, XC),
    XC >= SC,
    XC =< EC.

memberOfNumberRange(X, [S|[E|_]]) :-
    atom_number(S, SN),
    atom_number(E, EN),
    X >= SN,
    X =< EN.

memberOfNumberList(_, []) :-
    false.

memberOfNumberList(X, [H|T]) :-
    atom_number(H, HE),
    X = HE;
    memberOfNumberList(X, T).

checkValidNumber([]) :-
    true.

checkValidNumber([H|T]) :-
    between(48,57, H),
    checkValidNumber(T);
    false.