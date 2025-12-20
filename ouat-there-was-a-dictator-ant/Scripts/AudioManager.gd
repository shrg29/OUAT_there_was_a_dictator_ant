extends Node

@onready var music_player = $Music
@onready var sfx_player = $SFX
@onready var dialogue_player = $Dialogue

#we create dictionaries with keys and values so we can manually drag and drop 
#mp3 files and their key names can be edited in the inspector
@export var music_tracks: Dictionary[String, AudioStream]
@export var sfx: Dictionary[String, AudioStream]
@export var dialogues: Dictionary[String, AudioStream]

#function that is called when you want to play background music
#currently called in main scene script 
func play_music(name: String):
	if not music_tracks.has(name):
		push_warning("womp womp music doesn't exist " + name)
		return
	music_player.stream = music_tracks[name]
	music_player.play()

func stop_music():
	music_player.stop()

#same thing for the sound effects
#just call the function and type the name of the sfx you need, e.g. "walking"
func play_sfx(name: String):
	if not sfx.has(name):
		push_warning("sound effect you tryna call doesn't exist " + name)
		return
	sfx_player.stream = sfx[name]
	sfx_player.play()
