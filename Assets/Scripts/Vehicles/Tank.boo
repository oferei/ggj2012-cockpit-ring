import UnityEngine

class Tank (MonoBehaviour): 

	_moveScript as RingMove
	_fireScript as TankFire
	
	def Awake ():
		_moveScript = GetComponent(RingMove)
		assert _moveScript
		_fireScript = GetComponent(TankFire)
		assert _fireScript
	
	def Update ():
		if not _fireScript.Target:
			_moveScript.StartMoving()
		//else:
			//Debug.Log("Shooting at ${_fireScript.Target.gameObject.name}")
	
	def _OnTriggerStay (other as Collider):
		// ignore other triggers
		if other.isTrigger:
			return
		
		// prevent friendly fire
		return if CommObj.AreFriendly(transform, other.transform)
		
		if not _fireScript.Target:
			_moveScript.StopMoving()
			_fireScript.StartFiring(other.transform)
	
	def TargetLost ():
		_fireScript.StopFiring()
		
	def _OnTriggerExit (other as Collider):
		if other.transform == _fireScript.Target:
			Debug.Log("Target moved (${other.gameObject.name})")
			_fireScript.StopFiring()
