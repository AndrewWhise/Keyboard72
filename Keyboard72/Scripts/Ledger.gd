extends Position2D

# ledger 1 is below the bass clef.
# ledger 2 is middle C.
# ledger 3 is above the treble clef.

const DEFAULT_X_OFFSET: float = -32.0
const DEFAULT_WIDE_X_OFFSET: float = -16.0
const SECONDARY_NOTE_SPACING: float = 26.0
const SPACE_WIDTH: float = 21.0 # 21 pixels to next ledger line.
const LEDGER_1_MAX_LINES: int = 5
const LEDGER_3_MAX_LINES: int = 12
const LEDGER_1_REGION_HEIGHT_AT_MAX_LINES: float = 140.0
const LEDGER_3_REGION_HEIGHT_AT_MAX_LINES: float = 280.0
const LEDGER_3_POSITION_Y_AT_MAX_LINES: float = 60.0 # Also region rect pos.y


onready var ledger_1: Sprite = get_node("Ledger1")
onready var ledger_2: Sprite = get_node("Ledger2")
onready var ledger_3: Sprite = get_node("Ledger3")
onready var ledger_1_wide: Sprite = get_node("Ledger1Wide")
onready var ledger_2_wide: Sprite = get_node("Ledger2Wide")
onready var ledger_3_wide: Sprite = get_node("Ledger3Wide")

var index: int = -1

enum State {NONE, NORMAL, NORMAL_OFFSET_LEFT, NORMAL_OFFSET_RIGHT, WIDE, WIDE_OFFSET_LEFT, WIDE_OFFSET_RIGHT}
var state_1: int = State.NONE setget set_state_1
var state_2: int = State.NONE setget set_state_2
var state_3: int = State.NONE setget set_state_3

var lines_visible_1: int = 1 setget set_lines_visible_1 # max 5
# ledger 2 is only middle C, so there's no reason to have a lines_visible_2 variable here.
var lines_visible_3: int = 1 setget set_lines_visible_3 # max 12

func set_state_1(_state: int) -> void:
	#print(name, ", setting state_1 to ", _state)
	state_1 = _state
	update_sprites(ledger_1, ledger_1_wide, state_1)

func set_state_2(_state: int) -> void:
	state_2 = _state
	update_sprites(ledger_2, ledger_2_wide, state_2)
	
func set_state_3(_state: int) -> void:
	state_3 = _state
	update_sprites(ledger_3, ledger_3_wide, state_3)
	
func set_all_states_to_none() -> void:
	self.state_1 = State.NONE
	self.state_2 = State.NONE
	self.state_3 = State.NONE

func update_sprites(_ledger: Sprite, _wide_ledger: Sprite, _state: int) -> void:
	
	match _state:
		State.NONE:
			_ledger.visible = false
			_wide_ledger.visible = false
		State.NORMAL:
			_ledger.visible = true
			_wide_ledger.visible = false
			_ledger.position.x = DEFAULT_X_OFFSET
		State.NORMAL_OFFSET_LEFT:
			_ledger.visible = true
			_wide_ledger.visible = false
			_ledger.position.x = DEFAULT_X_OFFSET - SECONDARY_NOTE_SPACING
		State.NORMAL_OFFSET_RIGHT:
			_ledger.visible = true
			_wide_ledger.visible = false
			_ledger.position.x = DEFAULT_X_OFFSET + SECONDARY_NOTE_SPACING
		State.WIDE:
			_ledger.visible = false
			_wide_ledger.visible = true
			_wide_ledger.position.x = DEFAULT_WIDE_X_OFFSET
		State.WIDE_OFFSET_LEFT:
			_ledger.visible = false
			_wide_ledger.visible = true
			_wide_ledger.position.x = DEFAULT_WIDE_X_OFFSET - SECONDARY_NOTE_SPACING
		State.WIDE_OFFSET_RIGHT:
			_ledger.visible = false
			_wide_ledger.visible = true
			_wide_ledger.position.x = DEFAULT_WIDE_X_OFFSET

func set_lines_visible_1(_lines_visible_1: int) -> void:
	lines_visible_1 = _lines_visible_1
	var sprite: Sprite
	if state_1 >= State.WIDE: # wide ledger lines.
		sprite = ledger_1_wide
	else: # normal ledger lines.
		sprite = ledger_1
	var amount: float = float(LEDGER_1_MAX_LINES - lines_visible_1) * SPACE_WIDTH
	sprite.region_rect.size.y = LEDGER_1_REGION_HEIGHT_AT_MAX_LINES - amount
	
func set_lines_visible_3(_lines_visible_3: int) -> void:
	lines_visible_3 = _lines_visible_3
	var sprite: Sprite
	if state_3 >= State.WIDE: # wide ledger lines.
		sprite = ledger_3_wide
	else:
		sprite = ledger_3
	var amount: float = float(LEDGER_3_MAX_LINES - lines_visible_3) * SPACE_WIDTH
	sprite.position.y = LEDGER_3_POSITION_Y_AT_MAX_LINES + amount
	sprite.region_rect.position.y = LEDGER_3_POSITION_Y_AT_MAX_LINES + amount
	sprite.region_rect.size.y = LEDGER_3_REGION_HEIGHT_AT_MAX_LINES - amount
		
func _ready():
	set_all_states_to_none()
	pass
