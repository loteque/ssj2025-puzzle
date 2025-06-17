@tool
extends Node3D

@onready var interactable: InteractableArea3D = %InteractableArea3D
@onready var pedastal: CSGShape3D = %Pedastal
@onready var switch: CSGShape3D = %Switch

func enable_switch():
    pedastal.show()

func disable_switch():
    pedastal.hide()
