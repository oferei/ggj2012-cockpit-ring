import UnityEngine

class CopterLook (MonoBehaviour): 

	public rotationSpeed as single = 5.0
	public thresholdAngle = 0.3
	public maxTilt as single = 15
	
	_isRotating = false
	_targetRotation as Quaternion
	
	# kept for debugging only
	_target as Vector3
	_direction as Vector3
	
	def OnEnable ():
		God.Inst.Hermes.Listen(MessageMouseMove, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageMouseMove, self)
	
	def OnMsgMouseMove(msg as MessageMouseMove):
		//Debug.Log("OnMsgMouseMove (${msg})")
		# abort any old rotation
		_isRotating = false

		_target = msg.hitPoint// + Vector3.up * 4
		_direction = _target - transform.position
		
		# abort if target is exactly above/below/same place as self
		return if not _direction.x and not _direction.z
		
		# start rotation towards target
		assert _direction != Vector3.zero
		_targetRotation = Quaternion.LookRotation(_direction, Vector3.up)
		# limit X rotation
		xRotation = _targetRotation.eulerAngles.x
		if xRotation > 180: xRotation -= 360
		xRotation = Mathf.Min(Mathf.Max(xRotation, -maxTilt), maxTilt)
		_targetRotation.eulerAngles.x = xRotation
		_isRotating = true

	def Update ():
		if _isRotating:
			//Debug.Log("direction: ${_direction}")
			Debug.DrawLine(transform.position, _target, Color.green)
			Debug.DrawLine(transform.position, transform.position + _direction, Color.white)

			# check whether rotation is complete
			angle = Quaternion.Angle(transform.rotation, _targetRotation)
			if angle < thresholdAngle:
				transform.rotation = _targetRotation
				_isRotating = false
				return

			# turn towards target
			//transform.rotation = _targetRotation
			transform.rotation = Quaternion.Slerp(transform.rotation, _targetRotation, Time.deltaTime * rotationSpeed)
			
			# ensure head does not roll
			transform.eulerAngles.z = 0
			
			Debug.DrawLine(transform.position, transform.position + transform.forward * 10, Color.blue)
