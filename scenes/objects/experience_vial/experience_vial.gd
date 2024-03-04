extends Node2D

@onready var collision_shape := $%ExperienceCollider
@onready var experience_sprite := $%ExperienceSprite

var experience_amount := 1

func _ready():
    # TODO: Likely should be handled by either player pickup (allows emitting total as well)
    $ExperienceArea.area_entered.connect(on_area_entered)


func set_amount(value: int):
    experience_amount = value


func tween_collect(percent: float, start_position: Vector2):
    var player := get_tree().get_first_node_in_group("player") as Node2D
    if !player:
        return
 
    global_position = start_position.lerp(player.global_position, percent)
    var direction_from_start := player.global_position - start_position
    var target_rotation = direction_from_start.angle() + deg_to_rad(90)
    rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
    GameEvents.event_experience_collected.emit(experience_amount)
    queue_free()


func on_area_entered(other: Area2D):
    # NOTE: Cannot disable collider inside a physics event!
    Callable(func (): collision_shape.disabled = true).call_deferred()

    var tween := create_tween()
    tween.set_parallel()
    tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
        .set_ease(Tween.EASE_IN)\
        .set_trans(Tween.TRANS_BACK)
    tween.tween_property(experience_sprite, "scale", Vector2.ZERO, 0.05)\
        .set_delay(0.45)
    tween.chain()
    tween.tween_callback(collect)
