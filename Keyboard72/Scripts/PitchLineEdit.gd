extends LineEdit

class_name PitchLineEdit

var is_initializing: bool = true




# AC means apostrophes or commas. "D4''" means D4 up 2 ranks,
# while "D4,," means D4 down 2 ranks. "D4" by itself means D4 + 0 cents.
# "D4=" also means D4 + 0 cents, but it will automatically be formated to "D4".

enum PitchFormat {NOTE_NUMBER, PITCH_CLASS_NUMBER, NOTE_NAME, NOTE_NAME_NO_OCTAVE,\
	NOTE_NAME_AC, NOTE_NAME_AC_NO_OCTAVE,\
	FREQUENCY, FREQUENCY_W_HZ}
export(PitchFormat) var format: int = PitchFormat.NOTE_NUMBER setget set_format
export(bool) var change_format_from_input: bool = true # If true, when user types a pitch
# that's in a different format, format will be updated to the new format. If false,
# when user types a pitch that's in a different format, the text is updated to our set format.
var pitch_format_only: bool = false setget set_pitch_format_only # If true, "pitch class" formats-- those without octaves-- aren't allowed.
var pitch_class_format_only: bool = false setget set_pitch_class_format_only # If true, "pitch" formats-- those with octaves-- aren't allowed.
var has_octave: bool = true setget set_has_octave # If true, this is a pitch. If false, this is a pitch class.

var pitch: Pitch = Pitch.new()
export (bool) var middle_c_is_c4: bool = false setget set_middle_c_is_c4
var forcing_control_value: bool = false


signal format_changed(_pitch_line_edit, _new_format)
signal pitch_changed(_pitch_line_edit)
signal text_entered_2(_pitch_line_edit, _new_text) # 2 because text_changed is a built-in signal used for other purposes.


func set_pitch_format_only(_pitch_format_only: bool) -> void:
	pitch_format_only = _pitch_format_only
	if pitch_format_only:
		pitch_class_format_only = false
	self.format = format # This setter will set has_octave to true
	assert(has_octave)
	
func set_pitch_class_format_only(_pitch_class_format_only: bool) -> void:
	pitch_class_format_only = _pitch_class_format_only
	if pitch_class_format_only:
		pitch_format_only = false
	self.format = format # This setter will set has_octave to false
	assert(not has_octave)

func set_has_octave(_has_octave: bool) -> void:
	if is_initializing:
		has_octave = _has_octave
		return
	var old_format: int = format
	var had_octave: bool = has_octave
	has_octave = _has_octave
	if pitch_format_only:
		has_octave = true
	elif pitch_class_format_only:
		has_octave = false
	if had_octave && not has_octave:
		match format:
			PitchFormat.NOTE_NUMBER:
				self.format = PitchFormat.PITCH_CLASS_NUMBER
			PitchFormat.NOTE_NAME:
				self.format = PitchFormat.NOTE_NAME_NO_OCTAVE
			PitchFormat.NOTE_NAME_AC:
				self.format = PitchFormat.NOTE_NAME_AC_NO_OCTAVE
			PitchFormat.FREQUENCY:
				self.format = PitchFormat.PITCH_CLASS_NUMBER
			PitchFormat.FREQUENCY_W_HZ:
				self.format = PitchFormat.PITCH_CLASS_NUMBER
	elif not had_octave && has_octave:
		match format:
			PitchFormat.PITCH_CLASS_NUMBER:
				self.format = PitchFormat.NOTE_NUMBER
			PitchFormat.NOTE_NAME_NO_OCTAVE:
				self.format = PitchFormat.NOTE_NAME
			PitchFormat.NOTE_NAME_AC_NO_OCTAVE:
				self.format = PitchFormat.NOTE_NAME_AC


func set_format(_format: int) -> void:
	var old_format: int = format
	format = _format
	if is_initializing:
		return
	if format == old_format:
		return
	if pitch_format_only:
		match format:
			PitchFormat.NOTE_NAME_NO_OCTAVE:
				format = PitchFormat.NOTE_NAME
			PitchFormat.NOTE_NAME_AC_NO_OCTAVE:
				format = PitchFormat.NOTE_NAME_AC
			PitchFormat.PITCH_CLASS_NUMBER:
				format = PitchFormat.NOTE_NUMBER
	elif pitch_class_format_only:
		match format:
			PitchFormat.NOTE_NAME:
				format = PitchFormat.NOTE_NAME_NO_OCTAVE
			PitchFormat.NOTE_NAME_AC:
				format = PitchFormat.NOTE_NAME_AC_NO_OCTAVE
			PitchFormat.PITCH_CLASS_NUMBER:
				format = PitchFormat.NOTE_NUMBER
			PitchFormat.FREQUENCY:
				format = PitchFormat.NOTE_NUMBER
			PitchFormat.FREQUENCY_W_HZ:
				format = PitchFormat.NOTE_NUMBER
	forcing_control_value = true
	match format:
		PitchFormat.NOTE_NUMBER:
			self.text = str(pitch.sevtwo_note_num)
			has_octave = true
		PitchFormat.PITCH_CLASS_NUMBER:
			self.text = str(pitch.sevtwo_pitch_class)
			has_octave = false
		PitchFormat.NOTE_NAME:
			if not middle_c_is_c4:
				self.text = pitch.title
			else:
				self.text = pitch.title_c4
			has_octave = true
		PitchFormat.NOTE_NAME_NO_OCTAVE:
			self.text = pitch.as_string(false)
			has_octave = false
		PitchFormat.NOTE_NAME_AC:
			self.text = pitch.get_title_ac(true, middle_c_is_c4)
			has_octave = true
		PitchFormat.NOTE_NAME_AC_NO_OCTAVE:
			self.text = pitch.get_title_ac(false, middle_c_is_c4)
			has_octave = false

		PitchFormat.FREQUENCY:
			self.text = "%.3f" % pitch.freq
			has_octave = true
		PitchFormat.FREQUENCY_W_HZ:
			self.text = pitch.get_freq_string()
			has_octave = true
	forcing_control_value = false
	if format != old_format:
		emit_signal("format_changed", self, format)
	
func set_middle_c_is_c4(_middle_c_is_c4: bool) -> void:
	middle_c_is_c4 = _middle_c_is_c4
	if is_initializing:
		return
	self.format = format # Setter will update the string with new octave.
	


func parse_pitch_string(_s: String, _round_to_72: bool = true) -> int:
	_s = _s.strip_escapes().strip_edges()
	if _s.empty():
		if not has_octave:
			pitch.sevtwo_note_num = Pitch.MIDDLE_C_SEVTWO_NOTE_NUM # Default to Middle C.
			return PitchFormat.NOTE_NUMBER
		else:
			pitch.sevtwo_pitch_class = 0
			return PitchFormat.PITCH_CLASS_NUMBER
		
	for note_name_str in Pitch.VALID_NOTE_NAMES:
		if _s.find(note_name_str) != -1:
			# Note name.
			var found_pitch_components: Array
			if (format == PitchFormat.NOTE_NAME_AC || format == PitchFormat.NOTE_NAME_AC_NO_OCTAVE)\
				&& _s.find("'") == -1 && _s.find(",") == -1:
				_s += "="
			if not middle_c_is_c4:
				found_pitch_components = pitch.set_title(_s, false, true)
			else:
				found_pitch_components = pitch.set_title_c4(_s, true)
			if _round_to_72:
				pitch.sevtwo_note_num = pitch.sevtwo_note_num
			var had_note_name: bool = found_pitch_components[0]
			var had_oct: bool = found_pitch_components[1]
			var had_ac: bool = found_pitch_components[2]
			assert(had_note_name)
			if not had_oct && not had_ac:
				return PitchFormat.NOTE_NAME_NO_OCTAVE
			elif not had_oct && had_ac:
				return PitchFormat.NOTE_NAME_AC_NO_OCTAVE
			elif had_oct && not had_ac:
				return PitchFormat.NOTE_NAME
			elif had_oct && had_ac:
				return PitchFormat.NOTE_NAME_AC
	if _s.find(".") != -1: # String has decimal number but no note name.
		# Must be a frequency.
		pitch.freq = float(_s)
		if _round_to_72:
			pitch.sevtwo_note_num = pitch.sevtwo_note_num
		if _s.to_lower().find("hz") != -1:
			return PitchFormat.FREQUENCY_W_HZ
		else:
			return PitchFormat.FREQUENCY
	# Got here? Must be a note number or a pitch class
	if not has_octave:
		pitch.sevtwo_pitch_class = int(_s)
		return PitchFormat.PITCH_CLASS_NUMBER
	pitch.sevtwo_note_num = int(_s)
	return PitchFormat.NOTE_NUMBER

func _on_PitchLineEdit_text_entered(_new_text: String) -> void:
	if forcing_control_value:
		return
	var old_pitch_note_num: int = pitch.sevtwo_note_num
	var entered_format: int = parse_pitch_string(_new_text, true)
	if change_format_from_input:
		self.format = entered_format # setter will update has_octave
		if pitch.sevtwo_note_num != old_pitch_note_num:
			emit_signal("pitch_changed", self)
	else: # Don't change the format.
		if pitch.sevtwo_note_num != old_pitch_note_num:
			# The pitch changed.
			self.format = format
			emit_signal("pitch_changed", self)
	emit_signal("text_entered_2", self, text)
	release_focus()



func force_update_text() -> void:
	# Does NOT send any signals.
	forcing_control_value = true
	match format:
		PitchFormat.NOTE_NAME:
			if not middle_c_is_c4:
				text = pitch.title
			else:
				text = pitch.get_title_c4()
		PitchFormat.NOTE_NAME_NO_OCTAVE:
			text = pitch.as_string(false)
		PitchFormat.NOTE_NAME_AC:
			text = pitch.get_title_ac(true, middle_c_is_c4)
		PitchFormat.NOTE_NAME_AC_NO_OCTAVE:
			text = pitch.get_title_ac(false)
		PitchFormat.PITCH_CLASS_NUMBER:
			text = str(pitch.sevtwo_pitch_class)
		PitchFormat.NOTE_NUMBER:
			text = str(pitch.sevtwo_note_num)
		PitchFormat.FREQUENCY:
			text = "%.3f" % pitch.freq
		PitchFormat.FREQUENCY_W_HZ:
			text = pitch.get_freq_string()
	forcing_control_value = false

func _ready():
	is_initializing = false
	connect("text_entered", self, "_on_PitchLineEdit_text_entered")

