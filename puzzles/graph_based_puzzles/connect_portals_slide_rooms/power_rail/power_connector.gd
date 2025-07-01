@tool
class_name PowerConnector
extends Area3D

@export_enum(TYPE_MAP[EDGE], TYPE_MAP[CENTER], TYPE_MAP[PORTAL]) var type: int
@export_category("Debug Options")
@export var debug_script: bool: 
    set(b):
        Debug.self_debug_on = b
        debug_script = b
    get():
        return Debug.self_debug_on

signal connected(connector: PowerConnector)
signal disconnected(connector: PowerConnector)

enum {
    EDGE = 0,
    CENTER = 1,
    PORTAL = 2,
}

const TYPE_MAP: Dictionary = {
    EDGE: "EDGE",
    CENTER: "CENTER",
    PORTAL: "PORTAL",
}

var graph_set: Array[LGraphNode] = []

@onready var power_node: PowerNode = PowerNode.new(type)
@onready var collision = %ConnectorCollision


func _on_area_entered(area:Area3D) -> void:
    if not area.is_in_group("PowerConnector"): return
    power_node.connect_node(area.power_node)
    area.power_node.connect_node(power_node)
    graph_set = power_node.dfs()
    power_node.graph_set_has_portals(graph_set)
    Debug.printdbg(["\n", "Connected: "])
    Debug.printdbg(["\t", TYPE_MAP[type], power_node, "portals", power_node.portals])
    Debug.printdbg(["\t", "graph_set:", graph_set])
    connected.emit(area)


func _on_area_exited(area:Area3D) -> void:
    if not area.is_in_group("PowerConnector"): return
    power_node.disconnect_node(area.power_node)
    area.power_node.disconnect_node(power_node)
    graph_set = power_node.dfs()
    power_node.graph_set_has_portals(graph_set)
    Debug.printdbg(["\n", "Disconnected: "])
    Debug.printdbg(["\t", TYPE_MAP[type], power_node, "portals", power_node.portals])
    Debug.printdbg(["\t", "graph_set:", graph_set])
    disconnected.emit(area)


class PowerNode extends LGraphNode:
    var type: int
    var portals: Array[LGraphNode]

    func get_portals(from: Array[LGraphNode]) -> Array[LGraphNode]:
        portals.clear()
        for n in from:
            if n.type != PowerConnector.PORTAL: continue
            portals.append(n)
        return portals
    
    
    func graph_set_has_portals(graph_set: Array[LGraphNode]) -> bool:
        get_portals(graph_set)
        if portals.size() < 2: return false
        return true


    func _init(_type: int):
        self.type = _type

class Debug extends DebugProto:
    static var self_debug_on: bool = false

    static func printdbg(msg: Array):
        if not self_debug_on: return
        super.printdbg(msg)