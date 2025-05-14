extends BaseMob
class_name Ghost

@export var detection_range: float = 300.0
@export var attack_range: float = 50.0
@export var speed: float = 80.0
@export var damage: float = 10.0
@export var attack_cooldown: float = 1.5
@export var path_update_interval: float = 0.5

@onready var path_update_timer: Timer = $PathUpdateTimer
@onready var attack_timer: Timer = $AttackTimer

var path: Array = []
var target: BasePlayer = null
var current_path_index: int = 0
var can_attack: bool = true

func _ready():
	super()
	
	# Make sure we have the needed timers
	if !has_node("PathUpdateTimer"):
		path_update_timer = Timer.new()
		path_update_timer.wait_time = path_update_interval
		path_update_timer.one_shot = false
		path_update_timer.autostart = true
		add_child(path_update_timer)
		path_update_timer.connect("timeout", _on_path_update_timer_timeout)
	else:
		path_update_timer = $PathUpdateTimer
	
	if !has_node("AttackTimer"):
		attack_timer = Timer.new()
		attack_timer.wait_time = attack_cooldown
		attack_timer.one_shot = true
		add_child(attack_timer)
		attack_timer.connect("timeout", _on_attack_timer_timeout)
	else:
		attack_timer = $AttackTimer

func _physics_process(delta):
	target = find_target()
	
	if target and has_path():
		follow_path(delta)
		
		if global_position.distance_to(target.global_position) <= attack_range:
			attack()

func _on_path_update_timer_timeout():
	if target:
		calculate_path_to_target()

func _on_attack_timer_timeout():
	can_attack = true

func find_target() -> BasePlayer:
	# Find closest player in detection range
	var player = Global.game.player
	if player and global_position.distance_to(player.global_position) <= detection_range:
		return player
	return null

func calculate_path_to_target():
	if target:
		path = find_path_to(target.global_position)
		current_path_index = 0

func find_path_to(target_pos: Vector2) -> Array:
	# Implement BFS pathfinding algorithm
	var start_tile = world.get_tile(global_position)
	var end_tile = world.get_tile(target_pos)
	
	var queue = []
	var visited = {}
	var parent = {}
	
	queue.push_back(start_tile)
	visited[start_tile] = true
	
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current == end_tile:
			# Path found, reconstruct it
			var path = []
			var tile = end_tile
			
			while tile != start_tile:
				if !parent.has(tile):
					break
				path.push_front(world.map_to_local(tile))
				tile = parent[tile]
			
			return path
		
		# Get neighbors (up, down, left, right)
		var neighbors = [
			current + Vector2i(0, -1),  # Up
			current + Vector2i(1, 0),   # Right
			current + Vector2i(0, 1),   # Down
			current + Vector2i(-1, 0)   # Left
		]
		
		for neighbor in neighbors:
			if !visited.has(neighbor) and is_walkable(neighbor):
				queue.push_back(neighbor)
				visited[neighbor] = true
				parent[neighbor] = current
	
	# No path found
	return []

func is_walkable(tile_pos: Vector2i) -> bool:
	# Check if the tile is air (walkable)
	return world.is_air_at(tile_pos)

func has_path() -> bool:
	return path.size() > 0 and current_path_index < path.size()

func follow_path(delta: float):
	if !has_path():
		return
		
	var next_point = path[current_path_index]
	var direction = global_position.direction_to(next_point)
	
	# Move towards the next point
	velocity = direction * speed
	
	# Update visual orientation if needed
	if velocity.x != 0:
		# This assumes your ghost sprite is facing right by default
		# and needs to be flipped when moving left
		if has_node("Visual"):
			$Visual.scale.x = sign(velocity.x)
	
	move_and_slide()
	
	# Check if we've reached the current point in the path
	if global_position.distance_to(next_point) < 10:
		current_path_index += 1
		
		# If we've reached the end of the path, calculate a new path
		if current_path_index >= path.size():
			calculate_path_to_target()

func attack():
	if can_attack:
		# Create a damage instance and apply to player
		var dmg = Damage.new(damage, Damage.Type.MELEE)
		target.health.receive_damage(dmg)
		
		# Start cooldown
		can_attack = false
		attack_timer.start()

func die():
	queue_free()
