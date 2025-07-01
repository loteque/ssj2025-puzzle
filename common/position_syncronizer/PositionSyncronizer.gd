@tool
class_name PositionSyncronizer
extends Area3D

@export var enabled: bool = false
@export var valid_sync_group: StringName = "Player"
@export_category("Debug Options")
@export var debug_script: bool: 
    set(b):
        Debug.self_debug_on = b
        debug_script = b
    get():
        return Debug.self_debug_on

var sync_push_connections: Array[Node3D]

@onready var last_pos: Vector3 = self.global_transform.origin


func add_sync_connection(node:Node3D) -> bool:
    if node in sync_push_connections: return false
    sync_push_connections.append(node)
    Debug.printdbg(["Added", node, "\n\tto sync push connections for", self, "\n\t", sync_push_connections])
    return true


func remove_sync_connection(node:Node3D) -> bool:
    var index = sync_push_connections.find(node);
    if index < 0: return false
    sync_push_connections.remove_at(index)
    Debug.printdbg(["Removed", node, "\n\tfrom sync push connections for", self, "\n\t", sync_push_connections])
    return true


func _get_position_difference(current_position: Vector3, new_position: Vector3) -> Vector3:
    return current_position - new_position


func _sync_position(node_3d: Node3D) -> void:
    var position_difference = _get_position_difference(last_pos, self.global_transform.origin)
    node_3d.global_transform.origin += -position_difference


func _physics_process(_delta: float) -> void:
    if not enabled: return
    if sync_push_connections.is_empty(): return    
    for node in sync_push_connections:
        _sync_position(node)
    last_pos = self.global_transform.origin


func _on_body_entered(body:Node3D) -> void:
    if not enabled: return
    if valid_sync_group != "" or null:
        if !body.is_in_group(valid_sync_group): return
    add_sync_connection(body)


func _on_body_exited(body:Node3D) -> void:
    if not enabled: return
    await get_tree().create_timer(.02).timeout
    if valid_sync_group != "" or null:
        if !body.is_in_group(valid_sync_group): return
    remove_sync_connection(body)


class Debug extends DebugProto:
    static var self_debug_on: bool = false

    static func printdbg(msg: Array):
        if not self_debug_on: return
        super.printdbg(msg)