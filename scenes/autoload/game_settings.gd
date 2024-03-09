## AUTOLOADED

extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"

var config := ConfigFile.new()
var config_err := config.load(CONFIG_FILE_PATH)

func _ready():
    init_game_from_config()


func _exit_tree():
    # Ensure config file is saved before closing game
    write_config()


## Initialize game settings from configuration file
func init_game_from_config():
    if config_err:
        return
    
    set_display_mode(config.get_value("settings", "display_mode", DisplayServer.WINDOW_MODE_WINDOWED))
    set_audio_bus_volume_percent("music", config.get_value("settings", "audio_music", get_audio_bus_volume_percent("music")))
    set_audio_bus_volume_percent("sfx", config.get_value("settings", "audio_sfx", get_audio_bus_volume_percent("sfx")))

    # Write config again after initializing values (in case some were missing)
    write_config()


## Write current (in-memory) configuration to file
func write_config():
    config.save(CONFIG_FILE_PATH)


## Clear configuration file
func clear_config():
    config.clear()
    write_config()


#region Game Settings helpers
func get_audio_bus_volume_percent(bus_name: String):
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume_db = AudioServer.get_bus_volume_db(bus_index)
    return db_to_linear(volume_db)


func set_audio_bus_volume_percent(bus_name: String, percent: float):
    var bus_index = AudioServer.get_bus_index(bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(percent))
    config.set_value("settings", "audio_%s" % bus_name, percent)


func get_display_mode():
    return DisplayServer.window_get_mode()


func set_display_mode(mode: int):
    DisplayServer.window_set_mode(mode)
    config.set_value("settings", "display_mode", mode)
#endregion
