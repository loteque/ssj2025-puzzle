@tool
extends Node3D

## This script is used to teleport the player to a portal's destination.
## It is attached to the portal's area and uses a Marker3D node to 
## determine the player's arrival position.
## It is also used to enable/disable the power rail model and the
## power rail connector nodes in sync with the visibility of the portal.
## Connector nodes emit a signal when they are connected or disconnected.

signal power_rail_connected(power_rail: Dictionary)
signal power_rail_disconnected(power_rail: Dictionary)

@export var destination_portal: Node3D

@onready var arrival_offset: Marker3D = %ArrivalOffset


func _on_portal_area_body_entered(body:Node3D) -> void:
    if !body.is_in_group("Player"): return
    DebugProto.printdbg(["Player entered portal area"])
    var destination_pos = destination_portal.arrival_offset.global_transform.origin
    body.global_transform.origin = destination_pos
