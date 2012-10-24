describe "parseRiff", ->
	it "Should exist", ->
		#assert
		expect(marktab.parseRiff).toBeDefined()

	it "Should parse a single note riff", ->
		# arrange
		riff = "[1:1]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toBe({1:[1]})

	it "Should parse a multi-note riff", ->
		# arrange
		riff = "[1:2 6:10]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toBe({1:[null,2], 6:[10]})

	it "Should parse riff with multiple same-line notes", ->
		# arrange
		riff = "[3:4 5]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toBe({3:[4,5]})

	it "Should parse hammer-ons in same-line riff", ->
		# arrange
		riff = "[4:5 h 6]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toBe({4:[5,'h',6]})

	