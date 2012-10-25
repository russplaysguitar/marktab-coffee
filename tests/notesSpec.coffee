describe "parseNotes", ->
	it "Should exist", ->
		#assert
		expect(marktab.parseNotes).toBeDefined
	
	it "Should convert a single note to json", ->
		# arrange
		note = "1:1"

		# act
		result = marktab.parseNotes note

		# assert
		expect(result).toBe({1:[1]})

	it "Should convert multiple notes to json", ->
		# arrange
		notes = "6:12 5:1 1:7"

		# act
		result = marktab.parseNotes notes

		# assert
		expect(result).toBe({1:[null,null,7], 5:[null,1], 6:[12]})

	it "Should convert rest to json", ->
		# arrange
		notes = "1:1 r 1:1"

		#act
		result = marktab.parseNotes notes

		#assert
		expect(result).toBe({1:[1, null, 1]})

	it "Should convert hammer-on to json", ->
		# arrange
		notes = "1:1 h 1:2"

		#act
		result = marktab.parseNotes notes

		#assert
		expect(result).toBe({1:[1, 'h', 2]})		

	it "Should convert pull-off to json", ->
		# arrange
		notes = "4:10 p 4:9"

		#act
		result = marktab.parseNotes notes

		#assert
		expect(result).toBe({4:[10, 'p', 9]})		

	it "Should convert slide-up to json", ->
		# arrange
		notes = "3:10 / 3:11"

		#act
		result = marktab.parseNotes notes

		#assert
		expect(result).toBe({3:[10, '/', 11]})	

	it "Should convert slide-down to json", ->
		# arrange
		notes = "2:6 \ 2:3"

		#act
		result = marktab.parseNotes notes

		#assert
		expect(result).toBe({2:[6, '\\', 3]})
