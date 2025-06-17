extends Area3D
class_name InteractableArea3D

@export var interactable: Interactable

signal interaction_started(interactable: Interactable, interactor: Node3D)
signal interaction_completed(interactable: Interactable, interactor: Node3D, result: int)

func _ready():
    add_to_group("Interactable")
    name = interactable.name

func start_interaction(interactor: Node3D):
    interaction_started.emit(self, interactor)
    interactable.interact_start_debug(interactor, self)

func end_interaction(interactor: Node3D):
        interactable.interact_status_debug(interactor, self, Interactable.TEST_OK)
        interaction_completed.emit(self, interactor, Interactable.TEST_OK)
