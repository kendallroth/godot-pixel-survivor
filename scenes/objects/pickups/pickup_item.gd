extends Node2D
class_name PickupItem

# signal collected(item: PickupItem)

## Base amount to be picked up (if not set when instantiating)
@export var pickup_type: GameEnums.PickupItemType
@export_range(0, 100) var pickup_amount := 1

# TODO: Investigate automatically detecting these like Unity `GetComponentInChildren` (perhaps with utility and warning system)?
@export_group("References")
@export var audio_player: AudioStreamPlayer2D
@export var collision_area: Area2D
@export var collision_shape: CollisionShape2D
@export var pickup_sprite: Sprite2D


func _ready():
    # TODO: Could be handled by player pickup instead, but may be easiest this way (tweens, etc)?
    collision_area.area_entered.connect(on_area_entered)


## Update pickup amount
func set_amount(value: int):
    pickup_amount = value


func tween_collect(percent: float, start_position: Vector2):
    # NOTE: Must keep fetching player in case it is suddenly invalid/null
    var player_ref: Player = get_tree().get_first_node_in_group("player")
    if !player_ref:
        return
 
    global_position = start_position.lerp(player_ref.global_position, percent)
    var direction_from_start := player_ref.global_position - start_position
    var target_rotation := direction_from_start.angle() + deg_to_rad(90)
    rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func tween_collect_end():
    # NOTE: Must play sound before emitting event to avoid cutting off on levelup (audio player is set to non-pausable)
    audio_player.play_random()
    GameEvents.player_collected_pickup.emit(self)
    # Must wait to remove pickup scene until pickup audio has finished (to avoid cutoff)
    audio_player.finished.connect(queue_free)


func on_area_entered(other: Area2D):
    if !other.owner is Player:
        return

    # NOTE: Cannot disable collider inside a physics event!
    Callable(func (): collision_shape.disabled = true).call_deferred()

    var tween := create_tween()
    tween.set_parallel()
    tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
        .set_ease(Tween.EASE_IN)\
        .set_trans(Tween.TRANS_BACK)
    tween.tween_property(pickup_sprite, "scale", Vector2.ZERO, 0.05)\
        .set_delay(0.45)
    tween.chain()
    tween.tween_callback(tween_collect_end)
