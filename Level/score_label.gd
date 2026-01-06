extends Label

var score: int = 0

func _ready():
	add_to_group("score")
	update_text()

func add_score(amount: int):
	score += amount
	update_text()

func update_text():
	text = "Score: " + str(score)
