extends Control

export (PackedScene) var next_scene = load("res://Levels/Level1.tscn")
export (String, MULTILINE) var final_text = """Loading message......done^#Hunter,^

A rogue Shadow Rider has escaped to the year
2078.^  You must track down and capture him at
all costs, before he wreaks havoc on the fabric
of spacetime.^

-- Z^







Message finished.
Press enter to continue.
^"""

const CURSOR = "_"

var char_num = 0

func _ready():
	$Label.text += CURSOR

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to(next_scene)

func add_char():
	if char_num >= final_text.length():
		return
	var new_char = final_text[char_num]
	if new_char == "^":
		$LongBeep.play()
		$Timer.paused = true
	elif new_char == "#":
		$Label.text = ""
	else:
		$Label.text = $Label.text.rstrip(CURSOR) + new_char + CURSOR
		$Beep.play()
	char_num += 1

func _on_LongBeep_finished():
	$Timer.paused = false
