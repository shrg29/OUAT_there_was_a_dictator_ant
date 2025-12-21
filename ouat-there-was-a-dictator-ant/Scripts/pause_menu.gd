extends Control

func _ready():
	grab_focus()
	visible = false

func resume():
	get_tree().paused = false
	visible = false
	
func pause():
	visible = true
	get_tree().paused = true
	
func testEsc():
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()
		
func _on_resume_pressed():
	print("resuming")
	resume()

func _on_restart_pressed():
	print("restarting")
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
	
func _process(delta):
	testEsc()
