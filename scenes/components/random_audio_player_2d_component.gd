extends AudioStreamPlayer2D

@export var audio_streams: Array[AudioStream]
@export var randomize_pitch := true
@export_range(0.1, 1) var min_pitch := 0.9
@export_range(0.1, 2) var max_pitch := 1.1

@onready var base_pitch = pitch_scale


func play_random():
    if !audio_streams || !audio_streams.size():
        return
    
    if randomize_pitch:
        pitch_scale = randf_range(min_pitch, max_pitch)
    else:
        pitch_scale = base_pitch
    
    var random_stream = audio_streams.pick_random()
    stream = random_stream
    play()
