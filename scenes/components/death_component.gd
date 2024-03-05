extends Node2D
class_name DeathComponent


@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var death_audio_streams: Array[AudioStream] = []

@onready var audio_player := $RandomAudioPlayerComponent


func _ready():
    health_component.died.connect(on_died)

    $ParticleSystem.texture = sprite.texture
    if audio_player:
        audio_player.audio_streams = death_audio_streams


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

    if audio_player:
        audio_player.play_random()
