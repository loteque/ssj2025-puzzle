extends StaticBody3D

@export var puzzle_name: StringName
@export var puzzle_number: int

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
	Room.GridIndex.NW: nw_marker,
	Room.GridIndex.N: n_marker,
	Room.GridIndex.NE: ne_marker,
	Room.GridIndex.W: w_marker,
	Room.GridIndex.C: c_marker,
	Room.GridIndex.E: e_marker,
	Room.GridIndex.SW: sw_marker,
	Room.GridIndex.S: s_marker,
	Room.GridIndex.SE: se_marker,
}


func get_marker(grid_index: Room.GridIndex) -> Marker3D:
    if grid_index == -1:
        return null
    return grid_index_to_marker[grid_index]
