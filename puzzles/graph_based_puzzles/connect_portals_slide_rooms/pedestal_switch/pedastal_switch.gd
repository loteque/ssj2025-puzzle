@tool
extends Node3D

@onready var interactable: InteractableArea3D = %IA3D
@onready var pedastal: CSGShape3D = %Pedastal
@onready var switch: CSGShape3D = %Switch

signal switch_activated

func enable_switch():
    interactable.enable()
    pedastal.show()

func disable_switch():
    interactable.disable()
    pedastal.hide()


func _on_ia_3d_interaction_completed(_interactable: Interactable, _interactor: Node3D, result: int) -> void:
    if result == Interactable.OK:
        Interactable.Debug.printdbg(["_on_ia_3d_interaction_completed", interactable, _interactor, result])
        switch_activated.emit()
