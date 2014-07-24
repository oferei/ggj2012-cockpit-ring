import UnityEngine

class RingMove (MonoBehaviour): 

	public angularSpeed as single = 5.0
	
	_centerOnMyLevel as Vector3
	_isMoving as bool = false

	def Start():
		_centerOnMyLevel = God.Inst.Core.position
		_centerOnMyLevel.y = transform.position.y
	
	def Update ():
		if _isMoving:
			meFromCenter = transform.position - _centerOnMyLevel
			rotation = Quaternion.AngleAxis(angularSpeed * Time.deltaTime, Vector3.up)
			transform.rotation *= rotation
			meFromCenter = rotation * meFromCenter
			transform.position = _centerOnMyLevel + meFromCenter
	
	def StartMoving():
		_isMoving = true
	
	def StopMoving():
		_isMoving = false
