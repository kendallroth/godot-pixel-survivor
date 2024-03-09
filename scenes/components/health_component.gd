extends Node
class_name HealthComponent

signal health_changed(change: float, value: float, percent: float)
signal died()

@export var max_health: float = 10

var current_health: float
var alive: bool:
    get:
        return current_health > 0
var health_percent: float:
    get:
        return min(current_health / max_health, 1) if max_health > 0 else 0
var has_full_health:
    get:
        return health_percent >= 1


func _ready():
    current_health = max_health


func heal(value: float):
    if !value:
        return

    current_health = min(current_health + value, max_health)
    health_changed.emit(value, current_health, health_percent)


func damage(value: float):
    if !value:
        return

    current_health = max(current_health - value, 0)
    health_changed.emit(-value, current_health, health_percent)

    if current_health > 0:
        return
    
    Callable(die).call_deferred()


func die():
    died.emit()
    owner.queue_free()

