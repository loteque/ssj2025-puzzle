@tool
extends Area3D
class_name InteractableArea3D

@export var interactable: Interactable

signal interaction_started(interactable: Interactable, interactor: Node3D, result: int)
signal interaction_completed(interactable: Interactable, interactor: Node3D, result: int)

var _enabled: bool

func _ready():
    add_to_group("Interactable")


func enable():
    process_mode = ProcessMode.PROCESS_MODE_INHERIT
    _enabled = true


func disable():
    process_mode = ProcessMode.PROCESS_MODE_DISABLED
    _enabled = false


func is_enabled() -> bool:
    return _enabled


func start_interaction(interactor: Node3D, status := Interactable.FAILED):
    interaction_started.emit(self, interactor, status)
    Interactable.Debug.try_start(interactor, self)


func end_interaction(interactor: Node3D, status := Interactable.FAILED):
        Interactable.Debug.try_status(interactor, self, Interactable.TEST_OK)
        interaction_completed.emit(interactable, interactor, status)
