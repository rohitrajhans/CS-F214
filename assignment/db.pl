allow('A-P', ['2-3','30'], ["192.168.1.0", "192.168.1.7"], ['tcp','12','23'], ['20','30-40']).
allow('A-P', ['2-3','30'], ["192.168.1.0/2", "192.168.1.7/3"], ['tcp','12','23'], ['20','30-40']).
allow('A-P', ['2-3','30'], ["192.168.2.0,192.168.1.1", "192.168.1.0"], ['tcp','12','23-45'], ['20','30,35']).
allow('A,H,C,D,E', ['30','20'], ["192.168.2.5", "192.168.1.0"], ['tcp','12','23'], ['20','30']).
allow('Z', ['4,50','60'], ["192.168.2.5", "192.168.1.0"], ['tcp','12','23'], ['20','30']).
allow("any", ['123,456','60'], ["192.168.2.5", "192.168.1.0"], ['tcp','12','23'], ['20','30']).
reject('A,H,C,D,E', ['30','50'], ["192.168.2.5-192.168.2.7", "192.168.1.0"], ['tcp','12','23'], ['20','30']).
drop('B', ['20', '5-8'], ["192.168.2.5", "192.168.1.0"], ['tcp','12','23'], ['20','30']).

% need to work on following input:
% packet("adapter A, ether vid 2 proto 3, ip src 123 dest 345, tcp src 123 dest 345, icmp type 2 code 10 ")