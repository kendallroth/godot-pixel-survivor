extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite_parent := $BodySpriteParent
@onready var velocity_component := $VelocityComponent


func _ready():
    health_component.died.connect(on_died)


func _physics_process(delta):
    velocity_component.accelerate_to_player()
    velocity_component.move(self)
    velocity_component.update_look_direction(true)


func on_died():
    GameEvents.enemy_killed.emit(global_position)

