extends Resource

class_name Quest

enum QuestType {
	FETCH
}

enum QuestState {
	INACTIVE,
	ACTIVE,
	COMPLETED
}

@export var id: String
@export var npc_name: String 
@export var quest_type: QuestType 
@export var state: QuestState = QuestState.INACTIVE #specific for fetch type of quest 
@export var target_item: ItemResource 
@export var target_amount: int = 0 

func get_description() -> String: 
	match quest_type: 
		QuestType.FETCH: 
			return "%s wants %d %s" % [ 
			npc_name, target_amount, target_item.item_name ] 
			#if there are other types of quests just type return and similar as above 
	return ""
