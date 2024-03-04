extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")


func _ready():
    area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
    if not other_area is HitboxComponent:
        return
    if !health_component:
        return
    
    var hitbox_component = other_area as HitboxComponent
    health_component.damage(hitbox_component.damage)

    var text_instance := floating_text_scene.instantiate() as FloatingText
    text_instance.global_position = global_position + (Vector2.UP * 16)
    get_tree().get_first_node_in_group("layer_foreground").add_child(text_instance)
    text_instance.start(str(hitbox_component.damage))
