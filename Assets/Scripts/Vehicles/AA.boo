import UnityEngine

class AA (MonoBehaviour): 

	_moveScript as RingMove
	_fireScript as AAFire

	def Awake ():
		_moveScript = GetComponent(RingMove)
		assert _moveScript
		_fireScript = GetComponent(AAFire)
		assert _fireScript
	
	def Start ():
		_moveScript.StartMoving()
	
	def _OnTriggerEnter (other as Collider):
		// prevent friendly fire
		return if CommObj.AreFriendly(transform, other.transform)
		
		_moveScript.StopMoving()
		_fireScript.Fire(other.transform)
