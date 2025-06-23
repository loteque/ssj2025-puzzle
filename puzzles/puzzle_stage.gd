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
@onready var nw_marker = %NW
@onready var n_marker = %N
@onready var ne_marker = %NE
@onready var w_marker = %W
@onready var c_marker = %C
@onready var e_marker = %E
@onready var sw_marker = %SW
@onready var s_marker = %S
@onready var se_marker = %SE

var grid_index_to_marker: Dictionary = {
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


var marker_to_grid_index: Dictionary = {
    nw_marker: GridIndex.NW,
    n_marker: GridIndex.N,
    ne_marker: GridIndex.NE,
    w_marker: GridIndex.W,
    c_marker: GridIndex.C,
    e_marker: GridIndex.E,
    sw_marker: GridIndex.SW,
    s_marker: GridIndex.S,
    se_marker: GridIndex.SE,
    null: GridIndex.NONE,
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


## Return the 3D marker for the given index.
func get_marker(grid_index: GridIndex) -> Marker3D:
    if grid_index == -1:
        return null
    return grid_index_to_marker[grid_index]


## Return an array of all the neighboring indicies of rooms given 
## a room at a given index. Return an empty array if the given index is invalid.
func get_neighbors(grid_index: GridIndex) -> Array:
    if grid_index <= 0:
        return []
    return grid_index_to_neighbors[grid_index]


## Return the grid index of a given Marker
func get_marker_grid_index(marker: Marker3D) -> GridIndex:
    return marker_to_grid_index[marker]


## return true only if the room at given index is of type COURTYARD = 0.
func try_index(grid_index: GridIndex) -> bool:
    var room = get_marker(grid_index).get_child(0) as Room
    if room is not Room or room == null:
        return false
    if room.room_config.room_type != 0:
        return false
    return true


## return the index of the room to check/try
func get_index_to_try(room: Room, direction: Room.WallIndex) -> GridIndex:
    var room_marker_index = get_marker_grid_index(room.get_parent())
    # if room_marker_index == GridIndex.NONE:
    #    return GridIndex.NONE
    var neighbors = get_neighbors(room_marker_index)
    if neighbors == null or neighbors.empty():
        return GridIndex.NONE
    match direction:
        Room.WallIndex.N:
            return neighbors[Room.WallIndex.S]
        Room.WallIndex.W:
            return neighbors[Room.WallIndex.E]
        Room.WallIndex.E:
            return neighbors[Room.WallIndex.W]
        Room.WallIndex.S:
            return neighbors[Room.WallIndex.N]
        _:
            return GridIndex.NONE
  

func _on_room_room_shift_requested(marker: Marker3D, direction: int) -> void:
    prints("_on_room_room_shift_requested", direction, marker.name)