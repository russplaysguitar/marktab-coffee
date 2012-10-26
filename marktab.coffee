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
		restPattern = /r/
		hammerPattern = /h/
		pullOffPattern = /p/
		lines = input.split("\n")
		for line in lines
			parts = line.split(" ")
			json = {}
			for part, i in parts
				jsonPart = {}
				if part.match(notePattern) 
					jsonPart = this.parseNotes(part, i)
					lastString = parseInt(_.keys(jsonPart), 10)
				else if part.match(restPattern)
					# rest
				else if part.match(hammerPattern)
					if !lastString
						throw "invalid hammer-on"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "h"
				else if part.match(pullOffPattern)
					if !lastString
						throw "invalid pull-off"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "p"
				else
					throw "unknown pattern: " + part
				this.mergeMaps(json, jsonPart)
				# console.log(json)
			this.parseJson(json)
		json

	mergeMaps: (dest, source) ->
		for stringNum, stringNotes of source
			for fret, i in stringNotes
				# if dest[stringNum] and fret?
					# throw "cannot redefine:" + stringNum + ":" + fret
				dest[stringNum] ?= []
				if fret?
					dest[stringNum][i] = fret

	cloneTabMap: (tabMap) ->
		result = {}
		for stringNum, stringNotes of tabMap
			result[stringNum] = []
			for fret, i in stringNotes
				result[stringNum][i] = fret
		result

	# parses marktab note into json
	# example: parseNotes("5:6", 2) => { 5: [undefined, 6] }
	parseNotes: (note, i = 0) ->
		result = {}
		stringAndFret = note.split(":")
		string = stringAndFret[0]
		fret = stringAndFret[1]
		result[string] ?= []
		result[string][i] = parseInt(fret, 10) 
		result

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
		result = this.cloneTabMap(json)
		max = 0
		for stringNum, stringNotes of json 
			size = _.size(stringNotes)
			max = size if size > max
		for stringNum in [1..6]
			result[stringNum] ?= []
			result[stringNum][max-1] ?= undefined if max > 0
		result

	# parses json note map into lines, which are kept at state
	parseJson: (json = {}) ->
		line = ""
		tabMap = this.normalizeJson(json)
		for stringNum in [1..6]
			notes = tabMap[stringNum]
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