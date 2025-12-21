extends Node

signal quest_added(quest: Quest)
signal quest_completed(quest: Quest)

var active_quests: Dictionary = {}

#basically marking quest as active
func add_quest(quest: Quest):
	if active_quests.has(quest.quest_type):
		return
	active_quests[quest.quest_type] = quest
	quest_added.emit(quest)
			
#removing them once they're completed 
func remove_quest(quest: Quest):
	if active_quests.has(quest.quest_type):
		active_quests.erase(quest.quest_type)
		quest_completed.emit(quest)  #this tells HUD to remove it
