import UnityEngine

class InputMgr (MonoBehaviour): 

	public squareSize as int = 10
	
	_mouseLayerMask as int

	def Awake ():
		# mouse hit layers
		_mouseLayerMask = \
			1 << LayerMask.NameToLayer("Ground") | \
			1 << LayerMask.NameToLayer("Base") | \
			1 << LayerMask.NameToLayer("Vehicle") | \
			1 << LayerMask.NameToLayer("Copter")
	
	def OnEnable ():
		God.Inst.Hermes.Listen(MessageGameOver, self)
	
	def OnDisable ():
		God.Inst.Hermes.StopListening(MessageGameOver, self)
	
	def OnMsgGameOver(msg as MessageGameOver):
		enabled = false
	
	def Update ():
		if Input.GetKeyDown(KeyCode.Alpha1):
			MessageDeployTank(CommId.LocalPlayer)
		if Input.GetKeyDown(KeyCode.Alpha2):
			MessageDeployAA(CommId.LocalPlayer)
		if Input.GetKeyDown(KeyCode.Alpha3):
			MessageBuyCopter()
	
	def LateUpdate ():
		# find point on ground in mouse direction
		ray = Camera.main.ScreenPointToRay(Input.mousePosition)
		Debug.DrawRay(ray.origin, ray.direction * 10000, Color.yellow)
		hit as RaycastHit
		if Physics.Raycast(ray, hit, Mathf.Infinity, _mouseLayerMask):
			Debug.DrawLine(hit.point + Vector3(-squareSize, 0, -squareSize), hit.point + Vector3(-squareSize, 0, squareSize))
			Debug.DrawLine(hit.point + Vector3(-squareSize, 0, squareSize), hit.point + Vector3(squareSize, 0, squareSize))
			Debug.DrawLine(hit.point + Vector3(squareSize, 0, squareSize), hit.point + Vector3(squareSize, 0, -squareSize))
			Debug.DrawLine(hit.point + Vector3(squareSize, 0, -squareSize), hit.point + Vector3(-squareSize, 0, -squareSize))
			Debug.DrawLine(hit.point + Vector3(-squareSize, 0, -squareSize), hit.point + Vector3(squareSize, 0, squareSize))
			Debug.DrawLine(hit.point + Vector3(squareSize, 0, -squareSize), hit.point + Vector3(-squareSize, 0, squareSize))
			
			# ignore friendly targets
			return if CommObj.GetPlayerId(hit.collider.transform) == CommId.LocalPlayer
			
			MessageMouseMove(hit.point)
			
			Debug.DrawLine(ray.origin, hit.point, Color.green)
			if Input.GetButton('Fire1'):
				//Debug.Log("mouse on ${hit.collider.gameObject.name}")
				MessageCopterFire(hit.point)
		//else:
		//	Debug.DrawRay(ray.origin, ray.direction * 1000, Color.red)
		
