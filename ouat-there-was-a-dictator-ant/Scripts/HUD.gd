extends CanvasLayer 

@onready var quest_label: Label = $ListOfQuests/QuestLabel

func _ready():
	print("HUD ready")
	QuestManager.quest_added.connect(_on_quest_added)
	QuestManager.quest_completed.connect(_on_quest_completed)
	
	for quest in QuestManager.active_quests.values():
		_on_quest_added(quest)

func _on_quest_added(quest):
	#Show a single sentence: quest name or description
	#print("HUD received quest:", quest.quest_name)
	quest_label.text = quest.description

func _on_quest_completed(quest):
	# Clear the label once quest is completed
	quest_label.text = ""
