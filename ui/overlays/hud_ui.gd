extends CanvasLayer

@onready var experience_label = $%ExperienceLabel
@onready var experience_bar = $%ExperienceBar
@onready var level_label = $%LevelLabel
@onready var time_label = $%TimeLabel

# TODO: Consider listening via game events instead (being sent anyway...)
@export var experience_manager: ExperienceManager
@export var level_manager: GameManager


func _ready():
    experience_manager.experience_updated.connect(on_experience_updated)
    experience_manager.leveled_up.connect(on_leveled_up)
    level_manager.level_time_changed.connect(on_level_time_updated)
    
    level_label.text = str(experience_manager.current_level)
    experience_label.text = format_experience_label(
        experience_manager.current_experience,
        experience_manager.target_experience
    )
    experience_bar.value = experience_manager.current_experience


func format_experience_label(current: float, target: float):
    return "%s / %s" % [current, target]


func on_leveled_up(level: int):
    level_label.text = str(level)


func on_experience_updated(current_experience, target_experience):
    experience_bar.value = current_experience / target_experience
    experience_label.text = format_experience_label(current_experience, target_experience)


func on_level_time_updated(seconds: int):
    var minutes = seconds / 60
    var remaining_seconds = floori(seconds - (minutes * 60))
    var time_string = "%s:%02d" % [minutes, remaining_seconds]
    time_label.text = time_string
