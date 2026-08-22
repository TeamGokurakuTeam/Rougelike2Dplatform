extends Node
class_name GlobalGameEvents

signal cutscene_started()
signal cutscene_ended()
signal battle_start()
signal battle_end()

signal shop_ui_opened(npc : MerchantFrog)
signal shop_ui_closed()
