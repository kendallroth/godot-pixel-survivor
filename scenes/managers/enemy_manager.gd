extends Node
class_name EnemyManager

# Area that enemies should be spawned outside of (just over half diagonal window size)
const SPAWN_RADIUS = 370

@export var level_manager: GameManager

var bat_enemy_scene := preload("res://scenes/objects/enemies/enemy_bat/enemy_bat.tscn")
var ghost_enemy_scene := preload("res://scenes/objects/enemies/enemy_ghost/enemy_ghost.tscn")
var rat_enemy_scene := preload("res://scenes/objects/enemies/enemy_rat/enemy_rat.tscn")

@onready var spawn_timer = $SpawnTimer;

## Minimum time between spawns (to prevent overrunning)
var min_spawn_interval := 0.3
var base_spawn_interval := 0
## Amount of time removed from base interval per difficulty step
var spawn_time_reduction_per_difficulty := 0.025

var enemies_per_spawn := 1
var base_enemies_per_spawn := enemies_per_spawn

var enemy_table := WeightedTable.new()

var current_enemy_count := 0
var total_enemy_count := 0


func _ready():
    GameEvents.enemy_killed.connect(on_enemy_died)
    spawn_timer.timeout.connect(on_spawn_timer)
    level_manager.game_difficulty_changed.connect(on_game_difficulty_changed)

    enemy_table.add_item(rat_enemy_scene, 10)
    base_spawn_interval = spawn_timer.wait_time


func get_spawn_position(player_position: Vector2) -> Vector2:
    var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
    var spawn_position := Vector2.ZERO

    for i in 4:
        spawn_position = player_position + (random_direction * SPAWN_RADIUS)

        # Avoid spawning enemies in walls by checking an additional distance beyond desired spawn location
        var additional_check_offset = random_direction * 20
        var ray_args := PhysicsRayQueryParameters2D.create(
            player_position,
            spawn_position + additional_check_offset,
            PhysicsLayers.ENVIRONMENT
        )
        var result := get_tree().root.world_2d.direct_space_state.intersect_ray(ray_args)
        if result.is_empty():
            break
        
        random_direction = random_direction.rotated(deg_to_rad(90))

    return spawn_position


#region Listeners
func on_spawn_timer():
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if !player:
        return
    
    spawn_timer.start()
    
    for i in enemies_per_spawn:
        var entities_layer := get_tree().get_first_node_in_group("layer_entities")
        var enemy_scene = enemy_table.get_item()
        var enemy := enemy_scene.instantiate() as Node2D
        enemy.global_position = get_spawn_position(player.global_position)
        entities_layer.add_child(enemy)

        current_enemy_count += 1
        total_enemy_count += 1

        GameEvents.enemy_spawned.emit(enemy.global_position)
        GameEvents.enemy_count_changed.emit(current_enemy_count, total_enemy_count)


func on_enemy_died(_position: Vector2):
    current_enemy_count -= 1

    GameEvents.enemy_count_changed.emit(current_enemy_count, total_enemy_count)


func on_game_difficulty_changed(difficulty: int):
    # Skip spawn timer changes once minimum spawn interval has been reached
    if spawn_timer.wait_time > min_spawn_interval:
        var time_removed_for_difficulty := spawn_time_reduction_per_difficulty * (difficulty - 1)
        var new_spawn_time: float = max(base_spawn_interval - time_removed_for_difficulty, min_spawn_interval)
        spawn_timer.wait_time = new_spawn_time

    # Increase amount of enemies spawned every set of difficulty levels
    if difficulty % 5 == 0:
        enemies_per_spawn += 1

    if difficulty == 3:
        enemy_table.add_item(ghost_enemy_scene, 15)
    elif difficulty == 8:
        enemy_table.add_item(bat_enemy_scene, 8)
#endregion
