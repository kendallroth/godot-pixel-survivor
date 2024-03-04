extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal leveled_up(level: int)

## Target experience to reach first level
@export_range(1, 100) var target_experience = 5
## Additional experience needed for every level
@export_range(1, 100) var target_experience_growth = 5

var current_experience = 0
var total_experience = 0
var current_level = 1


func _ready():
    GameEvents.event_experience_collected.connect(increment_experience)


func increment_experience(value: float):
    total_experience += value
    # Cap experience gained at amount required to reach next level
    current_experience = min(current_experience + value, target_experience)

    experience_updated.emit(current_experience, target_experience)
    GameEvents.player_experience_changed.emit(current_experience, target_experience, total_experience)
    
    if current_experience >= target_experience:
        increment_level()


func increment_level():
    current_level += 1
    target_experience += target_experience_growth
    current_experience = 0

    experience_updated.emit(current_experience, target_experience)
    leveled_up.emit(current_level)
    GameEvents.player_experience_changed.emit(current_experience, target_experience, total_experience)
    GameEvents.player_level_changed.emit(current_level)
