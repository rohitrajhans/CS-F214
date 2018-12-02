# Prolog Assignment 2018-19

- Problem 1:
  1. Firewall rules are encoded in Prolog as facts and rules: each rule may start with accept (allow the incoming packet), 
       reject (send reject information to sender), or drop (silently) followed by a clause.
  2. Write a Prolog program to apply encoded rules on any incoming packet. Note that multiple rules may apply.

## Authors

2017A7PS0105P - Rohit Milind Rajhans
2017A7PS0127P - Siddhant Khandelwal

## Input Constraints

  - Sample Input
    ```[prolog]
    packet('adapter A, ether vid 2 proto 256, ip src 192.168.1.0 dest 192.168.2.2, tcp src 0 dest 1500, icmp type 10 code 5').
    ```
  - Blank inputs to be avoided.
  - All the data in the input is mandatory.

  - Adapter: adapter A
    Description: Keyword 'adapter' followed by a single character (A-Z).
  - Ethernet: ether vid [vid] proto [proto]
  - IP: 'ip src [IP-source-address-condition] dest [IP-destination-address-condition]'
    Description: addr is 'n.n.n.n' or 'n.n.n.n/[netmask]'
  - TCP: 'tcp src 0 dest 1500'
    tcp TCP-source-port-number-condition TCP-destination-port-number-condition
    udp UDP-source-port-number-condition UDP-destination-port-number-condition
  - ICMP: 'icmp type 10 code 5'
    icmp ICMP-type-condition ICMP-code-condition

## Implementation
  
  - The 'packet' rule accepts packet data as a string, parses it and verifies it with the existing database. [see db.pl]
  - Incoming packet information is matched with each rule and accordingly the result is displayed.
  - The database has 3 types of rules - 'allow', 'reject', 'drop'.

  - Format of rules:
    - Sample:
    ```[prolog]
    allow('A-C', ['2-35','256'], ["192.168.1.0", "192.168.2.2"], ['tcp','0-1000','1-2000'], ['5-15','5']).
    ```
    - Similar for all the three cases
    - rule_name('A', ['n', 'n'], ["n.n.n.n", "n.n.n.n"], ['tcp/udp','n','n'], ['n','n']).
      'n' is a valid integer, 'A' is name of adapter
    - Firewall clauses are in the order: 
      adapter, ethernet, ip, tcp/udp, icmp.
    - 'tcp/udp' specifies the port.
    - Values separated by a ',' represent multiple values. 
    - Values separated by a '-' represent a range of values.
    - Values within rule specified by "any" are don't care conditions. 
    - The verification of clause is skipped in presence of "any".

## Output

  - After verification of Input Parameters:
    - In case of allow, 'Packet Allowed' is printed and 'true' value is returned.
    - In case of reject, 'Packet Rejected' is printed and 'true' value is returned.
    - In case of drop, no message is printed and 'true' value is returned.
    - In case input parameters do not match with existing database rules, 
      'Packet does not match any clause, rejected by default' is printed and 'false' value is returned.
