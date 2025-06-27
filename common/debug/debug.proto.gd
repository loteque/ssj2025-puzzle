extends Resource
class_name DebugProto

static var debug_on: bool = false


static func printdbg(message: Array):
    if not debug_on: return
    if message.is_empty(): return
    var _message: String = ""
    for i in message.size():
        _message += str(message[i]) + " "
    print(_message)
