import UnityEngine

class CopterStart (MonoBehaviour):
	
	public speed as single = 1
	
	_exitPoint as Vector3

	def Deploy(exitPoint as Vector3):
		_exitPoint = exitPoint
		
		Camera.main.GetComponent(CameraFollow).target = transform
		gameObject.GetComponent(CopterMove).enabled = false
		gameObject.GetComponent(CopterLook).enabled = false
		gameObject.GetComponent(CopterFire).enabled = false
		gameObject.GetComponent(CopterEarnMoney).enabled = false
		
	def FixedUpdate():
		direction = _exitPoint - transform.position
		
		if direction.magnitude < 0.03:
			Done()
			return
		
		toMove = direction.normalized * speed * Time.deltaTime
		transform.position += toMove
	
	def Done():
		gameObject.GetComponent(CopterMove).enabled = true
		gameObject.GetComponent(CopterLook).enabled = true
		gameObject.GetComponent(CopterFire).enabled = true
		gameObject.GetComponent(CopterEarnMoney).enabled = true
		self.enabled = false
