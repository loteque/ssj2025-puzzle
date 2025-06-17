extends Resource
class_name Interactable

static var ACTION_NAME: StringName = "interact" 

@export var name: StringName
@export_multiline var succsess_string: String = "interaction with "+ name + " successful"
var group_name: StringName = "Interactable"
var status: int = FAILED

enum {
	OK,
    FAILED,
    INTERACTING,
    TEST_OK,
}

func interact_connect_debug(interactor, interactable):
    prints(interactor, "detecting interactable", interactable)

func interact_disconnect_debug(interactor, interactable):
    prints(interactor, "stopped detecting interactable", interactable)

func interact_start_debug(interactor, interactable):
    prints(interactor, "started interaction with", interactable)

func interact_status_debug(interactor, interactable, _status):
    prints(interactor, "ended interaction, status code:", _status, "with", interactable)
    if _status == OK:
        print(interactable.interactable.succsess_string)
