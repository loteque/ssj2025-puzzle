extends Area3D

var reparenting = false

func _on_body_exited(body:Node3D) -> void:
    if !body.is_in_group("Player"): return
    if body.get_parent() == get_parent(): return
    var new_parent = get_tree().get_first_node_in_group("Main")
    if reparenting: return
    reparenting = true
    body.reparent(new_parent)
    await body_entered
    reparenting = false


func _on_body_entered(body:Node3D) -> void:
    if !body.is_in_group("Player"): return
    if body.get_parent() == get_parent(): return
    var new_parent = get_parent()
    if reparenting: return
    reparenting = true
    body.reparent(new_parent)
    await body_exited
    reparenting = false
