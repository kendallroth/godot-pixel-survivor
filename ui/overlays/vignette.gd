extends CanvasLayer

@onready var animation_player := $AnimationPlayer


func _ready():
    GameEvents.player_health_changed.connect(on_player_health_changed)


func on_player_health_changed(health: float, change: float, max_health: float):
    if change > 0:
        return

    # NOTE: Workaround to ensure vignette always returns to default state (even when paused)
    var previous_process_mode := process_mode
    process_mode = Node.PROCESS_MODE_ALWAYS

    animation_player.play("hit")

    await animation_player.animation_finished
    process_mode = previous_process_mode
