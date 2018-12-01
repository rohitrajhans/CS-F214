% Prolog Assignment 2018-19
 
% Problem 1: 
%   i) Firewall rules are encoded in Prolog as facts and rules: each rule may start with accept (allow the incoming packet), 
%        reject (send reject information to sender), or drop (silently) followed by a clause.
%   ii) Write a Prolog program to apply encoded rules on any incoming packet. Note that multiple rules may apply.

% Authors:
% 2016A7PS0105P - Rohit Rajhans
% 2016A7PS0127P - Siddhant Khandelwal
% Sample Input - packet('adapter A, ether vid 2 proto 30, ip src 192.168.1.0 dest 192.168.1.0, tcp src 12 dest 23, icmp type 20 code 30').

% [Prolog Program]
% Importing Databse stored as 'db.pl' in cwd
:- consult(db).

% [[Packet Input Parsing]]
%
% packet/1
% Base Predicate 
% Accepts packet and associated data
% Splits the arguements and passes on to check_packet/2
packet(I) :-
    split_string(I, ",", "", [A|[B|[C|[D|[E|_]]]]]),
    split_string(A, " ", "\s\t\n", [_|[P]]),
    split_string(B, " ", "\s\t\n", [_|[_|[Q|[_|[R|_]]]]]),
    split_string(C, " ", "\s\t\n", [_|[_|[S|[_|[T|_]]]]]),
    split_string(D, " ", "\s\t\n", [U|[_|[V|[_|[W|_]]]]]),
    split_string(E, " ", "\s\t\n", [_|[_|[X|[_|[Y|_]]]]]),
    atom_number(Q,QN),
    atom_number(R,RN),
    atom_number(V,VN),
    atom_number(W,WN),
    atom_number(X,XN),
    atom_number(Y,YN),
    atom_string(UA, U),
    check_packet(P, [QN|[RN]], [S|[T]], [UA|[VN|[WN]]] ,[XN|[YN]]).

% check_packet/5
% Recieves packet attributes from packet/1.
% Passes on to is_packet_accepted/5, is_packet_dropped/5, is_packet_rejected/5
% Prints the result for the packet after validation
check_packet(X,Y,Z,W,U) :-
    is_packet_accepted(X,Y,Z,W,U),
    write('Packet accepted').

check_packet(X,Y,Z,W,U) :-
    is_packet_dropped(X,Y,Z,W,U),
    write('Packet dropped').

check_packet(X,Y,Z,W,U) :-
    is_packet_rejected(X,Y,Z,W,U),
    write('Packet rejected').

check_packet(X,Y,Z,W,U) :-
    \+is_packet_accepted(X,Y,Z,W,U),
    \+is_packet_rejected(X,Y,Z,W,U),
    \+is_packet_dropped(X,Y,Z,W,U),
    write('Packet does not match any clause, rejected by default'),
    false.

% [[End of Packet Input Parsing]]

% [[Packet Verification]]
%
% is_packet_accepted/5
% Recieves packet attributes from check_packet/5
% Recieves allow/5 rules from the database
% Passes on the corresponding attributes from both the rule and the packet to respective predicates for evaluation
is_packet_accepted(X,Y,Z,W,U) :-
    allow(L,M,N,O,P),
    verify_adapter(X,L),
    verify_ethernet(Y,M),
    verify_ip(Z,N),
    verify_tcp_udp(W,O),
    verify_icmp(U,P).

% is_packet_accepted/5
% Recieves packet attributes from check_packet/5
% Recieves drop/5 rules from the database
% Passes on the corresponding attributes from both the rule and the packet to respective predicates for evaluation
is_packet_dropped(X,Y,Z,W,U) :-
    drop(L,M,N,O,P),
    verify_adapter(X,L),
    verify_ethernet(Y,M),
    verify_ip(Z,N),
    verify_tcp_udp(W,O),
    verify_icmp(U,P).

% is_packet_accepted/5
% Recieves packet attributes from check_packet/5
% Recieves reject/5 rules from the database
% Passes on the corresponding attributes from both the rule and the packet to respective predicates for evaluation
is_packet_rejected(X,Y,Z,W,U) :-
    reject(L,M,N,O,P),
    verify_adapter(X,L),
    verify_ethernet(Y,M),
    verify_ip(Z,N),
    verify_tcp_udp(W,O),
    verify_icmp(U,P).

% [[End of Packet Verification]]

% [[Packet Attributes Verification]]

% [[[Packet Adapter Verification]]]
% verify_adapter/2
% Handles the 'any' Adapter case.
verify_adapter(_,L) :-
    L="any".

% verify_adapter/2
% Handles the range case in firewall rule for IP Address, e.g. 192.168.1.1-192.168.2.1
verify_adapter(X,L) :-
    \+L="any",
    sub_string(L,_,_,_,'-'),
    split_string(L,"-","",T),
    memberOfRange(X,T).

% verify_adapter/2
% Handles the comma-seprerated list case in firewall rule for IP Address, e.g. [192.168.1.1, 192.168.2.1, 192.168.2.3]
verify_adapter(X,L) :-
    \+L="any",
    sub_string(L,_,_,_,','),
    split_string(L,",","",T),
    memberOfList(X,T).

% verify_adapter/2
% Handles the single IP Address case firewall rule, e.g. 192.168.1.1
verify_adapter(X,L) :-
    \+L="any",
    \+sub_string(L,_,_,_,'-'),
    \+sub_string(L,_,_,_,','),
    char_code(X,XC),
    char_code(L,PC),
    XC=PC.

% [[[End of Packet Adapter Verification]]]

% [[[Packet Ethernet Verification]]]
% verify_ethernet/2
% Recieves the proto and vid attribute for ethernet
% Passes the attributes to respective predicates - verify_vid/2, verify_proto/2
verify_ethernet([V|[P|_]],M) :-
    verify_vid(V,M),
    verify_proto(P,M).

% verify_vid/2
% verifies vid for 'any' case
verify_vid(_, [E|_]) :-
    E = "any".

% verifies number range for vid
verify_vid(Y,[E|_]) :-
    verify_number_range(Y,E).

% verify_vid/2
% verifies number range for vid
verify_vid(Y,[E|_]) :-
    verify_number_list(Y,E).

% verify_vid/2
% verifies number for vid
verify_vid(Y,[E|_]) :-
    verify_number(Y,E).

% verify_proto/2
% verifies 'any' case for proto
verify_proto(_,[_|[E|_]]) :-
    E = "any".

% verifies number range for proto
verify_proto(Y,[_|[E|_]]) :-
    verify_number_range(Y,E).

% verify_proto/2
% verifies number list for proto
verify_proto(Y,[_|[E|_]]) :-
    verify_number_list(Y,E).

% verify_proto/2
% verifies number for proto
verify_proto(Y,[_|[E|_]]) :-
    verify_number(Y,E).

% [[[End of Packet Ethernet Verification]]]

% [[[Packet ICMP Verification]]]
% verify_icmp/2
% Recieves the icmp type and code
% Passes the attributes to respective predicates - verify_type/2, verify_code/2
verify_icmp([T|[C|_]],P) :-
    verify_type(T,P),
    verify_code(C,P).

% verify_type/2
% verifies 'any' case for type
verify_type(_,[I|_]) :-
    I = "any".

% verifies number range for icmp type
verify_type(T,[I|_]) :-
    verify_number_range(T,I).

% verify_type/2
% verifies number list for icmp type
verify_type(T,[I|_]) :-
    verify_number_list(T,I).

% verify_type/2
% verifies number for icmp type
verify_type(T,[I|_]) :-
    verify_number(T,I).

% verify_code/2
% verifies 'any' case for type
verify_code(I,[_|[I|_]]) :-
    I = "any".

% verifies number range for icmp code
verify_code(C,[_|[I|_]]) :-
    verify_number_range(C,I).

% verify_code/2
% verifies number list for icmp code
verify_code(C,[_|[I|_]]) :-
    verify_number_list(C,I).

% verify_code/2
% verifies number for icmp code
verify_code(C,[_|[I|_]]) :-
    verify_number(C,I).
% [[[End of Packet ICMP Verification]]]

% [[[Packet IP Source and Destination Verification]]]
% verify_ip/2
% Recieves the Source and Destination IP Address
% Passes the attributes to predicate - verify_ip_add/2
verify_ip([S|[D|_]], [VS|[VD|_]]) :-
    verify_ip_add(S,VS),
    verify_ip_add(D,VD).

% verify_ip_add/2
% verifies 'any' case for IP Address
verify_ip_add(_,N) :-
    N = "any".

% Checks for type of arguement passed by rule in database
% verifies single ip address
verify_ip_add(Z,N) :-
    \+sub_string(N, _, _, _, ','),
    \+sub_string(N, _, _, _, '-'),
    Z=N.

% verify_ip_add/2
% Checks for type of arguement passed by rule in database
% verifies single ip address with netmask
verify_ip_add(Z,N) :-
    sub_string(N, _, _, _, '/'),
    \+sub_string(N, _, _, _, ','),
    \+sub_string(N, _, _, _, '-'),
    split_string(N, '/', '', [_|T]),
    T >= 1,
    T =< 32,
    Z=N.

% verify_ip_add/2
% Checks for type of arguement passed by rule in database
% verifies from comma separated list of ip addresses
verify_ip_add(Z,N) :-
    sub_string(N, _, _, _, ','),
    split_string(N, ",", "", T),
    memberIPList(Z,T).

% verify_ip_add/2
% Checks for type of arguement passed by rule in database
% verifies from range of ip addresses
verify_ip_add(Z,N) :-
    sub_string(N, _, _, _, '-'),
    split_string(N, "-", "", T),
    memberIPRange(Z, T).
% [[[End of Packet IP Source and Destination Verification]]]

% [[[Packet TCP Source, Destination Verification]]]
% verify_tcp_udp/2
% Checks for tcp attributes
% Verfies ports for Source and Destination tcp - verify_ports/2
verify_tcp_udp([W|[S|[D|_]]], [H|[VS|[VD|_]]]) :-
    W=H,
    verify_ports(S,VS),
    verify_ports(D,VD).

% verify_ports/2
% verfies 'any' case for ports
verify_ports(_, B) :-
    B = "any".

% verifies port in number range
verify_ports(A, B) :-
    A=<65535,
    verify_number_range(A,B).

% verify_ports/2
% verifies port in number list
verify_ports(A, B) :-
    A=<65535,
    verify_number_list(A,B).

% verify_ports/2
% verifies port number 
verify_ports(A,B) :-
    A=<65535,
    verify_number(A,B).
% [[[End of Packet TCP Source, Destination Verification]]]
% [[End of Packet Attributes Verification]]

% [[Helper Functions]]

% verify_number_range/2
% verifies whether A is in range B
verify_number_range(A, B) :-
    sub_string(B, _, _, _, '-'),
    split_string(B, "-", "", T),
    memberOfNumberRange(A,T).

% verify_number_list/2
% verifies whether A is in list B
verify_number_list(A,B) :-
    sub_string(B, _, _, _, ','),
    split_string(B, ",", "", T),
    memberOfNumberList(A,T).

% verify_number_range/2
% verifies equality of A and B
verify_number(A,B) :-
    \+sub_string(B, _, _, _, '-'),
    \+sub_string(B, _, _, _, ','),
    atom_number(B, BN),
    A=BN.

% memberIPList/2
% Verifies IP Address in List from rule using recursion
% base for recursion
memberIPList(_, []) :-
    false.

% step for recursion
memberIPList(X, [H|T]) :-
    split_string(H, ".", "", SH),
    split_string(X, ".", "", SX),
    SH = SX;
    memberIPList(X, T).

% memberIPList/2
% Verifies IP Address in Range from rule
memberIPRange(X, [S, E]) :-
    split_string(X, ".", "", SX),
    split_string(S, ".", "", SS),
    split_string(E, ".", "", SE),
    compare_range(SX, SS, SE).

% compare_range/2
% Verifies equality of IP Address in range using recursion
% base for recursion
compare_range([], [], []) :-
    true.

% step for recusion
compare_range([XH|XT], [SH|ST], [EH|ET]) :-
    atom_number(XH, IXH),
    atom_number(SH, ISH),
    atom_number(EH, IEH),
    between(ISH, IEH, IXH),
    compare_range(XT, ST, ET).

% memberOfList/2
% Verifies in list using recursion
% base for recursion
memberOfList(_, []) :-
    false.

% step for recursion
memberOfList(X, [H|T]) :-
    char_code(H, HC),
    char_code(X, XC),
    HC = XC;
    memberOfList(X, T).

% memberOfRange/2
% converts to character code and checks in range
memberOfRange(X, [S|[E|_]]) :-
    char_code(S, SC),
    char_code(E, EC),
    char_code(X, XC),
    between(SC,EC,XC).

% memberOfNumberRange/2
% converts to character code and checks in range for numbers
memberOfNumberRange(X, [S|[E|_]]) :-
    atom_number(S, SN),
    atom_number(E, EN),
    X >= SN,
    X =< EN.

% memberOfNumberList/2
% Verifies in number list using recursion
% base for recursion
memberOfNumberList(_, []) :-
    false.

% step for recursion
memberOfNumberList(X, [H|T]) :-
    atom_number(H, HE),
    X = HE;
    memberOfNumberList(X, T).
% [[End of Helper Functions]]

% [End of Prolog Program]
