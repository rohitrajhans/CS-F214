:- consult(db).

%% YET TO BE DONE: 1.Implement any
%% 2. Convert input to string
%% 3. documentation
%% 4. fill up db, and arrange and name code properly (efficient code, consistent naming and spacing)
%% 5. ipv4 yet to be done

packet(X,Y,Z,W,U) :-
    is_packet_accepted(X,Y,Z,W,U),
    write('Packet accepted').

packet(X,Y,Z,W,U) :-
    is_packet_dropped(X,Y,Z,W,U).

packet(X,Y,Z,W,U) :-
    is_packet_rejected(X,Y,Z,W,U),
    write('Packet rejected').

is_packet_accepted(X,Y,Z,W,U) :-
    allow(L,M,N,O,P),
    validate_adapter(X,L),
    validate_ethernet(Y,M),
    validate_ip(Z,N),
    validate_tcp_udp(W,O),
    validate_icmp(U,P).

is_packet_dropped(X,Y,Z,W,U) :-
    drop(L,M,N,O,P),
    validate_adapter(X,L),
    validate_ethernet(Y,M),
    validate_ip(Z,N),
    validate_tcp_udp(W,O),
    validate_icmp(U,P).

is_packet_rejected(X,Y,Z,W,U) :-
    reject(L,M,N,O,P),
    validate_adapter(X,L),
    validate_ethernet(Y,M),
    validate_ip(Z,N),
    validate_tcp_udp(W,O),
    validate_icmp(U,P).

validate_adapter(X,L) :-
    X='',
    validate_adapter('Z',L).
validate_adapter(X,L) :-
    \+X='',
    sub_string(L,_,_,_,'-'),
    split_string(L,"-","",T),
    memberOfRange(X,T).
validate_adapter(X,L) :-
    \+X='',
    sub_string(L,_,_,_,','),
    split_string(L,",","",T),
    memberOfList(X,T).
validate_adapter(X,L) :-
    \+X='',
    \+sub_string(L,_,_,_,'-'),
    \+sub_string(L,_,_,_,','),
    char_code(X,XC),
    char_code(L,PC),
    XC=PC.

/* Similarly for ethernet clause */
validate_ethernet([V|[P|_]],M) :-
    validate_vid(V,M),
    validate_proto(P,M).

validate_vid(Y,[E|_]) :-
    verify_number_range(Y,E).
validate_vid(Y,[E|_]) :-
    verify_number_list(Y,E).
validate_vid(Y,[E|_]) :-
    verify_number(Y,E).

validate_proto(Y,[_|[E|_]]) :-
    verify_number_range(Y,E).
validate_proto(Y,[_|[E|_]]) :-
    verify_number_list(Y,E).
validate_proto(Y,[_|[E|_]]) :-
    verify_number(Y,E).

validate_icmp([T|[C|_]],P) :-
    validate_type(T,P),
    validate_code(C,P).

validate_type(T,[I|_]) :-
    verify_number_range(T,I).
validate_type(T,[I|_]) :-
    verify_number_list(T,I).
validate_type(T,[I|_]) :-
    verify_number(T,I).

validate_code(C,[_|[I|_]]) :-
    verify_number_range(C,I).
validate_code(C,[_|[I|_]]) :-
    verify_number_list(C,I).
validate_code(C,[_|[I|_]]) :-
    verify_number(C,I).

validate_ip(Z,N) :-
    \+sub_string(N, _, _, _, ','),
    \+sub_string(N, _, _, _, '-'),
    Z=N.
validate_ip(Z,N) :-
    sub_string(N, _, _, _, ','),
    split_string(N, ",", "", T),
    memberIPList(Z,T).
validate_ip(Z,N) :-
    sub_string(N, _, _, _, '-'),
    split_string(N, "-", "", T),
    memberIPRange(Z, T).

validate_tcp_udp([W|[S|[D|_]]], [H|[VS|[VD|_]]]) :-
    W=H,
    verify_ports(S,VS),
    verify_ports(D,VD).

verify_ports(A, B) :-
    A=<65535,
    verify_number_range(A,B).
verify_ports(A, B) :-
    A=<65535,
    verify_number_list(A,B).
verify_ports(A,B) :-
    A=<65535,
    verify_number(A,B).

verify_number_range(A, B) :-
    sub_string(B, _, _, _, '-'),
    split_string(B, "-", "", T),
    memberOfNumberRange(A,T).

verify_number_list(A,B) :-
    sub_string(B, _, _, _, ','),
    split_string(B, ",", "", T),
    memberOfNumberList(A,T).

verify_number(A,B) :-
    \+sub_string(B, _, _, _, '-'),
    \+sub_string(B, _, _, _, ','),
    atom_number(B, BN),
    A=BN.

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
