class_name RoomConfig 
extends Resource

@export_enum("courtyard","deadend","twoway","threeway","cross","hallway") var room_type: int
@export_enum("0", "90", "180", "270") var rotation_90: int
@export_category("Walls")
@export var n_wall: WallConfig
@export var w_wall: WallConfig
@export var e_wall: WallConfig
@export var s_wall: WallConfig
@export_category("Physics")
@export var position_sync_enabled: bool = false