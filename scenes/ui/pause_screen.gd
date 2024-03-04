extends CanvasLayer
class_name PauseScreen


func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    set_process_input(true)
    get_tree().paused = true


func _input(event):
    if !event.is_action_pressed("menu_back"):
        return
    
    # NOTE: Must wait for a frame to prevent main game from intercepting this event after unpausing!
    await get_tree().process_frame
    get_tree().paused = false
    queue_free()
