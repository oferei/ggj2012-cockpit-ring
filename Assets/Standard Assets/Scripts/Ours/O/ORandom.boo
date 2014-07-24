class ORandom: 

	static def Choice(seq as List):
	""" Returns a random element from the non-empty sequence """
		assert len(seq) > 0
		i = Random.Range(0, len(seq))
		return seq[i]
	
	static def Shuffle(seq as List):
	""" Shuffles the sequence in place """
		for i in range(len(seq) - 1):
			for j in range(i + 1, len(seq)):
				if Random.value < 0.5:
					x = seq[i]
					seq[i] = seq[j]
					seq[j] = x
