extends Node

@export_range(0, 100) var damage = 10
@export_range(0, 1000) var spawn_range = 100

@export_group("References")
@export var anvil_ability_scene: PackedScene

@onready var spawn_timer = $SpawnTimer

var base_damage
## Set from child `Timer`
var base_wait_time


func _ready():
    GameEvents.player_upgraded_ability.connect(on_ability_upgraded)
    spawn_timer.timeout.connect(on_timer_timeout)

    base_damage = damage
    base_wait_time = spawn_timer.wait_time


#region Listeners
func on_timer_timeout():
    var player := get_tree().get_first_node_in_group("player") as Node2D
    if (player == null):
        return

    var direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
    var spawn_position := player.global_position + (direction * randf_range(0, spawn_range))

    var ray_args := PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, PhysicsLayers.ENVIRONMENT)
    var result := get_tree().root.world_2d.direct_space_state.intersect_ray(ray_args)
    if !result.is_empty():
        spawn_position = result["position"]

    var anvil_instance := anvil_ability_scene.instantiate() as AnvilAbility
    anvil_instance.global_position = spawn_position
    var foreground_layer := get_tree().get_first_node_in_group("layer_foreground")
    foreground_layer.add_child(anvil_instance)
    anvil_instance.initialize(damage)


func on_ability_upgraded(upgrade: AbilityUpgrade, upgrades: Dictionary):
    if upgrade.id == "anvil_rate":
        var percent_reduction = upgrades["anvil_rate"]["quantity"] * 0.1
        spawn_timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
        spawn_timer.start()
    elif upgrade.id == "anvil_damage":
        var percent_increase = upgrades["anvil_damage"]["quantity"] * 0.1
        damage = base_damage * (1 + percent_increase)
#endregion
