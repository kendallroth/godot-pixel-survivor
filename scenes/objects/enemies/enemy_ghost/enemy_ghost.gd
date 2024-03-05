extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite_parent := $BodySpriteParent
@onready var velocity_component := $VelocityComponent

var is_moving := false


func _ready():
    health_component.died.connect(on_died)


func _physics_process(delta):
    if is_moving:
        velocity_component.accelerate_to_player()
    else:
        velocity_component.decelerate()

    velocity_component.move(self)
    velocity_component.update_look_direction(true)


func set_is_moving(moving: bool):
    is_moving = moving


func on_died():
    GameEvents.enemy_killed.emit(global_position)
