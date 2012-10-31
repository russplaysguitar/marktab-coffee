describe "constructor", ->
	it "should get constructed with new", ->
		# act
		marktab = new Marktab

		# assert
		expect(marktab).toBeDefined()