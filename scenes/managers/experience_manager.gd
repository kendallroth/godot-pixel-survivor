extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal leveled_up(level: int)

## Target experience to advance to next level (starting at initial value)
@export_range(1, 100) var target_experience = 5
## Additional experience needed for every level
@export_range(1, 100) var target_experience_growth = 5

var current_experience = 0
var total_experience = 0
var current_level = 1

var current_experience_percent:
    get:
        return min(current_experience / target_experience, 1)


func _ready():
    GameEvents.player_collected_pickup.connect(on_player_collected_pickup)

    set_process_input(true)


func _unhandled_input(event: InputEvent):
    if !OS.is_debug_build() || event.is_echo():
        return

    # DEBUG: Allow incrementing experience/level quickly (in debug)
    if Input.is_key_pressed(Key.KEY_X):
        increment_experience(current_level)
    elif Input.is_key_pressed(Key.KEY_L):
        increment_experience(target_experience - current_experience)


func increment_experience(value: float):
    total_experience += value
    var potential_current_experience = current_experience + value
    # Cap (actual) experience gained at amount required to reach next level
    current_experience = min(potential_current_experience, target_experience)

    experience_updated.emit(current_experience, target_experience)
    GameEvents.player_experience_changed.emit(
        current_experience, current_experience_percent, value, total_experience
    )
    
    if potential_current_experience >= target_experience:
        increment_level(potential_current_experience - target_experience)


func increment_level(carry_over := 0):
    current_level += 1
    target_experience += target_experience_growth
    # Ensure that carried over experience does not promote additionally (would cause upgrade selection issues)
    current_experience = min(carry_over, target_experience - 1)

    experience_updated.emit(current_experience, target_experience)
    GameEvents.player_experience_changed.emit(
        current_experience, current_experience_percent, current_experience, total_experience
    )
    leveled_up.emit(current_level)
    GameEvents.player_level_changed.emit(current_level)


#region Listeners
func on_player_collected_pickup(pickup: PickupItem):
    if pickup.pickup_type != GameEnums.PickupItemType.EXPERIENCE:
        return

    increment_experience(pickup.pickup_amount)
#endregion
