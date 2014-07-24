import UnityEngine

class CameraFollow (MonoBehaviour): 

	_origPosition as Vector3
	_origRotation as Quaternion
	public target as Transform
	_relPosition = Vector3.zero
	
	def Awake():
		_origPosition = transform.position
		_origRotation = transform.rotation

	def Update ():
		if target:
			LearnPosition()
			transform.position = target.transform.position + _relPosition
	
	def LearnPosition():
		if _relPosition == Vector3.zero:
			_relPosition = transform.position - target.transform.position

	def Reset():
		transform.position = _origPosition
		transform.rotation = _origRotation
		_relPosition = Vector3.zero
