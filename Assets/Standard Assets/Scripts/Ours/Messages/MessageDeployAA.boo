class MessageDeployAA(Message):
	
	playerId:
		get:
			return _playerId
	_playerId as string

	def constructor(playerId as string):
		_playerId = playerId

		# send the message
		super()
