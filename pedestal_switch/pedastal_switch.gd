@tool
extends Node3D

@onready var interactable: InteractableArea3D = %IA3D
@onready var pedastal: CSGShape3D = %Pedastal
@onready var switch: CSGShape3D = %Switch

func enable_switch():
    interactable.enable()
    pedastal.show()

func disable_switch():
    interactable.disable()
    pedastal.hide()
