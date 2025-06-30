class_name LGraphNode
extends RefCounted

var nodes: Array[LGraphNode]


func connect_node(to: LGraphNode) -> bool:
    if nodes.has(to): return false
    nodes.append(to); return true


func disconnect_node(from: LGraphNode) -> bool:
    if not nodes.has(from): return false 
    nodes.erase(from); return true


func dfs(node: LGraphNode = self, visited: Array[LGraphNode] = []) -> Array[LGraphNode]:
    if node not in visited:
        visited.append(node)
        for n in node.nodes:
            dfs(n, visited)
    return visited
