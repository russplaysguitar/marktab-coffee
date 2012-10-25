describe "normalizeJson", ->
	marktab = undefined

	beforeEach ->
		marktab = new Marktab

	it "should exist", ->
		expect(marktab.normalizeJson).toBeDefined