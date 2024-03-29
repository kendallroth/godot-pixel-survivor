# AUTOLOADED

extends Node

# Player event signals
signal player_died()
signal player_experience_changed(
    current_level_experience: int, current_level_progress: float, change: int, total_experience: int
)
signal player_health_changed(current_health: float, change: float, max_health: float)
signal player_level_changed(level: int)
signal player_collected_pickup(pickup: PickupItem)
signal player_upgraded_ability(upgrade: AbilityUpgrade, upgrades: Dictionary)

# Enemy event signals
signal enemy_count_changed(current_count: int, total_count: int)
signal enemy_killed(position: Vector2)
signal enemy_spawned(position: Vector2)

# Game/level signals
signal game_difficulty_changed(level: int)
