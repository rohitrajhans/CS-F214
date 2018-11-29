packet(X, Y) :-
    validate_adapter(X),
    validate_ethernet(Y).

validate_adapter(X) :-
    allow(L, _),
    split_string(L, "-", "", T),
    length(T, I),
    I=2,
    memberOfRange(X,T).
    
validate_adapter(X) :-
    allow(L, _),
    split_string(L, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfList(X, T).

validate_adapter(X) :-
    allow(P, _),
    string_length(P, I),
    I=1,
    char_code(X, XC),
    char_code(P, PC),
    XC=PC.

validate_ethernet([V|[P|_]]) :-
    validate_vid(V),
    validate_proto(P).

validate_vid(X) :-
    allow(_, [E|_]),
    split_string(E, "-", "", T),
    length(T, I),
    I=2,
    memberOfNumberRange(X,T).

validate_vid(X) :-
    allow(_, [E|_]),
    split_string(E, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfNumberList(X, T).

validate_vid(X) :-
    allow(_, [E|_]),
    string_to_list(E, S),
    checkValidNumber(S),
    atom_number(E, EN),
    X=EN.

validate_proto(X) :-
    allow(_, [_|[E|_]]),
    split_string(E, "-", "", T),
    length(T, I),
    I=2,
    memberOfNumberRange(X,T).

validate_proto(X) :-
    allow(_, [_|[E|_]]),
    split_string(E, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfNumberList(X, T).

validate_proto(X) :-
    allow(_, [_|[E|_]]),
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