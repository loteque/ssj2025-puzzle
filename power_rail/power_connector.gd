@tool
extends Area3D

enum {
    EDGE = 0,
    CENTER = 1,
    PORTAL = 2,
}

const TYPE_MAP: Dictionary = {
    EDGE: "EDGE",
    CENTER: "CENTER",
    PORTAL: "PORTAL",
}

@export_enum(TYPE_MAP[EDGE], TYPE_MAP[CENTER], TYPE_MAP[PORTAL]) var type: int

@onready var collision = %ConnectorCollision