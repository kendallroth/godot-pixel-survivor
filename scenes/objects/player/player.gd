extends CharacterBody2D
class_name Player

@onready var abilities_node := $AbilityControllers
@onready var animation_player := $AnimationPlayer
@onready var health_component := $HealthComponent
@onready var sprite_parent := $BodySpriteParent
@onready var damage_timer := $DamageTimer
@onready var regen_timer := $RegenTimer
@onready var health_bar := $HealthBar
@onready var velocity_component := $VelocityComponent

# Damage (static) is applied on an interval while enemies remaing colliding with player
# TODO: Consider moving DamageTimer into script
var number_colliding_bodies := 0
var base_speed: float = 0
var health_regen_amount = 0


func _ready():
    $HurtboxArea.body_entered.connect(on_body_entered)
    $HurtboxArea.body_exited.connect(on_body_exited)
    damage_timer.timeout.connect(on_damage_timer_timeout)
    regen_timer.timeout.connect(on_regen_timer_timeout)
    health_component.health_changed.connect(on_health_changed)
    health_component.died.connect(on_died)
    GameEvents.player_upgraded_ability.connect(on_player_upgraded_ability)
    GameEvents.player_collected_pickup.connect(on_player_collected_pickup)
    
    base_speed = velocity_component.max_speed
    health_bar.value = health_component.health_percent

    if MetaProgression.has_purchased_upgrade("health_regen"):
        var health_regen_upgrade_quantity = MetaProgression.get_purchased_upgrade_quantity("health_regen")
        health_regen_amount = health_regen_upgrade_quantity


func _physics_process(delta):
    var movement := get_movement()
    var direction = movement.normalized()
    velocity_component.accelerate_in_direction(direction)
    velocity_component.move(self)
    velocity_component.update_look_direction(true)

    if movement != Vector2.ZERO:
        animation_player.play("walk")
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
    $HitAudioPlayerComponent.play_random()


#region Listeners
func on_body_entered(other_body: Node2D):
    number_colliding_bodies += 1
    check_deal_damage()


func on_body_exited(other_body: Node2D):
    number_colliding_bodies -= 1


func on_damage_timer_timeout():
    check_deal_damage()


func on_regen_timer_timeout():
    if health_component.has_full_health:
        return

    health_component.heal(health_regen_amount)


func on_player_collected_pickup(pickup: PickupItem):
    if pickup.pickup_type != GameEnums.PickupItemType.HEALTH:
        return
    
    health_component.heal(pickup.pickup_amount)


func on_health_changed(change: float, value: float, percent: float):
    health_bar.value = percent

    GameEvents.player_health_changed.emit(value, change, health_component.max_health)


func on_player_upgraded_ability(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if upgrade is Ability:
        var ability_instance = upgrade.controller_scene.instantiate()
        abilities_node.add_child(ability_instance)
    elif upgrade.id == "player_speed":
        var percent_increase = current_upgrades["player_speed"]["quantity"] * 0.1
        velocity_component.max_speed = base_speed * (1 + percent_increase)


func on_died():
    GameEvents.player_died.emit()
#endregion
