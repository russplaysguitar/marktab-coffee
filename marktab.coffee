class Marktab
	stringDefaults = 
		1: "e"
		2: "B"
		3: "G"
		4: "D"
		5: "A"
		6: "E"

	constructor: (@lines = []) ->
		# @lines contains an array of parsed lines, ready to be output
		this

	# top-level parser. delegates to other parse functions.
	parse: (input) ->
		notePattern = /[0-9]:[0-9]/
		if notePattern.test(input) 
			this.parseJson(this.parseNotes(input))
		@lines

	# parses marktab notes into json
	parseNotes: (notesLine) ->
		json = {}
		notes = notesLine.split(" ")
		for note, i in notes
			stringAndFret = note.split(":")
			string = stringAndFret[0]
			fret = stringAndFret[1]
			json[string] ?= []
			json[string][i] = parseInt(fret, 10) 
		json

	# parses marktab chords into json
	parseChord: (chord) ->
		""

	# parses marktab riffs into json
	parseRiff: (riff) ->
		""

	# parses marktab variables into json
	parseVariable: (variable) ->
		""

	# makes each string's notes array the same length
	normalizeJson: (json = {}) ->
		max = 0
		for stringNum, stringNotes of json 
			size = _.size(stringNotes)
			max = size if size > max
		for stringNum in [1..6]
			json[stringNum] ?= []
			json[stringNum][max-1] ?= undefined if max > 0
		json

	# parses json note map into lines, which are kept at state
	parseJson: (json = {}) ->
		line = ""
		this.normalizeJson(json)
		for stringNum in [1..6]
			notes = json[stringNum]
			line = stringDefaults[stringNum] + "|-"
			for note in notes
				line += (note || '-') + "-"
			line += "|"
			@lines.push(line)
		@lines

	# simply returns @lines concatenated into a string with newlines (\n)
	generateTab: ->
		result = ""
		for line in @lines
			result += line + "\n"
		result

window.Marktab = Marktab