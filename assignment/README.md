## Usage:

- Enter a packet predicate as input that returns if the packet is allowed, rejected or dropped.
- Input must include Adapter and Ethernet information of the packet.
- Empty Adapter information is considered to be any adapter (yet to be implemented).

### Syntax for input:
- ``` packet('A', [20, 30]). ```

Syntax for firewall clause:
- ``` allow('A', ['2-3', '5-60']). ```
