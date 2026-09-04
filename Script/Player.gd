extends KinematicBody2D

var bullet_assest = preload("res://Scene/Guns/Bullet.tscn") 
onready var aim_assest : AnimatedSprite =  $aim_sprite


var can_fire = true
var aim_distance = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Player")
	
func _physics_process(delta):
	player_movement()
	aim_weapons()
	
func player_movement():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("forward"):
		velocity.y -=1
	if Input.is_action_pressed("back"):
		velocity.y +=1
	if Input.is_action_pressed("left"):
		velocity.x -=1
	if Input.is_action_pressed("right"):
		velocity.x +=1
	if Input.is_action_pressed("fire") and can_fire:
		fire()
	velocity = velocity.normalized() * 50
	velocity = move_and_slide(velocity)

func fire():
	can_fire = false
	var direction = (get_global_mouse_position() - global_position).normalized()
	var bullet = bullet_assest.instance()
	
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = global_position + direction * 10
	bullet.rotation = direction.angle()
	if bullet.has_method("set_direction"):
		bullet.set_direction(direction)
	
	yield(get_tree().create_timer(1), "timeout")
	can_fire = true
		
func aim_weapons():
	var direction = (get_global_mouse_position() - global_position).normalized()
	aim_assest.global_position = global_position + direction * aim_distance
	
