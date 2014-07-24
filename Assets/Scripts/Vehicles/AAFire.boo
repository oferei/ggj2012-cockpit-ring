import UnityEngine

class AAFire (MonoBehaviour): 
	
	public missilePrefab as Transform
	public explosion as Transform
	public timeToLiveWithoutMissile as single = 2
	
	_missile as Transform
	_fired = false
	
	def Awake():
		assert missilePrefab
		assert explosion
		muzzle = transform.FindChild("Muzzle")
		assert muzzle
		_missile = Instantiate(missilePrefab, muzzle.position, muzzle.rotation)
		_missile.parent = transform
		_missile.rigidbody.isKinematic = true
		CommObj.SetPlayerId(transform, _missile)

	def Fire(target as Transform):
		if _fired:
			return
		_fired = true
		
		//Debug.Log("Fire AA!")
		
		_missile.parent = null
		_missile.rigidbody.isKinematic = false
		_missile.GetComponent(HomingMissile).Fire(target)
		
		Invoke("SelfDestruct", timeToLiveWithoutMissile)
	
	def SelfDestruct():
		Instantiate(explosion, transform.position, Quaternion.Euler(0, 0, 0))
		Destroy(gameObject)
