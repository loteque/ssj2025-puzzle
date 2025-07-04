extends RayCast3D
class_name InteractableRayCast3D

@export var interactor: Node

var has_interactable: bool
var interactable_area: InteractableArea3D
var is_interacting: bool

signal interactable_connected(area: InteractableArea3D)
signal interactable_disconnected(area: InteractableArea3D)


func _ready() -> void:
    collide_with_areas = true
    collide_with_bodies = false


func _physics_process(_delta: float) -> void:
    
    if not is_colliding() and has_interactable:
        interactable_disconnected.emit(interactable_area)
        return  

    if not is_colliding(): 
        is_interacting = false
        interactable_area = null
        return
        
    var target = get_collider()
    

    if target.is_in_group("Interactable"):
        interactable_connected.emit(target)
        

func _on_interactable_connected(area: InteractableArea3D) -> void:
    has_interactable = true
    is_interacting = true
    interactable_area = area
    

func _on_interactable_disconnected(area:InteractableArea3D) -> void:
    has_interactable = false
    is_interacting = false
    interactable_area = area
    Interactable.Debug.try_disconnect(interactor, area)


func _unhandled_input(event: InputEvent) -> void:
    if not has_interactable: return
    if event.is_action_pressed(Interactable.ACTION_NAME):
        interactable_area.start_interaction(interactor, Interactable.INTERACTING)
    elif event.is_action_released(Interactable.ACTION_NAME):
        interactable_area.end_interaction(interactor, Interactable.OK)
