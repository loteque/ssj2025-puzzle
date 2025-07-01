@tool
extends Node3D

signal door_request_activated
signal power_rail_connected(connection: PowerConnector)
signal power_rail_disconnected(connection: PowerConnector)


@export var wall_enabled: bool = true:
    set(b):
        wall_enabled = b
        if !_is_door_ready(): return
        if b:
            enable_wall()
        else:
            disable_wall()


@export var doorway: bool:
    set(b):
        if !_is_door_ready(): return
        if b:
            add_door()
            power_rail.enable_rail()
            door_open = b
        else:
            remove_door()
            power_rail.disable_rail()
            door_open = !b
        doorway = b


@export var door_open: bool:
    set(b):
        if !_is_door_ready(): return
        if not doorway and wall_enabled: return
        if b:
            open_door()
        else:
            close_door()
        door_open = b


@export var switch_enabled: bool:
    set(b):
        if switch == null: return
        switch_enabled = b
        if switch_enabled:
            add_switch()
        else:
            remove_switch()


@onready var wall_collision := %WallCollision
@onready var wall_csg := %Wall
@onready var doorway_csg := %Doorway
@onready var door_collision := %DoorCollision
@onready var door_csg := %Door
@onready var switch := %PedestalSwitch
@onready var power_rail := %PowerRail
@onready var wall: Dictionary = {
    "enabled": false,
    "has_door": false,
    "has_switch": true,
    "has_power_rail": false,
    "wall": wall_csg,
    "collision": wall_collision,
    "power_rail": power_rail,
}
@onready var door: Dictionary = {
    "is_closed": false,
    "door": door_csg,
    "doorway": doorway_csg,
    "collision": door_collision,
}


func _is_door_ready() -> bool:
    return !door.is_empty()


func add_door():
    door["doorway"].show()
    door["collision"].disabled = true  
    wall["has_door"] = true


func remove_door():
    door["door"].hide()
    door["doorway"].hide()
    door["collision"].disabled = false
    wall["has_door"] = false


func close_door():
    door["door"].show()
    door["collision"].disabled = false
    door["is_closed"] = true


func open_door():
    door["door"].hide()
    door["collision"].disabled = true
    door["is_closed"] = false


func add_switch():
    switch.enable_switch()
    wall["has_switch"] = true


func remove_switch():
    switch.disable_switch()
    wall["has_switch"] = false


func _is_wall_ready() -> bool:
    return !wall.is_empty()


func enable_wall():
    wall["wall"].show()
    wall["collision"].show()
    wall["enabled"] = true


func disable_wall():
    wall["wall"].hide()
    wall["collision"].disabled = true
    door["is_closed"] = false
    wall["enabled"] = false


func is_wall_enabled() -> bool:
    return wall["enabled"]


func has_move_switch() -> bool:
    return wall["has_switch"]


func has_door() -> bool:
    return wall["has_door"]


func is_door_closed() -> bool:
    return door["is_closed"]


func _ready() -> void:
    if switch_enabled:
        add_switch()
    else:
        remove_switch()

    if doorway:
        add_door()
        if not power_rail: await ready
        power_rail.enable_rail()
    else:
        remove_door()
        if not power_rail: await ready
        if not power_rail.has_method("disable_rail"):
            power_rail.disable_rail()

    if door_open:
        open_door()
    else:
        close_door()


func _on_pedestal_switch_switch_activated() -> void:
    door_request_activated.emit()


func _on_power_rail_connected(connection: PowerConnector) -> void:
    power_rail_connected.emit(connection)


func _on_power_rail_disconnected(connection: PowerConnector) -> void:
    power_rail_disconnected.emit(connection)