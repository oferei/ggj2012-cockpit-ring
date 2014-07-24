import UnityEngine

class CopterMove (MonoBehaviour): 

	public speed as single = 5
	public damping as single = 10
	public extraDistanceFromCenter as single = 10
	
	_centerOnMyLevel as Vector3
	_maxSqrDistanceFromCenter as int
	_currentDirection = Vector3.zero

	def Start():
		_centerOnMyLevel = God.Inst.Core.position
		_centerOnMyLevel.y = transform.position.y
		//_maxSqrDistanceFromCenter = (transform.position - _centerOnMyLevel).sqrMagnitude
		_maxSqrDistanceFromCenter = (transform.position - _centerOnMyLevel).magnitude
		_maxSqrDistanceFromCenter += extraDistanceFromCenter
		_maxSqrDistanceFromCenter *= _maxSqrDistanceFromCenter
		
	def FixedUpdate():
		x = Input.GetAxis("Horizontal")
		y = Input.GetAxis("Vertical")
		direction = Vector3(x,0,y)
		if (direction.sqrMagnitude > 1):
			direction.Normalize()
		//Debug.Log("direction: ${direction}");
		_currentDirection = Vector3.Lerp(_currentDirection, direction * speed, Time.deltaTime * damping)
		transform.position += _currentDirection * Time.deltaTime
		
		// limit distance from center
		sqrDistance = (transform.position - _centerOnMyLevel).sqrMagnitude
		if sqrDistance > _maxSqrDistanceFromCenter:
			//Debug.Log("Too far! ${transform.position - _centerOnMyLevel}")
			v = transform.position - _centerOnMyLevel
			v.Normalize()
			v *= Mathf.Sqrt(_maxSqrDistanceFromCenter)
			transform.position = _centerOnMyLevel + v
