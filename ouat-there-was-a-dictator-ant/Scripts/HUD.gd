extends CanvasLayer

@onready var quest_list: VBoxContainer = $ListOfQuests

#dictionary to keep track of quest name -> Label
var quest_labels: Dictionary = {}

func _ready():
	print("HUD ready")
	QuestManager.quest_added.connect(_on_quest_added)
	QuestManager.quest_completed.connect(_on_quest_completed)

	#show all active quests on ready
	for quest in QuestManager.active_quests.values():
		_on_quest_added(quest)

func _on_quest_added(quest):
	#create a new label for the quest
	var label = Label.new()
	label.text = quest.description
	quest_list.add_child(label)
	#track it in the dictionary
	quest_labels[quest.quest_type] = label

func _on_quest_completed(quest):
	#remove the label from the VBoxContainer once the quest is completed
	if quest_labels.has(quest.quest_type):
		quest_labels[quest.quest_type].queue_free()
		quest_labels.erase(quest.quest_type)
