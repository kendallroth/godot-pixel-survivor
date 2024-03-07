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
    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        window_size_button.text = "Fullscreen"

    effects_volume_slider.value = get_audio_bus_volume_percent("sfx")
    music_volume_slider.value = get_audio_bus_volume_percent("music")


func get_audio_bus_volume_percent(bus_name: String):
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume_db = AudioServer.get_bus_volume_db(bus_index)
    return db_to_linear(volume_db)


func set_audio_bus_volume_percent(bus_name: String, percent: float):
    var bus_index = AudioServer.get_bus_index(bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(percent))


func on_back_button_pressed():
    GameScreens.transition()
    await GameScreens.transition_filled

    back_pressed.emit()


func on_volume_slider_changed(value: float, bus_name: String):
    set_audio_bus_volume_percent(bus_name, value)


func on_window_button_pressed():
    var current_mode = DisplayServer.window_get_mode()
    if current_mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    
    update_display()
