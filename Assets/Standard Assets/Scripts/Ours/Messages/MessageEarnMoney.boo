class MessageEarnMoney(Message): 

	playerId:
		get:
			return _playerId
	_playerId as string
	
	amount:
		get:
			return _amount
	_amount as single

	def constructor(playerId as string, amount as single):
		_playerId = playerId
		_amount = amount

		# send the message
		super()
