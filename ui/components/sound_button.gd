# TODO: Consider creating a SoundButton component via Godot plugins
# https://docs.godotengine.org/en/stable/tutorials/plugins/editor/making_plugins.html

extends Button


func _ready():
    pressed.connect(on_pressed)


func on_pressed():
    $RandomAudioPlayerComponent.play_random()
