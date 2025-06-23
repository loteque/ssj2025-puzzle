extends StaticBody3D

@export var puzzle_name: StringName
@export var puzzle_number: int

enum GridIndex {
    NONE = -1, 
    NW = 0, 
    N = 1, 
    NE = 2, 
    W = 3, 
    C = 4, 
    E = 5, 
    SW = 6, 
    S = 7, 
    SE = 8
}
const NW_NEIGHBORS: Array = [-1, -1, GridIndex.N, GridIndex.W]
const N_NEIGHBORS: Array = [-1, GridIndex.NW, GridIndex.NE, GridIndex.C]
const NE_NEIGHBORS: Array = [-1, GridIndex.N, -1, GridIndex.E]
const W_NEIGHBORS: Array = [GridIndex.NW, -1, GridIndex.C, GridIndex.SW]
const C_NEIGHBORS: Array = [GridIndex.N, GridIndex.W, GridIndex.E, GridIndex.S]
const E_NEIGHBORS: Array = [GridIndex.NE, GridIndex.C, -1, GridIndex.SE]
const SW_NEIGHBORS: Array = [GridIndex.W, -1, GridIndex.C, GridIndex.S, -1]
const S_NEIGHBORS: Array = [GridIndex.C, GridIndex.SW, GridIndex.SE, -1]
const SE_NEIGHBORS: Array = [GridIndex.E, GridIndex.S, -1, -1]
const grid_index_to_neighbors: Dictionary = {
	GridIndex.NW: NW_NEIGHBORS,
	GridIndex.N: N_NEIGHBORS,
	GridIndex.NE: NE_NEIGHBORS,
	GridIndex.W: W_NEIGHBORS,
	GridIndex.C: C_NEIGHBORS,
	GridIndex.E: E_NEIGHBORS,
	GridIndex.SW: SW_NEIGHBORS,
	GridIndex.S: S_NEIGHBORS,
	GridIndex.SE: SE_NEIGHBORS,
}

@onready var nw_marker = %NW
@onready var n_marker = %N
@onready var ne_marker = %NE
@onready var w_marker = %W
@onready var c_marker = %C
@onready var e_marker = %E
@onready var sw_marker = %SW
@onready var s_marker = %S
@onready var se_marker = %SE
@onready var grid_index_to_marker: Dictionary = {
	GridIndex.NW: nw_marker,
	GridIndex.N: n_marker,
	GridIndex.NE: ne_marker,
	GridIndex.W: w_marker,
	GridIndex.C: c_marker,
	GridIndex.E: e_marker,
	GridIndex.SW: sw_marker,
	GridIndex.S: s_marker,
	GridIndex.SE: se_marker,
    GridIndex.NONE: null,
}
@onready var marker_name_to_grid_index: Dictionary = {
    nw_marker.name: GridIndex.NW,
    n_marker.name: GridIndex.N,
    ne_marker.name: GridIndex.NE,
    w_marker.name: GridIndex.W,
    c_marker.name: GridIndex.C,
    e_marker.name: GridIndex.E,
    sw_marker.name: GridIndex.SW,
    s_marker.name: GridIndex.S,
    se_marker.name: GridIndex.SE,
    null: GridIndex.NONE,
}


## Return the 3D marker for the given index.
func get_marker(grid_index: GridIndex) -> Marker3D:
    if grid_index < 0:
        return null
    return grid_index_to_marker[grid_index]


## Return an array of all the neighboring indicies of rooms given 
## a room at a given index. Return an empty array if the given index is invalid.
func get_neighbors(grid_index: GridIndex) -> Array:
    if grid_index < 0:
        return []
    return grid_index_to_neighbors[grid_index]


## Return the grid index of a given Marker
func get_marker_grid_index(marker: Marker3D) -> GridIndex:
    if !marker_name_to_grid_index.has(marker.name):
        prints("puzzle_stage.gd, 94:", "Invalid marker", marker)
        prints(marker_name_to_grid_index)
        return marker_name_to_grid_index[null]
    return marker_name_to_grid_index[marker.name]


## return true only if the room at given index is of type COURTYARD = 0.
func try_index(grid_index: GridIndex) -> bool:
    if grid_index < 0:
        prints("try_index", grid_index)
        return false
    var room = get_marker(grid_index).get_child(0) as Room
    if room is not Room or room == null:
        return false
    if room.room_config.room_type != 0:
        return false
    return true


## return the index of the room to check/try
func get_index_to_try(room: Room, direction: Room.WallIndex) -> GridIndex:
    var room_marker_index = get_marker_grid_index(room.get_parent())
    var neighbors = get_neighbors(room_marker_index)
    if neighbors == null or neighbors.is_empty():
        prints("get_index_to_try", "no neighbors", room_marker_index, neighbors)
        return GridIndex.NONE
    prints("get_index_to_try, direction:", direction)
    match direction:
        Room.WallIndex.N:
            return neighbors[Room.WallIndex.N]
        Room.WallIndex.W:
            return neighbors[Room.WallIndex.W]
        Room.WallIndex.E:
            return neighbors[Room.WallIndex.E]
        Room.WallIndex.S:
            return neighbors[Room.WallIndex.S]
        _:
            return GridIndex.NONE
  

func _on_room_room_shift_requested(marker: Marker3D, direction: int) -> void:
    prints("_on_room_room_shift_requested", direction, marker.name)
    var requesting_room: Room = marker.get_child(0) as Room
    var index_to_try = get_index_to_try(requesting_room, direction)
    prints("index_to_try", index_to_try)
    var can_move: bool = try_index(index_to_try)
    prints("can_move", can_move)
    if !can_move:
        return
    requesting_room.global_transform.origin = get_marker(index_to_try).global_transform.origin
    requesting_room.reparent(get_marker(index_to_try))
