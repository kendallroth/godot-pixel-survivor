extends Node

# Player event signals
signal player_died()
signal player_experience_changed(current_level: int, total_experience: int)
signal player_health_changed(current_health: float, change: float, max_health: float)
signal player_level_changed(level: int)
signal player_upgraded_ability(upgrade: AbilityUpgrade, upgrades: Dictionary)

# Enemy event signals
signal enemy_count_changed(current_count: int, total_count: int)
signal enemy_killed(position: Vector2)
signal enemy_spawned(position: Vector2)

# Game/level signals
signal level_difficulty_changed(level: int)

# Event signals (likely not final handler/emitter)
signal event_experience_collected(value: float)
signal event_health_collected(value: float)

