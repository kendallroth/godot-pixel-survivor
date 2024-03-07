extends CanvasLayer


func _ready():
    GameEvents.player_health_changed.connect(on_player_health_changed)


func on_player_health_changed(health: float, change: float, max_health: float):
    if change > 0:
        return

    $AnimationPlayer.play("hit")
