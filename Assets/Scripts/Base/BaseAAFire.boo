import UnityEngine

class BaseAAFire (MonoBehaviour): 
	
	public missilePrefab as Transform
	public missilePrepareTime as single = 5
	
	_sensor as Transform
	_muzzleL as Transform
	_muzzleR as Transform
	_missileL as Transform = null
	_missileR as Transform = null

	def Awake ():
		_sensor = transform.FindChild("Sensor")
		assert _sensor
		_muzzleL = transform.FindChild("Muzzle-L")
		assert _muzzleL
		_muzzleR = transform.FindChild("Muzzle-R")
		assert _muzzleR
	
	def Start():
		PrepareMissiles()
	
	def PrepareMissiles():
		_missileL = InstantiateMissile(_muzzleL)
		_missileR = InstantiateMissile(_muzzleR)
		_sensor.collider.enabled = true
		MissMe.IgnoreFriendlyCollisions(gameObject.GetComponent(CommObj), true)
	
	def InstantiateMissile(muzzle as Transform):
		assert missilePrefab
		
		missile = Instantiate(missilePrefab, muzzle.position, muzzle.rotation)
		missile.parent = transform
		CommObj.SetPlayerId(transform, missile)
		
		return missile
	
	def _OnTriggerStay (other as Collider):
		// ignore other triggers
		if other.isTrigger:
			return
		
		// prevent friendly fire
		return if CommObj.AreFriendly(transform, other.transform)
		
		//Debug.Log("Copter detected!")
		if _missileL:
			Fire(other.transform)
			_sensor.collider.enabled = false
			Invoke("PrepareMissiles", missilePrepareTime)
	
	def Fire(target as Transform):
		// left
		_missileL.parent = null
		_missileL.GetComponent(HomingMissile).Fire(target)
		_missileL = null
		// right
		_missileR.parent = null
		_missileR.GetComponent(HomingMissile).Fire(target)
		_missileR = null
