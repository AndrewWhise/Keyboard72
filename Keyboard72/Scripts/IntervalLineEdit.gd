extends LineEdit

class_name IntervalLineEdit

const SEVENTY_TWO_INT: int = 72

var is_initializing: bool = true
var forcing_control_value: bool = false


enum IntervalFormat {TWELFTH_STEPS, TWELFTH_STEPS_ABSOLUTE, DOTS, DOTS_ABSOLUTE,\
	FREQUENCY, FREQUENCY_W_HZ, FREQUENCY_ABSOLUTE, FREQUENCY_W_HZ_ABSOLUTE,\
	RATIO, RATIO_ABSOLUTE}
export (IntervalFormat) var format: int = IntervalFormat.TWELFTH_STEPS setget set_format
export (bool) var absolute: bool = false setget set_absolute

export(bool) var change_format_from_input: bool = true # If true, when user types an interval
# that's in a different format, format will be updated to the new format. If false,
# when user types an interval that's in a different format, the text is updated to our set format.

var pitch_a: Pitch = Pitch.new()
var pitch_b: Pitch = Pitch.new()
var interval: Interval = Interval.new()

signal text_changed_2(_line_edit, _new_text) # 2 because text_changed is a built-in signal used for other purposes.
signal format_changed(_line_edit, _new_format)

func set_format(_format: int) -> void:
	var old: int = format
	format = _format
	forcing_control_value = true
	match format:
		IntervalFormat.TWELFTH_STEPS:
			var ts: int = interval.sevtwo
			if pitch_a.sevtwo_note_num > pitch_b.sevtwo_note_num:
				ts *= -1
				assert(ts <= 0)
			text = str(ts)
		IntervalFormat.TWELFTH_STEPS_ABSOLUTE:
			text = str(abs(interval.sevtwo))
		IntervalFormat.DOTS:
			var ts: int = interval.sevtwo
			if pitch_a.sevtwo_note_num > pitch_b.sevtwo_note_num:
				ts *= -1
				assert(ts <= 0)
			text = twelfth_steps_to_dot_format(ts)
		IntervalFormat.DOTS_ABSOLUTE:
			text = twelfth_steps_to_dot_format(interval.sevtwo)
		IntervalFormat.FREQUENCY:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f" % diff
		IntervalFormat.FREQUENCY_ABSOLUTE:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f" % abs(diff)
		IntervalFormat.FREQUENCY_W_HZ:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f Hz" % diff
		IntervalFormat.FREQUENCY_W_HZ_ABSOLUTE:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f Hz" % abs(diff)
		IntervalFormat.RATIO:
			text = str(interval.ratio_n)+"/"+str(interval.ratio_d)
		IntervalFormat.RATIO_ABSOLUTE:
			if interval.ratio_n < interval.ratio_d:
				text = str(interval.ratio_d)+"/"+str(interval.ratio_n)
			else:
				text = str(interval.ratio_n)+"/"+str(interval.ratio_d)
	forcing_control_value = false
	if format != old:
		emit_signal("format_changed", self, format)

func set_absolute(_absolute: bool) -> void:
	absolute = _absolute
	# Setter of format will update text.
	if absolute:
		match format: # old format to new format
			IntervalFormat.DOTS:
				self.format = IntervalFormat.DOTS_ABSOLUTE
			IntervalFormat.TWELFTH_STEPS:
				self.format = IntervalFormat.TWELFTH_STEPS_ABSOLUTE
			IntervalFormat.FREQUENCY:
				self.format = IntervalFormat.FREQUENCY_ABSOLUTE
			IntervalFormat.FREQUENCY_W_HZ:
				self.format = IntervalFormat.FREQUENCY_W_HZ_ABSOLUTE
			IntervalFormat.RATIO:
				self.format = IntervalFormat.RATIO_ABSOLUTE
			_:
				self.format = format
	else:
		match format: # old format to new format
			IntervalFormat.DOTS_ABSOLUTE:
				self.format = IntervalFormat.DOTS
			IntervalFormat.TWELFTH_STEPS_ABSOLUTE:
				self.format = IntervalFormat.TWELFTH_STEPS
			IntervalFormat.FREQUENCY_ABSOLUTE:
				self.format = IntervalFormat.FREQUENCY
			IntervalFormat.FREQUENCY_W_HZ_ABSOLUTE:
				self.format = IntervalFormat.FREQUENCY_W_HZ
			IntervalFormat.RATIO_ABSOLUTE:
				self.format = IntervalFormat.RATIO
			_:
				self.format = format

func initialize_tooltip() -> void:
	hint_tooltip =\
		"x     --> twelfth-steps"\
		+"\nx.y   --> frequency difference"\
		+"\nx:y   --> frequency ratio"\
		+"\nx/y   --> frequency ratio"\
		+"\nx.y.z --> octaves.half-steps.twelfth-steps"\

func _ready():
	is_initializing = false
	# Initialize to an octave.
	pitch_b.sevtwo_note_num = pitch_a.sevtwo_note_num + SEVENTY_TWO_INT
	interval.pitch_a = pitch_a
	interval.pitch_b = pitch_b
	self.absolute = absolute
	initialize_tooltip()
	
	
func parse_interval_string(_s: String) -> int:
	# Returns the interval format _s is in.
	if _s.empty():
		return 0
	var splits: PoolStringArray = _s.split(".", false)
#	print("splits: ", splits)
	var twelfth_steps: int
	var has_neg_sign: bool = _s.find("-") != -1
#	print("has_neg_sign: ", has_neg_sign)
	if splits.size() == 0:
		twelfth_steps = 0
		pitch_b.freq = pitch_a.freq # unison
		return format # Keep same format
	elif splits.size() == 1:
		var has_slash: bool = _s.find("/") != -1
		var has_colon: bool = _s.find(":") != -1
		if has_slash || has_colon:
			# ratio
			var n: int
			var d: int
			if has_slash:
				var split: PoolStringArray = _s.split("/")
				n = abs(int(split[0]))
				d = abs(int(split[1]))
			else:
				var split: PoolStringArray = _s.split(":")
				n = abs(int(split[0]))
				d = abs(int(split[1]))
			n = max(n, 1)
			d = max(d, 1) # No division by 0.
			if d > interval.max_denominator: # Get closest approx using max_denominator.
				var less_than_1_f: float
				if n < d:
					less_than_1_f = float(n) / float(d)
				else:
					less_than_1_f = float(d) / float(n) 
				var new_less_than_1_ratio: Array = interval.farey(less_than_1_f, interval.max_denominator)
				if n < d:
					n = new_less_than_1_ratio[0]
					d = new_less_than_1_ratio[1]
				else:
					n = new_less_than_1_ratio[1]
					d = new_less_than_1_ratio[0]
			interval.ratio_n = n
			interval.ratio_d = d
			
			var less_than_1: bool = n < d
			if not absolute && not less_than_1:
				return IntervalFormat.RATIO
			elif not absolute && less_than_1:
				return IntervalFormat.RATIO
			elif absolute && not less_than_1:
				return IntervalFormat.RATIO_ABSOLUTE
			elif absolute && less_than_1:
				return IntervalFormat.RATIO
		else: 
			# 12th-step format.
			twelfth_steps = int(_s)
#			print("twelfth_steps: ", twelfth_steps, ", absolute: ", absolute)
			pitch_b.sevtwo_note_num = pitch_a.sevtwo_note_num + twelfth_steps
				
			
			
			if not absolute && not has_neg_sign:
				return IntervalFormat.TWELFTH_STEPS
			elif not absolute && has_neg_sign:
				return IntervalFormat.TWELFTH_STEPS
			elif absolute && not has_neg_sign:
				return IntervalFormat.TWELFTH_STEPS_ABSOLUTE
			elif absolute && has_neg_sign:
				return IntervalFormat.TWELFTH_STEPS
	elif splits.size() == 2:
		# frequency format.
		var freq: float = float(_s)
		pitch_b.freq = pitch_a.freq + freq
		twelfth_steps = interval.sevtwo
		if has_neg_sign:
			twelfth_steps *= -1
		pitch_b.sevtwo_note_num = pitch_a.sevtwo_note_num + twelfth_steps
		var has_hz: bool = _s.to_lower().find("hz") != -1
		if not has_hz && not absolute && not has_neg_sign:
			return IntervalFormat.FREQUENCY
		elif not has_hz && not absolute && has_neg_sign:
			return IntervalFormat.FREQUENCY
		elif not has_hz && absolute && not has_neg_sign:
			return IntervalFormat.FREQUENCY_ABSOLUTE
		elif not has_hz && absolute && has_neg_sign:
			return IntervalFormat.FREQUENCY
		elif has_hz && not absolute && not has_neg_sign:
			return IntervalFormat.FREQUENCY_W_HZ
		elif has_hz && not absolute && has_neg_sign:
			return IntervalFormat.FREQUENCY_W_HZ
		elif has_hz && absolute && not has_neg_sign:
			return IntervalFormat.FREQUENCY_W_HZ_ABSOLUTE
		elif has_hz && absolute && has_neg_sign:
			return IntervalFormat.FREQUENCY_W_HZ
	elif splits.size() == 3:
		# Dot format
		var oct: int = abs(int(splits[0]))
		var hs: int = abs(int(splits[1]))
		var ts: int = abs(int(splits[2]))
		twelfth_steps = (oct * SEVENTY_TWO_INT) + (hs * 6) + ts
		if has_neg_sign:
			twelfth_steps *= -1
		pitch_b.sevtwo_note_num = pitch_a.sevtwo_note_num + twelfth_steps
		if not absolute && not has_neg_sign:
			return IntervalFormat.DOTS
		elif not absolute && has_neg_sign:
			return IntervalFormat.DOTS
		elif absolute && not has_neg_sign:
			return IntervalFormat.DOTS_ABSOLUTE
		elif absolute && has_neg_sign:
			return IntervalFormat.DOTS
	return 0


static func twelfth_steps_to_dot_format(_twelfth_steps: int) -> String:
	var abs_ts: int = abs(_twelfth_steps)
	var octs: int = floor(float(abs_ts) / 72.0)
	var rem: int = abs_ts % SEVENTY_TWO_INT
	var hs: int = floor(float(rem) / 6.0)
	rem = rem % 6
	var s: String
	if _twelfth_steps < 0:
		s = "-"
	s += str(octs) + "." + str(hs) + "." + str(rem)
	return s

func _on_IntervalLineEdit_text_entered(_new_text: String) -> void:
	if forcing_control_value:
		return
	var entered_format: int = parse_interval_string(_new_text)
	print("entered_format: ", entered_format, ", interval.pitch_a: ", interval.pitch_a.title, ", interval.pitch_b: ", interval.pitch_b.title)
	if change_format_from_input:
		self.format = entered_format # Setter will update text.
	else:
		self.format = format # Setter will update text.
	emit_signal("text_changed_2", self, text)
	release_focus()
	
func force_update_text() -> void:
	# Emits no signals.
	forcing_control_value = true
	match format:
		IntervalFormat.TWELFTH_STEPS:
			var ts: int = interval.sevtwo
			if pitch_a.sevtwo_note_num > pitch_b.sevtwo_note_num:
				ts *= -1
				assert(ts <= 0)
			text = str(ts)
		IntervalFormat.TWELFTH_STEPS_ABSOLUTE:
			text = str(abs(interval.sevtwo))
		IntervalFormat.DOTS:
			var ts: int = interval.sevtwo
			if pitch_a.sevtwo_note_num > pitch_b.sevtwo_note_num:
				ts *= -1
				assert(ts <= 0)
			text = twelfth_steps_to_dot_format(ts)
		IntervalFormat.DOTS_ABSOLUTE:
			text = twelfth_steps_to_dot_format(interval.sevtwo)
		IntervalFormat.FREQUENCY:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f" % diff
		IntervalFormat.FREQUENCY_ABSOLUTE:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f" % abs(diff)
		IntervalFormat.FREQUENCY_W_HZ:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f Hz" % diff
		IntervalFormat.FREQUENCY_W_HZ_ABSOLUTE:
			var diff: float = pitch_b.freq - pitch_a.freq
			text = "%.3f Hz" % abs(diff)
		IntervalFormat.RATIO:
			text = str(interval.ratio_n)+"/"+str(interval.ratio_d)
		IntervalFormat.RATIO_ABSOLUTE:
			if interval.ratio_n < interval.ratio_d:
				text = str(interval.ratio_d)+"/"+str(interval.ratio_n)
			else:
				text = str(interval.ratio_n)+"/"+str(interval.ratio_d)
	forcing_control_value = false
	
