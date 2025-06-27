## Game
### signals
```
signal player_won
```
### functions
```
func is_won(graph: PowerRailGraph) -> bool:
    return graph.roots.size() == 2
```
## PowerRailEdge
### Data Structure
```
class PowerRailEdge
    var obj: PowerRail
    var center_connections: Array[PowerRailEdge]
    var edge_connection: PowerRailEdge
```
### functions
```
func add_center_connection(PowerRailEdge) -> bool
func remove_center_connection(PowerRail) -> bool
func add edge_connection(PowerRailEdge) -> bool
func remove_edge_connection(PowerRail) -> bool
func get_center_connections() -> Array[PowerRailEdge]
func get_center_connection(PowerRail) -> PowerRailEdge
func get_edge_connection() -> PowerRailEdge
func has_root() -> bool
```
## PowerRailGraph
### Data Structure 
```
class PowerRailGraph
    obj: Array[PowerRailEdge]
    roots: Array[PowerRailEdge]
    visited: Array[PowerRailEdge]
```
### functions
```
func add_graph(Array[PowerRailEdge]) -> bool
func has_edge(PowerRailEdge) -> bool
func add_edge(PowerRailEdge) -> bool
func is_root(PowerRailEdge) -> bool
func add_root(PowerRailEdge) -> bool
func remove_root(PowerRailEdge) -> bool
func traverse() -> void
    if not visited.has(edge):
        visited.append(edge)
        if is_root(edge):
            roots.append(edge)
            if Game.is_won():
                Game.player_won.emit()
```