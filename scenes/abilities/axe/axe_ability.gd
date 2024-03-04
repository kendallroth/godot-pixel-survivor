extends Node2D
class_name AxeAbility

## Radius grows alongside rotations
var base_radius = 100
var base_rotations
var duration = 2
var rotations = 2
var starting_rotation = Vector2.RIGHT

## Max radius grows as rotations increase
var max_radius:
    get:
        return base_radius * (rotations / base_rotations)


## NOTE: Must be called *after* adding to scene tree!
func initialize(_damage: float, _duration: float, _rotations: float):
    base_rotations = rotations
    starting_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    duration = _duration
    rotations = _rotations
    $HitboxComponent.damage = _damage

    var tween = create_tween()
    # Interpolates up to rotation count over specified duration
    tween.tween_method(axe_tween_method, 0.0, rotations, duration)
    tween.tween_callback(queue_free)


func axe_tween_method(rotation_tween: float):
    var current_radius = (rotation_tween / duration) * max_radius
    var current_direction = starting_rotation.rotated(rotation_tween * TAU)

    var player = get_tree().get_first_node_in_group("player")
    if !player:
        return

    global_position = player.global_position + (current_direction * current_radius)
