@tool
extends Node3D

@export_category("Debug Options")
@export var debug_script: bool: 
    set(b):
        Debug.self_debug_on = b
        debug_script = b
    get():
        return Debug.self_debug_on

signal power_rail_connected(connector: PowerConnector)
signal power_rail_disconnected(connector: PowerConnector)

enum Connector {
    CENTER, EDGE
}

const DISCONNECTED_TEX: StandardMaterial3D = preload("res://power_rail/disconnected_tex.tres")
const CONNECTED_TEX: StandardMaterial3D = preload("res://power_rail/connected_tex.tres")

@onready var power_rail: PowerRail = PowerRail.new(
    self, 
    %PowerRailModel, 
    %ConnectorCenter,
    %ConnectorEdge
)


func _is_rail_connected() -> bool:
    return power_rail.connected


func _is_connection_to_rail(connection: PowerConnector) -> bool:
    return connection.type != PowerConnector.PORTAL


func _is_connection_to_portal(connection: PowerConnector) -> bool:
    return connection.type == PowerConnector.PORTAL


func _has_min_connections() -> bool:
    if power_rail.edge_connector.power_node.nodes.size() < 1: return false
    if power_rail.edge_connector.power_node.nodes[0].type == PowerConnector.PORTAL: return true
    return power_rail.center_node.nodes.size() > 1 and power_rail.edge_node.nodes.size() > 1


func _power_up_rail() -> bool:
    power_rail.powered = true
    power_rail.model.material = CONNECTED_TEX
    return power_rail.powered


func _power_down_rail() -> bool:
    power_rail.powered = false
    power_rail.model.material = DISCONNECTED_TEX
    return power_rail.powered


func _disconnect_rail() -> bool:
    power_rail.connected = false
    return power_rail.connected


func is_enabled() -> bool:
    return power_rail.enabled


func enable_rail():
    power_rail.model.show()
    if not power_rail.center_collision: await ready
    power_rail.center_collision.disabled = false
    if not power_rail.edge_collision: await ready
    power_rail.edge_collision.disabled = false
    power_rail.enabled = true


func disable_rail():
    power_rail.model.hide()
    if !power_rail.center_collision: await ready
    power_rail.center_collision.disabled = true
    if !power_rail.edge_collision: await ready
    power_rail.edge_collision.disabled = true
    power_rail.enabled = false
    _disconnect_rail()


func connect_rail_to(_connector: PowerConnector):
    if _has_min_connections(): _power_up_rail()
 

func disconnect_rail_from(_connector: PowerConnector):
    if not _has_min_connections(): _power_down_rail()


func _on_visibility_changed() -> void:
    power_rail.center_collision.disabled = !visible
    power_rail.edge_collision.disabled = !visible
    power_rail.enabled = visible


func _on_center_connected(connector: PowerConnector) -> void:
    connect_rail_to(connector)
    power_rail_connected.emit(connector)


func _on_center_disconnected(connector: PowerConnector) -> void:
    disconnect_rail_from(connector)
    power_rail_disconnected.emit(connector)


func _on_edge_connected(connector: PowerConnector) -> void:
    connect_rail_to(connector)


func _on_edge_disconnected(connector: PowerConnector) -> void:
    disconnect_rail_from(connector)


class PowerRail extends Resource:
    var enabled: bool
    var is_ready: bool
    var obj: Node3D
    var connected: bool
    var powered: bool
    var model: Node3D
    var center_connector: PowerConnector
    var edge_connector: PowerConnector
    var center_collision: CollisionShape3D
    var edge_collision: CollisionShape3D
    var center_node: PowerConnector.PowerNode
    var edge_node: PowerConnector.PowerNode
    func _init(_obj:Node3D, _model:Node3D, _center:PowerConnector, _edge:PowerConnector) -> void:
        self.obj = _obj
        self.model = _model
        self.center_connector = _center
        self.edge_connector = _edge
        self.center_collision = _center.collision
        self.edge_collision = _edge.collision
        self.edge_node = _edge.power_node
        self.center_node = _center.power_node
        # connect the center and edge nodes of the rail together
        self.center_node.connect_node(self.edge_node)
        self.edge_node.connect_node(self.center_node)
            

class Debug extends DebugProto:
    static var self_debug_on: bool = false

    static func printdbg(msg: Array):
        if not self_debug_on: return
        super.printdbg(msg)
