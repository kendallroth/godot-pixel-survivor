extends Node

@export var item_table: Array[EnemyDropItem] = []
@export_range(0, 1) var drop_chance := 0.5
@export var health_component: HealthComponent

## Enemy drop chance can be improved with meta upgrades
var adjusted_drop_chance:
    get:
        var drop_chance_upgrade_quantity := MetaProgression.get_purchased_upgrade_quantity("drop_chance")
        return min(drop_chance + (drop_chance_upgrade_quantity * 0.1), 1)


func _ready():
    health_component.died.connect(on_died)


func on_died():
    if !item_table.size() or !owner is Node2D:
        return

    # DEBUG
    print("normal ", drop_chance, " adjusted ", adjusted_drop_chance)
    if randf() > adjusted_drop_chance:
        return
    
    var drop_item: EnemyDropItem = WeightedResource.get_item(item_table)
    
    var spawn_position = (owner as Node2D).global_position
    var drop_item_instance = drop_item.item_scene.instantiate() as Node2D
    var entities_layer = get_tree().get_first_node_in_group("layer_entities")
    drop_item_instance.global_position = spawn_position
    entities_layer.add_child(drop_item_instance)

    if drop_item_instance is PickupItem:
        drop_item_instance.set_amount(drop_item.drop_amount)
