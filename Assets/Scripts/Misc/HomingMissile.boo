import UnityEngine

class HomingMissile (MonoBehaviour): 

	public speed as single = 10
	public acceleration as single = 0.5
	public homingSpeedRatio as single = 0.7
	public agility as single = 1
	public timeToLive as single = 20
	
	_fired = false
	_target as Transform
	_currentSpeed as single = 0
	_homing = false
	
	def Start():
		gameObject.GetComponent(Projectile).ignoreLayerMask = \
			1 << LayerMask.NameToLayer("Ammo")
	
	def Fire(target as Transform):
		_fired = true
		_target = target
		Invoke("OutOfFuel", timeToLive)
	
	def FixedUpdate():
		if not _fired:
			return
		
		// accelerate
		_currentSpeed = Mathf.Lerp(_currentSpeed, speed, Time.deltaTime * acceleration)
		rigidbody.velocity = transform.forward * _currentSpeed
		
		if _currentSpeed >= speed * homingSpeedRatio:
			//Debug.Log("Reached homing speed") if not _homing
			_homing = true
		
		// steer
		if _homing and _target:
			targetDirection = _target.position - transform.position
			transform.forward = Vector3.Lerp(transform.forward, targetDirection.normalized, Time.deltaTime * agility)
	
	def OutOfFuel():
		explosion = gameObject.GetComponent(Projectile).explosion
		/*instantiatedExplosion = */Instantiate(explosion, transform.position, Quaternion.Euler(0, 0, 0))
		Destroy(gameObject)
