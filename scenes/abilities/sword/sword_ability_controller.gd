extends Node

@export_range(0, 100) var damage = 5
@export_range(5, 1000) var max_range = 100
@export_group("References")
@export var sword_ability_scene: PackedScene

@onready var spawn_timer = $SpawnTimer

var base_damage
var base_range
## Set from child `Timer`
var base_wait_time


func _ready():
    base_damage = damage
    base_range = max_range
    base_wait_time = spawn_timer.wait_time

    GameEvents.player_upgraded_ability.connect(on_ability_upgraded)
    spawn_timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if (player == null):
        return

    # Find all enemies within range
    var enemies = get_tree().get_nodes_in_group("enemies")
    enemies = enemies.filter(func (enemy: Node2D):
        return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, 2)
    )
    if (enemies.size() == 0):
        return

    # Attack closest enemy
    enemies.sort_custom(func(a: Node2D, b: Node2D):
        var a_distance = a.global_position.distance_squared_to(player.global_position)
        var b_distance = b.global_position.distance_squared_to(player.global_position)
        return a_distance < b_distance
    )
    var closest_enemy = enemies[0]

    var sword_instance = sword_ability_scene.instantiate() as SwordAbility    
    # Offset the sword from enemy anywhere within a small offset circle
    sword_instance.global_position = closest_enemy.global_position + Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
    var foreground_layer = get_tree().get_first_node_in_group("layer_foreground")
    foreground_layer.add_child(sword_instance)
    sword_instance.initialize(damage)
    
    # Orient the sword towards the enemy
    var enemy_direction = closest_enemy.global_position - sword_instance.global_position
    sword_instance.rotation = enemy_direction.angle()


func on_ability_upgraded(upgrade: AbilityUpgrade, upgrades: Dictionary):
    if upgrade.id == "sword_rate":
        var percent_reduction = upgrades["sword_rate"]["quantity"] * 0.1
        spawn_timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
        spawn_timer.start()
    elif upgrade.id == "sword_damage":
        var percent_increase = upgrades["sword_damage"]["quantity"] * 0.1
        damage = base_damage * (1 + percent_increase)
    elif upgrade.id == "sword_range":
        var percent_increase = upgrades["sword_range"]["quantity"] * 0.1
        max_range = base_range * (1 + percent_increase)
