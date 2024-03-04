extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 20

@onready var abilities_node := $Abilities
@onready var animation_player := $AnimationPlayer
@onready var health_component := $HealthComponent
@onready var sprite_parent := $BodySpriteParent
@onready var damage_timer := $DamageTimer
@onready var health_bar := $HealthBar

var number_colliding_bodies := 0


func _ready():
    $HitboxArea.body_entered.connect(on_body_entered)
    $HitboxArea.body_exited.connect(on_body_exited)
    damage_timer.timeout.connect(on_damage_timer_timeout)
    health_component.health_changed.connect(on_health_changed)
    health_component.died.connect(on_died)
    GameEvents.player_upgraded_ability.connect(on_player_upgraded_ability)
    
    health_bar.value = health_component.health_percent


func _physics_process(delta):
    var movement := get_movement()
    # Frame-rate independent lerp (use higher value for less smoothing)
    var target_velocity := movement * MAX_SPEED
    var current_velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
    set_velocity(current_velocity)
    move_and_slide()

    if movement != Vector2.ZERO:
        animation_player.play("walk")

        # Flip the player to face movement direction
        var move_sign = sign(movement.x)
        if move_sign != 0:
            sprite_parent.scale = Vector2(move_sign, 1)
    else:
        animation_player.play("RESET")


func get_movement() -> Vector2:
    var movement_x := Input.get_axis("move_left", "move_right")
    var movement_y := Input.get_axis("move_up", "move_down")
    var movement := Vector2(movement_x, movement_y)
    return movement.normalized()


func check_deal_damage():
    if number_colliding_bodies <= 0 || !damage_timer.is_stopped():
        return
    
    health_component.damage(1)
    damage_timer.start()


func on_body_entered(other_body: Node2D):
    number_colliding_bodies += 1
    check_deal_damage()


func on_body_exited(other_body: Node2D):
    number_colliding_bodies -= 1


func on_damage_timer_timeout():
    check_deal_damage()


func on_health_changed(change: float, value: float, percent: float):
    health_bar.value = percent

    GameEvents.player_health_changed.emit(value, change, health_component.max_health)


func on_player_upgraded_ability(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if !upgrade is Ability:
        return

    var ability_instance = upgrade.controller_scene.instantiate()
    abilities_node.add_child(ability_instance)


func on_died():
    GameEvents.player_died.emit()
