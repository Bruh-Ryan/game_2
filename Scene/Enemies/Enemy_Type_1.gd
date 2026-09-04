extends KinematicBody2D
onready var player_fir : RayCast2D = $Player_Finder
onready var furniture_map = get_node("../Map_1/Furniture")

var speed = 30
var enemy_speed = 30
var follow_player = false
var player_ref = null

var wander_velocity = Vector2.ZERO
onready var wander_timer = $WanderTimer  # a Timer node, set wait_time in editor

func _ready():
	add_to_group("Enemy")
	randomize()
	wander_timer.connect("timeout", self, "_pick_new_wander_direction")
	_pick_new_wander_direction() 
	
func _physics_process(delta):
	if follow_player and player_ref:
		var direction = (player_ref.global_position - global_position).normalized()
		move_and_slide(direction * enemy_speed)
	else:
		move_and_slide(wander_velocity)

func _pick_new_wander_direction():
	var velocity = Vector2.ZERO
	velocity.x = 1 if randf() > 0.5 else -1
	velocity.y = 1 if randf() > 0.5 else -1
	wander_velocity = velocity.normalized() * speed



func _on_Detect_Sphere_body_entered(body):
	if body.is_in_group("Player"):
		player_ref = body
		follow_player = true
	print(body.name)
	var local_pos = furniture_map.to_local(global_position)
	var cell = furniture_map.world_to_map(local_pos)

	var tile_id = furniture_map.get_cellv(cell)
	if tile_id != -1:
		var tile_name = furniture_map.tile_set.tile_get_name(tile_id)
		print("Standing on tile: ", tile_name, " at cell: ", cell)

func _on_Detect_Sphere_body_exited(body):
	if body.is_in_group("Player"):
		follow_player = false
		player_ref = null
	print(body.name)
