extends Resource
class_name Interactable

static var ACTION_NAME: StringName = "interact" 

@export var name: StringName
var group_name: StringName = "Interactable"
var status: int = FAILED
@export_category("Debug Options")
@export var debug: bool = false:
    set(b):
        debug = b
        Debug.self_debug_on = b
    get():
        return Debug.self_debug_on

enum {
	OK,
    FAILED,
    INTERACTING,
    TEST_OK,
}

class Debug extends DebugProto:

    static var self_debug_on: bool = false

    static func try_connect(interactor, interactable):
        if not self_debug_on: return
        printdbg([interactor, "detecting interactable", interactable])
    
    static func try_disconnect(interactor, interactable):
        if not self_debug_on: return
        printdbg([interactor, "stopped detecting interactable", interactable])

    static func try_start(interactor, interactable):
        if not self_debug_on: return
        printdbg([interactor, "started interaction with", interactable])

    static func try_status(interactor, interactable, status):
        if not self_debug_on: return
        printdbg([interactor, "ended interaction, status code:", status, "with", interactable])
        if status == OK:
            printdbg(["Interaction with", interactable.name, "successful"])

    static func printdbg(message: Array):
        if not self_debug_on: return
        super.printdbg(message)