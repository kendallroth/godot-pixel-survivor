extends CanvasLayer
class_name OptionsMenu

signal back_pressed()

@onready var back_button := $%BackButton
@onready var window_size_button := $%WindowSizeButton
@onready var effects_volume_slider := $%EffectsVolumeSlider
@onready var music_volume_slider := $%MusicVolumeSlider


func _ready():
    back_button.pressed.connect(on_back_button_pressed)
    effects_volume_slider.value_changed.connect(on_volume_slider_changed.bind("sfx"))
    music_volume_slider.value_changed.connect(on_volume_slider_changed.bind("music"))
    window_size_button.pressed.connect(on_window_button_pressed)

    update_display()


func update_display():
    window_size_button.text = "Windowed"
    if GameSettings.get_display_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        window_size_button.text = "Fullscreen"

    effects_volume_slider.value = GameSettings.get_audio_bus_volume_percent("sfx")
    music_volume_slider.value = GameSettings.get_audio_bus_volume_percent("music")


func on_back_button_pressed():
    GameSettings.write_config()

    GameScreens.transition()
    await GameScreens.transition_filled

    back_pressed.emit()


func on_volume_slider_changed(value: float, bus_name: String):
    GameSettings.set_audio_bus_volume_percent(bus_name, value)


func on_window_button_pressed():
    var current_mode = GameSettings.get_display_mode()
    if current_mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
        GameSettings.set_display_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        GameSettings.set_display_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    
    update_display()
