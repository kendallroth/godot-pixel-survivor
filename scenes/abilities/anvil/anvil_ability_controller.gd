extends Node

@export_range(0, 100) var damage = 10
@export_range(0, 1000) var spawn_range = 100

@export_group("References")
@export var anvil_ability_scene: PackedScene

@onready var spawn_timer = $SpawnTimer

var spawn_amount := 1

var base_spawn_amount
var base_damage
## Set from child `Timer`
var base_wait_time


func _ready():
    GameEvents.player_upgraded_ability.connect(on_ability_upgraded)
    spawn_timer.timeout.connect(on_timer_timeout)

    base_damage = damage
    base_spawn_amount = spawn_amount
    base_wait_time = spawn_timer.wait_time


func spawn_anvil(position: Vector2):
    var spawn_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
    var rotation_for_symmetry := 360.0 / spawn_amount
    var spawn_distance := randf_range(32, spawn_range)

    for i in spawn_amount:
        if i > 0:
            # Offset multiple anvil spawns (by time)
            await get_tree().create_timer(randf_range(0.05, 0.25)).timeout

        # Spawn anvils symmetrically around player
        var adjusted_direction := spawn_direction.rotated(deg_to_rad(i * rotation_for_symmetry))
        var spawn_position := position + (adjusted_direction * spawn_distance)

        var ray_args := PhysicsRayQueryParameters2D.create(position, spawn_position, PhysicsLayers.ENVIRONMENT)
        var result := get_tree().root.world_2d.direct_space_state.intersect_ray(ray_args)
        if !result.is_empty():
            spawn_position = result["position"]

        var anvil_instance := anvil_ability_scene.instantiate() as AnvilAbility
        anvil_instance.global_position = spawn_position
        var foreground_layer := get_tree().get_first_node_in_group("layer_foreground")
        foreground_layer.add_child(anvil_instance)
        anvil_instance.initialize(damage)


#region Listeners
func on_timer_timeout():
    var player := get_tree().get_first_node_in_group("player") as Node2D
    if !player:
        return
    
    spawn_anvil(player.global_position)


func on_ability_upgraded(upgrade: AbilityUpgrade, upgrades: Dictionary):
    if upgrade.id == "anvil_amount":
        var extra_anvils = upgrades["anvil_amount"]["quantity"]
        spawn_amount = base_spawn_amount + extra_anvils
#endregion
