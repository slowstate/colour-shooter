extends Area2D

var tank: Tank
var shield_enabled: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shield_cooldown_timer: Timer = $ShieldCooldownTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	tank = owner as Tank
	assert(tank != null, "The state type must be used only in the Tank scene. It needs the owner to be a Tank node.")
	set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, true)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, true)
	self.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area as Bullet == null:
		return
	SfxManager.play_sound("EnemyHitSFX", -25.0,-23.0,2.0,2.2)
	animation_player.play("Tank_Beam")
	shield_cooldown_timer.start(8)
	_enable_tank_shield(false)


func _on_shield_cooldown_timer_timeout() -> void:
	_enable_tank_shield(true)


func _enable_tank_shield(enable_shield: bool) -> void:
	if enable_shield:
		animation_player.play_backwards("Tank_Fade")
	else:
		animation_player.play("Tank_Fade")

	set_collision_layer_value(Globals.CollisionLayer.TANK_SHIELD, enable_shield)
	set_collision_mask_value(Globals.CollisionLayer.BULLETS, enable_shield)
