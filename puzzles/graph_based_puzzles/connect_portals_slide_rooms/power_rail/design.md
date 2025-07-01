## Game
### signals
```
signal player_won
```
## PowerRailNode
### Data Structure
```
class PowerRailNode
    var rail_nodes: Array[PowerRailNode]

```
### functions
func connect(to: PowerRailNode) -> bool
func disconnect(from: PowerRailNode) -> bool
func traverse(node: PowerRailNode, visited: Array[PowerRailNode] = [START_RAIL]) -> void:
    visited.append(node)
    for n in node.rail_nodes:
        if visited.has(n):
            continue
        if n.type == END_RAIL:
            player_won.emit()
        traverse(n, visited)
```