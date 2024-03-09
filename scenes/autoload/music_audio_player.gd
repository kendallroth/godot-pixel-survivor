# AUTOLOADED

extends AudioStreamPlayer

@onready var timer := $DelayTimer


func _ready():
    finished.connect(on_finished)
    timer.timeout.connect(on_timer_timeout)


#region Listeners
func on_finished():
    timer.start()


func on_timer_timeout():
    play()
#endregion
