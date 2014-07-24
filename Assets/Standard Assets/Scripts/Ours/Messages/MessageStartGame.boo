class MessageStartGame(Message):
	
	seed:
		get:
			return _seed
	_seed as int

	players:
		get:
			return _players
	_players as Hash

	def constructor(seed as int, players as Hash):
		_seed = seed
		_players = players

		# send the message
		super()
