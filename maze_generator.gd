extends Node2D

const COLUMNS = 16
const ROWS = 8
const WALL = 0
const PATH = 1
const LENGTH = 2
var map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var stack = []
	
	# Fill with walls
	for x in COLUMNS * LENGTH + 3:
		for y in ROWS * LENGTH + 3:
			map[Vector2i(x, y)] = WALL
	
	# Set start
	var start_x = 1 + randi_range(0, COLUMNS) * LENGTH
	var start_y = 1 + randi_range(0, ROWS) * LENGTH
	var current = Vector2i(start_x, start_y)
	stack.append(current)
	
	# Generate the maze
	while stack:
		var neighbors = check_neighbors(current)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			connect_cells(current, next)
			current = next
			stack.append(current)
		elif stack:
			current = stack.pop_back()
	
	# Show cells on the map
	set_cells()

# Returns an array of cell's unvisited neighbors
func check_neighbors(cell):

	var list = []
	
	var left = Vector2i(cell.x - LENGTH, cell.y)
	if map.has(left) and map[left] == WALL:
		list.append(left)
		
	var right = Vector2i(cell.x + LENGTH, cell.y)
	if map.has(right) and map[right] == WALL:
		list.append(right)
	
	var top = Vector2i(cell.x, cell.y - LENGTH)
	if map.has(top) and map[top] == WALL:
		list.append(top)
		
	var bottom = Vector2i(cell.x, cell.y + LENGTH)
	if map.has(bottom) and map[bottom] == WALL:
		list.append(bottom)
	
	return list

func connect_cells(from, to):
	var from_x = from.x if from.x <= to.x else to.x
	var to_x = to.x if from.x <= to.x else from.x
	var from_y = from.y if from.y <= to.y else to.y
	var to_y = to.y if from.y <= to.y else from.y
	for x in range(from_x, to_x + 1):
		for y in range(from_y, to_y + 1):
			map[Vector2i(x, y)] = PATH


func set_cells():
	for x in COLUMNS * LENGTH + 3:
		for y in ROWS * LENGTH + 3:
			$TileMap.set_cell(0, Vector2i(x, y), 0, Vector2i(map[Vector2i(x, y)], 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
