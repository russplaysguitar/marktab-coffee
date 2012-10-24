Idea: implement marktab in coffeescript using TDD

Implementation:
Convert marktab to json in this format:

{
	1:[],
	2:[],
	3:[],
	4:[],
	5:[],
	6:[]
}

Where the arrays contain the notes for that string in order, with nulls representing non-note spaces.