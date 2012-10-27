describe "chomp", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "should work right", ->
		# arrange
		line = "1:1 (2:2 3:3) 4:4"
		expected = "2:2 3:3"

		# act
		actual = marktab.chomp(line, 5, ')')

		# assert
		expect(actual).toBe(expected)