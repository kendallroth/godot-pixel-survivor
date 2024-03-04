extends Node2D
class_name DeathComponent


@export var health_component: HealthComponent
@export var sprite: Sprite2D


func _ready():
    $ParticleSystem.texture = sprite.texture
    health_component.died.connect(on_died)


func on_died():
    if !owner || !owner is Node2D:
        return

    var spawn_position = owner.global_position

    # NOTE: Must remove itself from tree before enemy is destroyed (or will not show), then re-add in global scene
    var entities = get_tree().get_first_node_in_group("layer_entities")
    get_parent().remove_child(self)
    entities.add_child(self)

    global_position = spawn_position
    $AnimationPlayer.play("default")
