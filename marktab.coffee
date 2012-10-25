class Marktab
	stringDefaults = 
		1: "e"
		2: "B"
		3: "G"
		4: "D"
		5: "A"
		6: "E"

	constructor: (@json = {}) ->
		for key, val of stringDefaults
			@json[key] ?= []
		this

	# parses marktab notes into json
	parseNotes: (notes) ->
		""

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
			json[stringNum][max-1] ?= undefined		
		json

	# generates tab from a json note map
	generate: (json = @json) ->
		result = ""
		this.normalizeJson(json)
		for stringNum in [1..6]
			notes = json[stringNum]
			result += stringDefaults[stringNum] + "|-"
			for note in notes
				result += (note || '-') + "-"
			result += "|\n"
		result

window.Marktab = Marktab