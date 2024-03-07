extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var hit_audio_streams: Array[AudioStream] = []

@onready var audio_player := $RandomAudioPlayerComponent

var floating_text_scene = preload("res://ui/components/floating_text.tscn")


func _ready():
    area_entered.connect(on_area_entered)

    if audio_player:
        audio_player.audio_streams = hit_audio_streams


func on_area_entered(other_area: Area2D):
    if !other_area is HitboxComponent:
        return
    if !health_component:
        return
    
    var hitbox_component := other_area as HitboxComponent
    health_component.damage(hitbox_component.damage)

    var text_instance := floating_text_scene.instantiate() as FloatingText
    text_instance.global_position = global_position + (Vector2.UP * 16)
    get_tree().get_first_node_in_group("layer_foreground").add_child(text_instance)
    var damage_format = "%.1f" if round(hitbox_component.damage) != hitbox_component.damage else "%0.0f"
    text_instance.start(damage_format % hitbox_component.damage)

    if audio_player:
        audio_player.play_random()
