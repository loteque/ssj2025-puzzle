@tool
extends Node3D

signal power_rail_connected(power_rail: Dictionary)
signal power_rail_disconnected(power_rail: Dictionary)

@export_category("Debug Options")
@export var debug_script: bool: 
    set(b):
        Debug.self_debug_on = b
        debug_script = b
    get():
        return Debug.self_debug_on

enum Connector {
    CENTER, EDGE
}

const DISCONNECTED_TEX: StandardMaterial3D = preload("res://power_rail/disconnected_tex.tres")
const CONNECTED_TEX: StandardMaterial3D = preload("res://power_rail/connected_tex.tres")

@onready var power_rail: Dictionary = {
    "ready": func(): await ready; return true,
    "obj": self,
    "enabled": false,
    "connected": false,
    "powered": false,
    "model": %PowerRailModel,
    "conn_center_collision": %ConnectorCenter.collision,
    "conn_edge_collision": %ConnectorEdge.collision,
    "center_connected_to": null,
    "edge_connected_to": null,
}


@onready var portal_power: Dictionary = {
    "enabled": false,
}


func is_rail_enabled() -> bool:
    return power_rail["enabled"]


func is_rail_connected() -> bool:
    return power_rail["connected"]


func add_rail():
    power_rail["model"].show()
    if !power_rail["conn_center_collision"]: await ready
    power_rail["conn_center_collision"].disabled = false
    if !power_rail["conn_edge_collision"]: await ready
    power_rail["conn_edge_collision"].disabled = false
    power_rail["enabled"] = true


func remove_rail():
    power_rail["model"].hide()
    if !power_rail["conn_center_collision"]: await ready
    power_rail["conn_center_collision"].disabled = true
    if !power_rail["conn_edge_collision"]: await ready
    power_rail["conn_edge_collision"].disabled = true
    power_rail["enabled"] = false
    power_rail_disconnected.emit(power_rail)


func _connect_rail_to_portal(portal_connection: Dictionary, connector: Connector):
    match connector:
        Connector.EDGE:
            power_rail["edge_connected_to"] = portal_connection
            portal_connection["enabled"] = true
            power_rail["connected"] = true
            power_rail_connected.emit(power_rail)
            return true
        Connector.CENTER:
            power_rail["center_connected_to"] = portal_connection
            portal_connection["enabled"] = true
            power_rail["connected"] = true
            power_rail_connected.emit(power_rail)
            return true
        _:
            push_warning("Unknown connector type")
            return false


func _connect_rail(connection: Dictionary, connector: Connector) -> bool:
    match connector:
        Connector.EDGE:
            power_rail["edge_connected_to"] = connection
            power_rail["connected"] = true
            power_rail_connected.emit(power_rail)
            return true
        Connector.CENTER:
            power_rail["center_connected_to"] = connection
            power_rail["connected"] = true
            power_rail_connected.emit(power_rail)
            return true
        _:
            push_warning("Unknown connector type")
            return false


func _power_up_rail() -> bool:
    power_rail["powered"] = true
    power_rail["model"].material = CONNECTED_TEX
    return power_rail["powered"]


func _power_down_rail() -> bool:
        power_rail["powered"] = false
        power_rail["model"].material = DISCONNECTED_TEX
        return power_rail["powered"]


func _disconnect_rail():
    power_rail["edge_connected_to"] = null
    power_rail["center_connected_to"] = null
    power_rail["connected"] = false
    power_rail_disconnected.emit(power_rail)


func try_connect_rail(connection: Dictionary, connector: Connector) -> bool:
    if connection == portal_power: power_rail["enabled"] = true; Debug.printdbg(["\t","try_connect:","Rail enabled"])
    if !power_rail["enabled"]: 
        Debug.printdbg(["\t","try_connect:","Rail not enabled"]); return false
    if connection.has("ready"):
        return _connect_rail(connection, connector)
    else:
        return _connect_rail_to_portal(connection, connector)


func try_disconnect_rail() -> bool:
    if !power_rail["enabled"]: return false
    var has_connection = power_rail["edge_connected_to"] or power_rail["center_connected_to"]
    if has_connection: return false
    _disconnect_rail()
    return true


func try_power_up_rail() -> bool:
    if !power_rail["enabled"]: 
        Debug.printdbg(["\t","Rail not enabled"]); return _power_down_rail()   
    if !power_rail["center_connected_to"]: 
        Debug.printdbg(["\t","No center connection"]); return _power_down_rail()
    if !power_rail["edge_connected_to"]: 
        Debug.printdbg(["\t","No edge connection"]); return _power_down_rail()
    return _power_up_rail()


func disconnect_edge():
    if !power_rail["enabled"]: return false
    power_rail["edge_connected_to"] = null
    try_disconnect_rail()


func disconnect_center():
    if !power_rail["enabled"]: return false
    power_rail["center_connected_to"] = null
    try_disconnect_rail()


func _on_visibility_changed() -> void:
    power_rail["conn_center_collision"].disabled = !visible
    power_rail["conn_edge_collision"].disabled = !visible
    power_rail["enabled"] = visible
    power_rail_disconnected.emit(power_rail)


func _on_connector_edge_area_entered(area: Area3D) -> void:
    if !area.is_in_group("PowerConnector"): return
    Debug.printdbg(["\n","Rail edge area entered by", area.get_parent().name, area.name])
    var result: bool
    if area.type == area.PORTAL:
        result = try_connect_rail(portal_power, Connector.EDGE)
    else:
        result = try_connect_rail(area.get_parent().power_rail, Connector.EDGE)
    Debug.printdbg(["\t", result, area.TYPE_MAP[area.type], area.name, area.get_parent().name])
    if !result: return
    result = try_power_up_rail()
    Debug.printdbg(["\t","power",result])
    power_rail_connected.emit(power_rail)


func _on_connector_edge_area_exited(area: Area3D) -> void:
    if !area.is_in_group("PowerConnector"): return
    Debug.printdbg(["\n","Rail edge area exited by", area.get_parent().name, area.name])
    disconnect_edge()
    var result = try_power_up_rail()
    Debug.printdbg(["\t","power",result])
    power_rail_disconnected.emit(power_rail)


func _on_connector_center_area_entered(area: Area3D) -> void:
    if !area.is_in_group("PowerConnector"): return
    Debug.printdbg(["\n","Rail edge area entered by", area.get_parent().name, area.name])
    var result: bool
    if area.type == area.PORTAL:
        result = try_connect_rail(portal_power, Connector.CENTER)
    else:
        result = try_connect_rail(area.get_parent().power_rail, Connector.CENTER)
    Debug.printdbg(["\t", result, area.TYPE_MAP[area.type], area.name, area.get_parent().name])
    if !result: return
    result = try_power_up_rail()
    Debug.printdbg(["\t","power",result])
    power_rail_connected.emit(power_rail)


func _on_connector_center_area_exited(area: Area3D) -> void:
    if !area.is_in_group("PowerConnector"): return
    Debug.printdbg(["\n","Rail edge area exited by", area.get_parent().name, area.name])
    disconnect_center()
    var result = try_power_up_rail()
    Debug.printdbg(["\t","power",result])
    power_rail_disconnected.emit(power_rail)


func _debug_on_power_rail_connected(_power_rail: Dictionary) -> void:
    Debug.printdbg(["\t", "Rail connected", _power_rail.obj.name, ])


func _debug_on_power_rail_disconnected(_power_rail: Dictionary) -> void:
    # Debug.printdbg(["\t", "Rail disconnected", _power_rail])
    pass


class Debug extends DebugProto:
    static var self_debug_on: bool = false

    static func printdbg(msg: Array):
        if not self_debug_on: return
        super.printdbg(msg)
