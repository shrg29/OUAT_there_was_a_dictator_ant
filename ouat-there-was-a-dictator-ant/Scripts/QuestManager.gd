extends Node

signal quest_added(quest: Quest)
signal quest_updated(quest: Quest)
signal quest_completed(quest: Quest)

var active_quests: Dictionary = {}

func add_quest(quest: Quest):
	if active_quests.has(quest.quest_name):
		return
	active_quests[quest.quest_name] = quest
	quest_added.emit(quest)

func progress(item: ItemResource, amount: int):
	for quest in active_quests.values():
		var before: int = quest.current_amount
		quest.add_progress(item, amount)

		if quest.is_completed and before < quest.required_amount:
			quest_completed.emit(quest)
			active_quests.erase(quest.quest_name)
		elif quest.current_amount != before:
			quest_updated.emit(quest)
