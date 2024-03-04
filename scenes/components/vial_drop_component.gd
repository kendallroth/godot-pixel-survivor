extends Node

@export var vial_scene: PackedScene
@export_range(0, 1) var drop_chance: float = 0.5
@export_range(1, 10) var drop_amount: int = 1
@export var health_component: HealthComponent

func _ready():
    health_component.died.connect(on_died)


func on_died():
    if !vial_scene or !owner is Node2D:
        return

    if randf() > drop_chance:
        return
    
    var spawn_position = (owner as Node2D).global_position
    var vial_instance = vial_scene.instantiate() as Node2D
    vial_instance.set_amount(drop_amount)
    var entities_layer = get_tree().get_first_node_in_group("layer_entities")
    vial_instance.global_position = spawn_position
    entities_layer.add_child(vial_instance)
