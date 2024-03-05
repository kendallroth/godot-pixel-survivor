extends Node
class_name VelocityComponent


@export_range(1, 250) var max_speed := 40
## Acceleration controls the rate at which enemies can change move direction (lower is more time)
@export_range(0, 100) var acceleration := 5
@export var sprite_parent: Node2D

var velocity = Vector2.ZERO


func accelerate_to_player():
    var owner_node = owner as Node2D
    if !owner_node:
        return
    
    var player = get_tree().get_first_node_in_group("player") as Node2D
    if !player:
        return
    
    var direction = (player.global_position - owner_node.global_position).normalized()
    accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
    var desired_velocity = direction * max_speed
    velocity = velocity.lerp(desired_velocity, 1 - exp(-get_physics_process_delta_time() * acceleration))


func decelerate():
    accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
    character_body.velocity = velocity
    character_body.move_and_slide()
    velocity = character_body.velocity


func update_look_direction(faces_right: bool):
    if sprite_parent:
        var move_sign = sign(velocity.x)
        if move_sign != 0:
            var face_sign = -1 if faces_right else 1
            sprite_parent.scale = Vector2(-move_sign * face_sign, 1)
