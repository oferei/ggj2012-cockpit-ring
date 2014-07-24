import UnityEngine

class CopterEarnMoney (MonoBehaviour): 
	
	public maxDistanceFromRoad as single = 10
	public moneyPerSecond as single = 1
	public distanceFactor as single = 3
	
	_centerOnMyLevel as Vector3
	_minSqrDistanceFromCenter as single
	_maxSqrDistanceFromCenter as single
	_playerId as string

	def Awake():
		_centerOnMyLevel = God.Inst.Core.position
		_centerOnMyLevel.y = transform.position.y
		
		distanceFromCenter = (transform.position - _centerOnMyLevel).magnitude
		_minSqrDistanceFromCenter = distanceFromCenter - maxDistanceFromRoad
		_minSqrDistanceFromCenter *= _minSqrDistanceFromCenter
		_maxSqrDistanceFromCenter = distanceFromCenter + maxDistanceFromRoad
		_maxSqrDistanceFromCenter *= _maxSqrDistanceFromCenter
	
	def Start():
		_playerId = CommObj.GetPlayerId(transform)

	def Update ():
		sqrDistanceFromCenter = (transform.position - _centerOnMyLevel).sqrMagnitude
		//Debug.Log("distance: ${sqrDistanceFromCenter}, min: ${_minSqrDistanceFromCenter}, max: ${_maxSqrDistanceFromCenter}")
		return if sqrDistanceFromCenter < _minSqrDistanceFromCenter or sqrDistanceFromCenter > _maxSqrDistanceFromCenter
		
		angle = Vector3.Angle(Vector3.forward, _centerOnMyLevel - transform.position)
		factor = angle / 180 * (distanceFactor-1)/distanceFactor + 1/distanceFactor
		//Debug.Log("angle: ${angle}, factor: ${factor}")
		
		amount = moneyPerSecond * factor
		MessageEarnMoney(_playerId, amount * Time.deltaTime)
