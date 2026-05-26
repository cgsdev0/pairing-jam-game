extends Node


var score = 0

var players = 2

signal game_end

enum Cell {
	EMPTY = 0,
	FOOD,
}
var grid = []

func _ready():
	reset()
	
# Called when the node enters the scene tree for the first time.
func reset() -> void:
	grid = []
	var row = []
	for y in 12:
		for x in 16:
			row.append(Cell.EMPTY) # empty
		grid.append(row)
		row = []
