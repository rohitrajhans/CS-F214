Prolog Assignment 2018-19

- Problem 1:
  1. Firewall rules are encoded in Prolog as facts and rules: each rule may start with accept (allow the incoming packet), 
       reject (send reject information to sender), or drop (silently) followed by a clause.
  2. Write a Prolog program to apply encoded rules on any incoming packet. Note that multiple rules may apply.

Authors

2017A7PS0105P - Rohit Milind Rajhans
2017A7PS0127P - Siddhant Khandelwal

Input Constraints:
  - Sample Input - ```packet('adapter A, ether vid 2 proto 256, ip src 192.168.1.0 dest 192.168.2.2, tcp src 0 dest 1500, icmp type 10 code 5').```
  - Blank inputs should be avoided.
  - All the data in the input is mandatory

  - Adapter: 'adapter A' - keyword adapter followed by a single character adapter (A-Z).
  - IP: 'ip src addr dest addr' - addr : 'n.n.n.n' or 'n.n.n.n/<netmask>'

Implementation:
  - The packet rule accepts packet data as a string, parses it and validates it with the existing database.
  - The database has 3 rules allow, reject, drop.

  - Format of rules are similar:
    - rule_name('A', ['n', 'n'], ["n.n.n.n", "n.n.n.n"], ['tcp/udp','n','n'], ['n','n']).
    - Firewall clauses are in the order adapter, ethernet, ip, tcp/udp, icmp.
    - 'A' is the name of adapter. 'n' represents a number.
    - 'tcp/udp' specifies the port.
    - Values separated by a ',' represent multiple values. Values separated by a '-' represent a range of values.
    - Values within rule specified by "any" are don't care conditions. The validation of clause is skipped in presence of "any".
    - Sample: allow('A-C', ['2-35','256'], ["192.168.1.0", "192.168.2.2"], ['tcp','0-1000','1-2000'], ['5-15','5']).

  - Incoming packet information is matched with each rule and accordingly the result is displayed.


- Output
  - After validation of input parameters, a message 'packet allowed' is printed and 'true' value is returned.
  - In case of reject, a message 'packet rejected' is printed and 'true' value is returned.
  - In case of drop, no message is printed and 'true' value is returned.
  - In case input parameters do not match with existing database rules, a message 'packet rejected' is printed and 'false' value is returned.