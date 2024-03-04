extends Node

@export_range(0, 100) var damage = 10
## Number of rotations axe will complete after spawning
@export_range(1, 5) var rotations = 2
## How long axe remains after spawning
@export_range(0.5, 10) var duration = 2.5
@export_group("References")
@export var axe_ability_scene: PackedScene

@onready var spawn_timer = $SpawnTimer

var base_damage
var base_rotations
## Set from child `Timer`
var base_wait_time


func _ready():
    base_damage = damage
    base_rotations = rotations
    base_wait_time = spawn_timer.wait_time

    GameEvents.player_upgraded_ability.connect(on_ability_upgraded)
    spawn_timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if (player == null):
        return

    var axe_instance = axe_ability_scene.instantiate() as AxeAbility    
    var foreground_layer = get_tree().get_first_node_in_group("layer_foreground")
    axe_instance.global_position = player.global_position
    foreground_layer.add_child(axe_instance)
    axe_instance.initialize(damage, duration, rotations)


func on_ability_upgraded(upgrade: AbilityUpgrade, upgrades: Dictionary):
    if upgrade.id == "axe_rate":
        var percent_reduction = upgrades["axe_rate"]["quantity"] * 0.1
        spawn_timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
        spawn_timer.start()
    elif upgrade.id == "axe_damage":
        var percent_increase = upgrades["axe_damage"]["quantity"] * 0.1
        damage = base_damage * (1 + percent_increase)
    # Axe range is implicitly increased by lengthening duration
    elif upgrade.id == "axe_range":
        var percent_increase = upgrades["axe_range"]["quantity"] * 0.1
        rotations = base_rotations * (1 + percent_increase)
