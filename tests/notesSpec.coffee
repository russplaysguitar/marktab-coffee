describe "parseNote", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "Should exist", ->
		#assert
		expect(marktab.parseNote).toBeDefined()
	
	it "Should convert a single note to json", ->
		# arrange
		note = "1:1"

		# act
		result = marktab.parseNote note

		# assert
		expect(result).toEqual({1:[1]})

	it "Should convert multiple notes to json", ->
		# arrange
		notes = "6:12 5:1 1:7"

		# act
		result = marktab.parse notes

		# assert
		expect(result).toEqual({1:[undefined,undefined,7], 5:[undefined,1], 6:[12]})

	it "Should convert rest to json", ->
		# arrange
		notes = "1:1 r 1:1"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({1:[1, undefined, 1]})

	it "Should convert hammer-on to json", ->
		# arrange
		notes = "1:1 h 1:2"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({1:[1, 'h', 2]})		

	it "Should convert pull-off to json", ->
		# arrange
		notes = "4:10 p 4:9"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({4:[10, 'p', 9]})		

	it "Should convert slide-up to json", ->
		# arrange
		notes = "3:10 / 3:11"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({3:[10, '/', 11]})	

	it "Should convert slide-down to json", ->
		# arrange
		notes = "2:6 \\ 2:3"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({2:[6, '\\', 3]})

	it "Should convert mute to json", ->
		# arrange
		notes = "1:x"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({1:['x']})

	it "Should convert mute to json v2", ->
		# arrange
		notes = "2:0 x"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({2:[0, 'x']})

	it "Should convert bend to json", ->
		# arrange
		notes = "1:2 b 3"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({1:[2, 'b', 3]})

	it "Should convert harmonic to json", ->
		# arrange
		notes = "3:12*"

		#act
		result = marktab.parse notes

		#assert
		expect(result).toEqual({3:[12, '*']})
