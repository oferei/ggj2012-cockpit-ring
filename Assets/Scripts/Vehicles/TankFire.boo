import UnityEngine

class TankFire (MonoBehaviour): 
	
	public shellPrefab as Transform
	public shellSpeed as single = 5
	public firingDelay as single = 0.2
	public firingRate as single = 1
	
	_isFiring = false
	
	Target:
		get:
			return _target
	_target as Transform = null

	def Awake():
		assert shellPrefab

	def Update():
		if _isFiring and not _target:
			StopFiring()
			SendMessage("TargetLost")
		
	def StartFiring (target as Transform):
		//Debug.Log("Shooting at ${target.gameObject.name}")
		
		_isFiring = true
		_target = target
		
		InvokeRepeating('LaunchProjectile', firingDelay, firingRate)
	
	def LaunchProjectile():
		muzzle = transform.FindChild("Muzzle")
		assert muzzle
		rotation = Quaternion.LookRotation(_target.position - transform.position)
		shell = Instantiate(shellPrefab, muzzle.position, rotation)
		shell.rigidbody.velocity = (_target.position - transform.position).normalized * shellSpeed
		CommObj.SetPlayerId(transform, shell)
	
	def StopFiring ():
		if _isFiring:
			_isFiring = false
			_target = null
			CancelInvoke()
