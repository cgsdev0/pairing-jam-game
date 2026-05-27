extends Node


var scores = [0, 0]
var streaks = [0, 0]

var game_over = false
signal game_end

enum Cell {
	EMPTY = 0,
	FOOD1 = 1,
	FOOD2 = 2,
	PENDING = 3
}

func add_score(player):
	if game_over:
		return
	var other = int(!(player - 1))
	streaks[other] = 0
	streaks[player - 1] += 1
	streaks[player - 1] = min(streaks[player - 1], 5)
	scores[player - 1] += streaks[player - 1]
	return streaks[player - 1]

func is_food(pos: Vector2i):
	var g = grid[pos.y][pos.x]
	if g == Cell.FOOD1 || g == Cell.FOOD2:
		return true
	return false

func is_empty(pos: Vector2i):
	return grid[pos.y][pos.x] == Cell.EMPTY
	
var grid = []

func _ready():
	game_end.connect(on_end)
	reset()

func on_end():
	game_over = true
	
# Called when the node enters the scene tree for the first time.
func reset() -> void:
	game_over = false
	scores = [0, 0]
	streaks = [0, 0]
	grid = []
	var row = []
	for y in 12:
		for x in 16:
			row.append(Cell.EMPTY) # empty
		grid.append(row)
		row = []
