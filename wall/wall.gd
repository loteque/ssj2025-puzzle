@tool
extends Node3D

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
            door_open = b
        else:
            remove_door()
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

signal door_request_activated()

var _is_wall_enabled: bool = false
var _has_door: bool = false
var _is_door_closed: bool = false
var _has_switch: bool = false


@onready var wall_collision = %WallCollision
@onready var wall_csg = %Wall
@onready var doorway_csg = %Doorway
@onready var door_collision = %DoorCollision
@onready var door_csg = %Door
@onready var switch = %PedestalSwitch


@onready var door: Dictionary = {
    "is_closed": _is_door_closed,
    "door": door_csg,
    "doorway": doorway_csg,
    "collision": door_collision,
}
func _is_door_ready() -> bool:
    return !door.is_empty()

@onready var wall: Dictionary = {
    "enabled": _is_wall_enabled,
    "has_door": _has_door,
    "wall": wall_csg,
    "collision": wall_collision,
}
func _is_wall_ready() -> bool:
    return !wall.is_empty()

func enable_wall():
    wall["wall"].show()
    wall["collision"].show()
    wall["enabled"] = true

func disable_wall():
    wall["wall"].hide()
    wall["collision"].disabled = true
    door_open = true
    wall["enabled"] = false


func close_door():
    door["door"].show()
    door["collision"].disabled = false
    door["is_closed"] = true


func open_door():
    door["door"].hide()
    door["collision"].disabled = true
    door["is_closed"] = false


func remove_door():
    door["door"].hide()
    door["doorway"].hide()
    door["collision"].disabled = false
    wall["has_door"] = false


func add_door():
    door["doorway"].show()
    door["collision"].disabled = true  
    wall["has_door"] = true


func add_switch():
    switch.enable_switch()
    _has_switch = true


func remove_switch():
    switch.disable_switch()
    _has_switch = false


func is_wall_enabled() -> bool:
    return _is_wall_enabled


func has_move_switch() -> bool:
    return _has_switch


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
    else:
        remove_door()

    if door_open:
        open_door()
    else:
        close_door()


func _on_pedestal_switch_switch_activated() -> void:
    prints("_on_pedestal_switch_switch_activated")
    door_request_activated.emit()
