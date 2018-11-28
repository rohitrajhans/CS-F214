not_empty(L) :-
    length(L, K),
    K>0.

allow() :-
    false.

allow(L, M) :-
    adapter_validation(L),
    ethernet_validation(M),
    format('Packet is allowed').

/* Adapter Clauses */

isAdapterValid(X) :-
    char_code(X, Code),
    Code =< 72,
    Code >= 65.

adapter_validation(L) :-
    not_empty(L),
    adapter_validation_rec(L).

adapter_validation_rec([]) :-
    true.

adapter_validation_rec([H|T]) :-
    isAdapterValid(H),
    adapter_validation_rec(T).
    

/* checkIfCharValid(X) :-
    char_code(X, Code),
    Code >= 65,
    Code =< 91.
*/

/* Ethernet Clauses */

/* ethernet clause input [ [vlan-numbers], [proto-ids in hex form]] */

ethernet_validation([V|[P|_]]) :-
    vlan_validation(V),
    proto_validation(P).

vlan_validation(L) :-
    not_empty(L),
    vlan_validation_rec(L).

vlan_validation_rec([]) :-
    true.

vlan_validation_rec([H|T]) :-
    not_empty([H|T]),
    isVlanNumberValid(H),
    vlan_validation_rec(T).

isVlanNumberValid(H) :-
     H >= 1,
     H =< 999.

proto_validation(L) :-
    not_empty(L),
    proto_validation_rec(L).

proto_validation_rec([]) :-
    true.

proto_validation_rec([H|T]) :-
    isProtoIdValid(H),
    proto_validation_rec(T).

isProtoIdValid(H) :-
    H = '0x0800';
    H = '0x86dd'.
