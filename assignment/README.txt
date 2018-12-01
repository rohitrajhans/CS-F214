Prolog Assignment 2018-19

- Problem 1:

  i) Firewall rules are encoded in Prolog as facts and rules: each rule may start with accept (allow the incoming packet), 
       reject (send reject information to sender), or drop (silently) followed by a clause.
  ii) Write a Prolog program to apply encoded rules on any incoming packet. Note that multiple rules may apply.

Authors

2016A7PS0105P - Rohit Rajhans
2016A7PS0127P - Siddhant Khandelwal

Input Constraints

Sample Input - packet('adapter A, ether vid 2 proto 30, ip src 192.168.1.0 dest 192.168.1.0, tcp src 12 dest 23, icmp type 20 code 30').