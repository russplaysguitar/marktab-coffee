describe "parseRiff", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "Should exist", ->
		#assert
		expect(marktab.parseRiff).toBeDefined()

	it "Should parse a single note riff", ->
		# arrange
		riff = "[1:1 1]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({1:[1, 1]})

	it "Should parse a multi-note riff", ->
		# arrange
		riff = "[1:2 6:10]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({1:[undefined,2], 6:[10]})

	it "Should parse riff with multiple same-line notes", ->
		# arrange
		riff = "[3:4 5]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({3:[4,5]})

	it "Should parse hammer-ons in same-line riff", ->
		# arrange
		riff = "[4:5 h 6]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({4:[5,'h',6]})

	it "Should parse pull-offs in same-line riff", ->
		# arrange
		riff = "[5:10 p 8]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({5:[10,'p',8]})

	it "Should parse slide-downs in same-line riff", ->
		# arrange
		riff = "[6:11 \\ 9]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({6:[11,'\\',9]})

	it "Should parse slide-ups in same-line riff", ->
		# arrange
		riff = "[2:3 / 7]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({2:[3,'/',7]})

	it "Should parse a chord in a riff", ->
		# arrange
		riff = "[(2:3 1:5)]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({1:[5], 2:[3]})

	it "Should parse a rest in a same-line riff", ->
		# arrange
		riff = "[3:5 r 7]"

		# act
		result = marktab.parseRiff riff

		# assert
		expect(result).toEqual({3:[5,undefined,7]})
