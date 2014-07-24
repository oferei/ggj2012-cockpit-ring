import UnityEngine

class CopterFire (MonoBehaviour): 
	
	public rocketPrefab as Transform
	public rocketSpeed as single = 5
	public firingRate as single = 1
	
	_lastFireTime as single = -100

	def OnEnable ():
		God.Inst.Hermes.Listen(MessageCopterFire, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageCopterFire, self)
	
	def OnMsgCopterFire(msg as MessageCopterFire):
		//return if msg.hitPoint == Vector3.zero
		
		now = Time.time
		if now - _lastFireTime < firingRate:
			return
		_lastFireTime = now
		
		muzzle = transform.FindChild("Copter/Muzzle")
		assert muzzle
		rocketPath = msg.hitPoint - muzzle.position
		rotation = Quaternion.LookRotation(rocketPath)
		rocket = Instantiate(rocketPrefab, muzzle.position, rotation)
		rocket.rigidbody.velocity = rocketPath.normalized * rocketSpeed
		CommObj.SetPlayerId(transform, rocket)
