describe "parseNote", ->
	it "Should exist", ->
		#assert
		expect(marktab.parseNote).toBeDefined()
	
	it "Should convert a single note to json", ->
		# arrange
		note = "1:1"

		# act
		result = marktab.parseNote note

		# assert
		expect(result).toBe({1:[1]})

	it "Should convert multiple notes to json", ->
		# arrange
		notes = "6:12 5:1 1:7"

		# act
		result = marktab.parseNote notes

		# assert
		expect(result).toBe({1:[null,null,7], 5:[null,1], 6:[12]})

	it "Should convert rest to json", ->
		# arrange
		notes = "1:1 r 1:1"

		#act
		result = marktab.parseNote notes

		#assert
		expect(result).toBe({1:[1, null, 1]})

	it "Should convert hammer-on to json", ->
		# arrange
		notes = "1:1 h 1:2"

		#act
		result = marktab.parseNote notes

		#assert
		expect(result).toBe({1:[1, 'h', 2]})		