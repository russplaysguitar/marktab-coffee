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

	parseNotes: (notes) ->
		""

	parseChord: (chord) ->
		""

	parseRiff: (riff) ->
		""

	parseVariable: (variable) ->
		""

	generate: ->
		result = ""
		for key, val of @json
			result += stringDefaults[key] + "|-"
			for note in val
				result += note + "-"
			result += "|\n"
		result

window.Marktab = Marktab