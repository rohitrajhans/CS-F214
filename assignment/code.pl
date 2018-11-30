packet(X, Y, Z) :-
    is_packet_accepted(X, Y, Z),
    write('Packet accepted').

packet(X,Y,Z) :-
    is_packet_dropped(X,Y,Z).

packet(X,Y,Z) :-
    is_packet_rejected(X,Y,Z),
    write('Packet rejected').

/* is_packet_accepted() is a wrapper predicate to pass the same clauses to adapter and ethernet predicates */
is_packet_accepted(X, Y, Z) :-
    allow(L, M, N),
    validate_adapter(X, L),
    validate_ethernet(Y, M),
    validate_ip(Z, N).

is_packet_dropped(X, Y, Z) :-
    drop(L, M, N),
    validate_adapter(X, L),
    validate_ethernet(Y, M),
    validate_ip(Z, N).

is_packet_rejected(X, Y, Z) :-
    reject(L, M, N),
    validate_adapter(X, L),
    validate_ethernet(Y, M),
    validate_ip(Z, N).

/* Should convert empty adapter to Z but not working */
validate_adapter('', L) :-
    validate_adapter('Z', L).

/* Checks for A-C, range of adapters */
validate_adapter(X, L) :-
    split_string(L, "-", "", T),
    length(T, I),
    I=2,
    memberOfRange(X,T).

/* Checks for A,B,C continuation of adapters */    
validate_adapter(X, L) :-
    split_string(L, ",", "", T),
    length(T, I),
    I >= 2,
    memberOfList(X, T).

/* Checks for a single adapter */
validate_adapter(X, L) :-
    string_length(L, I),
    I=1,
    char_code(X, XC),
    char_code(L, PC),
    XC=PC.

/* Similarly for ethernet clause */
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

validate_ip('', L) :-
    validate_ip('Z', L).

validate_ip(X, L) :-
    \+sub_string(L, _, _, _, ','),
    \+sub_string(L, _, _, _, '-'),
    X=L.

validate_ip(X, L) :-
    sub_string(L, _, _, _, ','),
    \+sub_string(L, _, _, _, '-'),
    split_string(L, ",", "", T),
    length(T, I),
    I>=2,
    memberIPList(X, T).

validate_ip(X, L) :-
    sub_string(L, _, _, _, '-'),
    \+sub_string(L, _, _, _, ','),
    split_string(L, "-", "", T),
    length(T, I),
    I=2,
    memberIPRange(X, T).

memberIPList(_, []) :-
    false.

memberIPList(X, [H|T]) :-
    split_string(H, ".", "", SH),
    split_string(X, ".", "", SX),
    SH = SX;
    memberIPList(X, T).

memberIPRange(X, [S, E]) :-
    split_string(X, ".", "", SX),
    split_string(S, ".", "", SS),
    split_string(E, ".", "", SE),
    compare_range(SX, SS, SE).

compare_range([], [], []) :-
    true.

compare_range([XH|XT], [SH|ST], [EH|ET]) :-
    atom_number(XH, IXH),
    atom_number(SH, ISH),
    atom_number(EH, IEH),
    between(ISH, IEH, IXH),
    compare_range(XT, ST, ET).

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
    between(SC,EC,XC).

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
