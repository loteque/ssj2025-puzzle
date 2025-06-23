@tool
extends StaticBody3D
class_name Room

@export var puzzle_stage: StaticBody3D
@export var room_config: RoomConfig = RoomConfig.new():
    set(rc):
        room_config = rc
        if !room_config.n_wall:
            room_config.n_wall = WallConfig.new()
        if !room_config.w_wall:
            room_config.w_wall = WallConfig.new()
        if !room_config.e_wall:
            room_config.e_wall = WallConfig.new()
        if !room_config.s_wall:
            room_config.s_wall = WallConfig.new()
        #n wall config
        n_wall_enabled = rc.n_wall.wall_enabled
        n_doorway = rc.n_wall.doorway_enabled
        n_door_open = rc.n_wall.door_open
        n_switch_enabled = rc.n_wall.switch_enabled
        #w wall config
        w_wall_enabled = rc.w_wall.wall_enabled
        w_doorway = rc.w_wall.doorway_enabled
        w_door_open = rc.w_wall.door_open
        w_switch_enabled = rc.w_wall.switch_enabled
        #e wall config
        e_wall_enabled = rc.e_wall.wall_enabled
        e_doorway = rc.e_wall.doorway_enabled
        e_door_open = rc.e_wall.door_open
        e_switch_enabled = rc.e_wall.switch_enabled
        #s wall config
        s_wall_enabled = rc.s_wall.wall_enabled
        s_doorway = rc.s_wall.doorway_enabled
        s_door_open = rc.s_wall.door_open
        s_switch_enabled = rc.s_wall.switch_enabled

@export_category("Room Type")
@export_enum("courtyard","deadend","twoway","threeway","cross","hallway") var room_type: int:
    set(i):
        room_config.room_type = i
        room_type = i
    get():
        return room_config.room_type

@export_enum("0", "90", "180", "270") var rotation_90: int:
    set(i):
        room_config.rotation_90 = i
        rotation_90 = i
    get():
        return room_config.rotation_90

@export_category("N Wall")
@export var n_wall: Node3D
@export var n_wall_enabled: bool:
    set(b):
        if !n_wall: return
        n_wall.wall_enabled = b
        n_wall_enabled = b
        room_config.n_wall.wall_enabled = b
    get():
        return room_config.n_wall.wall_enabled
@export var n_doorway: bool:
    set(b):
        if !n_wall: return
        n_wall.doorway = b
        n_doorway = b
        room_config.n_wall.doorway_enabled = b
    get():
        return room_config.n_wall.doorway_enabled
@export var n_door_open: bool:
    set(b):
        if !n_wall: return
        n_wall.door_open = b
        n_door_open = b
        room_config.n_wall.door_open = b
    get():
        return room_config.n_wall.door_open
@export var n_switch_enabled: bool:
    set(b):
        if !n_wall: return
        n_wall.switch_enabled = b
        n_switch_enabled = b
        room_config.n_wall.switch_enabled = b
    get():
        return room_config.n_wall.switch_enabled


@export_category("W Wall")
@export var w_wall: Node3D
@export var w_wall_enabled: bool:
    set(b):
        if !w_wall: return
        w_wall.wall_enabled = b
        w_wall_enabled = b
        room_config.w_wall.wall_enabled = b
    get():
        return room_config.w_wall.wall_enabled
@export var w_doorway: bool:
    set(b):
        if !n_wall: return
        w_wall.doorway = b
        w_doorway = b
        room_config.w_wall.doorway_enabled = b
    get():
        return room_config.w_wall.doorway_enabled
@export var w_door_open: bool:
    set(b):
        if !w_wall: return
        w_wall.door_open = b
        w_door_open = b
        room_config.w_wall.door_open = b
    get():
        return room_config.w_wall.door_open
@export var w_switch_enabled: bool:
    set(b):
        if !w_wall: return
        w_wall.switch_enabled = b
        w_switch_enabled = b
        room_config.w_wall.switch_enabled = b
    get():
        return room_config.w_wall.switch_enabled


@export_category("E Wall")
@export var e_wall: Node3D
@export var e_wall_enabled: bool:
    set(b):
        if !e_wall: return
        e_wall.wall_enabled = b
        e_wall_enabled = b
        room_config.e_wall.wall_enabled = b
    get():
        return room_config.e_wall.wall_enabled
@export var e_doorway: bool:
    set(b):
        if !e_wall: return
        e_wall.doorway = b
        e_doorway = b
        room_config.e_wall.doorway_enabled = b
    get():
        return room_config.e_wall.doorway_enabled
@export var e_door_open: bool:
    set(b):
        if !e_wall: return
        e_wall.door_open = b
        e_door_open = b
        room_config.e_wall.door_open = b
    get():
        return room_config.e_wall.door_open
@export var e_switch_enabled: bool:
    set(b):
        if !e_wall: return
        e_wall.switch_enabled = b
        e_switch_enabled = b
        room_config.e_wall.switch_enabled = b
    get():
        return room_config.e_wall.switch_enabled


@export_category("S Wall")
@export var s_wall: Node3D
@export var s_wall_enabled: bool:
    set(b):
        if !s_wall: return
        s_wall.wall_enabled = b
        s_wall_enabled = b
        room_config.s_wall.wall_enabled = b
    get():
        return room_config.s_wall.wall_enabled
@export var s_doorway: bool:
    set(b):
        if !s_wall: return
        s_wall.doorway = b
        s_doorway = b
        room_config.s_wall.doorway_enabled = b
    get():
        return room_config.s_wall.doorway_enabled
@export var s_door_open: bool:
    set(b):
        if !s_wall: return
        s_wall.door_open = b
        s_door_open = b
        room_config.s_wall.door_open = b
    get():
        return room_config.s_wall.door_open
@export var s_switch_enabled: bool:
    set(b):
        if !s_wall: return
        s_wall.switch_enabled = b
        s_switch_enabled = b
        room_config.s_wall.switch_enabled = b
    get():
        return room_config.s_wall.switch_enabled

signal room_shift_requested(direction: WallIndex)

enum {
    COUTYARD,
    DEADEND,
    TW0WAY,
    THREEWAY,
    CROSS,
    HALLWAY,
}


static var types_map: Dictionary = {
    "courtyard": COUTYARD,
    "deadend": DEADEND,
    "twoway": TW0WAY,
    "threeway": THREEWAY,
    "cross": CROSS,
    "hallway": HALLWAY,
}


enum WallIndex {
    N, W, E, S
}


func _ready():
    room_config = room_config


func _on_n_wall_door_request_activated() -> void:
    room_shift_requested.emit(WallIndex.N)
    prints("_on_n_wall_door_request_activated","N")


func _on_w_wall_door_request_activated() -> void:
    room_shift_requested.emit(WallIndex.W)
    prints("_on_w_wall_door_request_activated","W")

func _on_e_wall_door_request_activated() -> void:
    room_shift_requested.emit(WallIndex.E)
    prints("_on_e_wall_door_request_activated","E")

func _on_s_wall_door_request_activated() -> void:
    room_shift_requested.emit(WallIndex.S)
    prints("_on_s_wall_door_request_activated","S")