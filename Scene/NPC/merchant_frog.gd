extends Character
class_name MerchantFrog

const SHOP_UI = preload("uid://ck5n0v7vducof")

@export var item_list_tables : Array[ShopItemBuyList]

@onready var shop_label: Label = $Controls/Shop
@onready var talk_label: Label = $Controls/Talk
@onready var talk_panel: Panel = $Controls/TalkPanel
@onready var rich_text_label: RichTextLabel = $Controls/TalkPanel/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var item_spawn_point: Marker2D = $ItemSpawnPoint

var is_player_inside : bool = false
var is_running : bool = false
var tween : Tween
var propetytween : PropertyTweener
var text_ratio_tween : Tween
var talk_count : int = 0
var item_table : ShopItemBuyList = null
var sold_list : Array[bool]

var texts : Array[String] = [
"誰かが迎えに来てくれるまで、
ここで商売続けるしかないんだ。
だからよ、お客さん、
ここで一つ。
買っていかないかってんだ！",
"やたらとナンが好きだなって言われんだ。
そりゃ、ナンは美味いんだ
ナンは一番美味いメシなんだ。

...カエルなのに？
別に好物は何だっていいだろ！",
"商売はぼちぼちってんだ、
仕入れ値でも損してんだ...
こんな場所で売ってるのも、
実は罪を擦り付けられたんだ。
まあ、上の階層の奴らほど...
運が悪くなくて良かったんだ...",
"昔は地上で店をやってたんだ。
今となっちゃ懐かしいんだ...
早く戻りてぇんだ...
誰か助けてケロなんだ...",
"怖いのは苦手だからよぉ、
奥の方には絶対近寄らないって
自分の中で決めてんだ。

なんでここにいるんだって？
さぁ...どうせあいつらなんだ",
"ひまなんだ。
ここに来るのに商品しか
持ってきてないから
暇つぶしもできねぇんだ。

一流の商人はそりゃ、
忙しすぎて暇つぶしなんて
できねえんだ。でも、
ケロは底辺なんだ..."
]

func _ready() -> void:
	animation_player.play("Sleeping")
	shop_label.visible = false
	talk_label.visible = false
	talk_panel.visible = false
	rich_text_label.text = ""
	if item_table == null:
		item_table = item_list_tables.pick_random()
		for i in item_table.item_list.size():
			sold_list.append(false)

func _physics_process(delta: float) -> void:
	if is_player_inside:
		if Input.is_action_just_pressed("UI_Down") and not is_running:
			visible_off()
			is_running = true
			_open_shop_ui()
			
		elif Input.is_action_just_pressed("UI_Up") and not is_running:
			visible_off()
			is_running = true
			if talk_count == 0:
				talk_panel.visible = false
				animation_player.play("Awake")
				await animation_player.animation_finished
				animation_player.play("Idle")
				talk_panel.visible = true
				await submit("君はここ初めてんだ
おいらはケロットんだ
ケロってした顔してるんだ
だからケロットって名前んだ
よろしくってんだ～", 4.0)
			elif talk_count == 10:
				talk_panel.visible = true
				await  submit("...一回しかいわないから、
よく聞いてほしいんだ。

...実はこの階には、
かつてケロ族が使っていた、
「宝剣」を隠したんだ。

言い伝えには確か...
----------------------
支配者が眠る限り、
本当の顔を見せない。

最初の部屋は、一度きりの顔を
持っているわけではないんだ。

一度で諦めた者には、
決して開かれない何かがある。
----------------------
この話はナイショなんだ...", 18.0)
			else:
				talk_panel.visible = true
				await submit(texts.pick_random(), 4.0)
			is_running = false
			talk_panel.visible = false
			visible_on()
			
			talk_count += 1

func _on_player_detector_body_entered(body: Node2D) -> void:
	shop_label.visible = true
	talk_label.visible = true
	is_player_inside = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	shop_label.visible = false
	talk_label.visible = false
	is_player_inside = false

func visible_on() -> void:
	shop_label.visible = true
	talk_label.visible = true

func visible_off() -> void:
	shop_label.visible = false
	talk_label.visible = false

func submit(text : String, scroll_second : float):
	#count += 1
	rich_text_label.visible_ratio = 0.0
	if text_ratio_tween != null:
		text_ratio_tween.kill()
	text_ratio_tween = create_tween()
	text_ratio_tween.tween_property(rich_text_label, "visible_ratio", 1.0, scroll_second + 1.0)
	rich_text_label.clear()
	rich_text_label.add_text(text)
	rich_text_label.newline()
	# これがないと一度に10行程度入力した時に最下行までスクロールしません
	rich_text_label.get_line_count()
	var bar : VScrollBar = rich_text_label.get_v_scroll_bar()
	bar.modulate = Color("ffffff00")
	await text_ratio_tween.finished
	await get_tree().create_timer(3.0).timeout

func _open_shop_ui() -> void:
	GameEvents.shop_ui_opened.emit(self)
	GameEvents.cutscene_started.emit()
	
