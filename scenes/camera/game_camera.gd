# NOTE: Screen jitter (walls, players) during movement is a known issue

extends Camera2D

var target_position = Vector2.ZERO


func _ready():
    # Set camera as current game camera
    make_current()
    
    # Snap camera to target upon load
    acquire_target()
    global_position = target_position


func _physics_process(delta):
    acquire_target()
    # Frame-rate independent lerp (use higher value for less smoothing)
    # https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
    const lerp_rate = 15
    global_position = global_position.lerp(target_position, 1 - exp(-delta * lerp_rate))


func acquire_target():
    var player_node = get_tree().get_first_node_in_group("player")
    if !player_node:
        return

    target_position = player_node.global_position
