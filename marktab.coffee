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
		slideUpPattern = /\//
		slideDownPattern = /\\/
		chordPattern = /\(([0-9]:[0-9])+\)/
		lines = input.split("\n")
		for line in lines
			parts = line.split(" ")
			json = {}
			for part, i in parts
				jsonPart = {}
				if part.match(notePattern) 
					# note
					jsonPart = this.parseNotes(part)
					lastString = parseInt(_.keys(jsonPart), 10)
				else if part.match(restPattern)
					# rest
					jsonPart = {1: [undefined]}
				else if part.match(hammerPattern)
					# hammer-on
					if !lastString
						throw "invalid hammer-on"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "h"
				else if part.match(pullOffPattern)
					# pull-off
					if !lastString
						throw "invalid pull-off"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "p"
				else if part.match(slideUpPattern)
					# slide-up
					if !lastString
						throw "invalid slide-up"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "/"
				else if part.match(slideDownPattern)
					# slide-down
					if !lastString
						throw "invalid slide-down"
					jsonPart[lastString] = []
					jsonPart[lastString][i] = "\\"
				else if part.match(chordPattern)
					# chord
					jsonPart = this.parseChord(part)
				else
					throw "unknown pattern: " + part
				this.addFrame(json, jsonPart)
			this.parseJson(json)
		json

	# adds another frame to a tabMap
	addFrame: (json, frame) ->
		idx = this.longestString(json)
		for stringNum, stringNotes of frame
			for fret, i in stringNotes
				json[stringNum] ?= []
				json[stringNum][idx] = fret
		json

	longestString: (tabMap = {}) ->
		max = 0
		for stringNum, stringNotes of tabMap
			size = _.size(stringNotes)
			max = size if size > max
		max
	
	# merges two tabMaps together, with the source overwriting the destination
	mergeMaps: (dest, source) ->
		for stringNum, stringNotes of source
			for fret, i in stringNotes
				# if dest[stringNum] and fret?
					# throw "cannot redefine:" + stringNum + ":" + fret
				dest[stringNum] ?= []
				if fret?
					dest[stringNum][i] = fret

	# returns a new tabMap
	cloneTabMap: (tabMap) ->
		result = {}
		for stringNum, stringNotes of tabMap
			result[stringNum] = []
			for fret, i in stringNotes
				result[stringNum][i] = fret
		result

	# parses marktab note into json
	# example: parseNotes("5:6", 2) => { 5: [undefined, 6] }
	parseNotes: (note) ->
		result = {}
		stringAndFret = note.split(":")
		string = stringAndFret[0]
		fret = stringAndFret[1]
		result[string] ?= []
		result[string][0] = parseInt(fret, 10) 
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
		max = this.longestString(json)
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
				line += (note || '-')
				if note < 10 || !note
					line += "-" 
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