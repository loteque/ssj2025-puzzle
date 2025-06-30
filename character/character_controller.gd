extends CharacterBody3D

@export var speed: float = 5.5
@export var fall_acceleration: float = 9.81

var target_velocity = Vector3.ZERO

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
    if event.is_action_pressed("demo_quit"):
        get_tree().quit()
    
    if event is InputEventMouseMotion:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
        rotation_degrees.y -= event.relative.x * 0.5
        %Camera3D.rotation_degrees.x -= event.relative.y * 0.2
        %Camera3D.rotation_degrees.x = clamp(
            %Camera3D.rotation_degrees.x, -60.0, 60.0
        )
    elif event.is_action_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(_delta):

    var input_direction_2D = Input.get_vector(
        "move_left", "move_right", "move_forward", "move_back"
    )
    var input_direction_3D = Vector3(
        input_direction_2D.x, 0, input_direction_2D.y
    )
    var direction = transform.basis * input_direction_3D

    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    move_and_slide()
