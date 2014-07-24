class MessageMouseMove(Message): 

	hitPoint:
		get:
			return _hitPoint
	_hitPoint as Vector3

	def constructor(hitPoint as Vector3):
		_hitPoint = hitPoint

		# send the message
		super()
