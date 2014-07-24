import UnityEngine

class DebugInput (MonoBehaviour): 

	def Update ():
		if Input.GetKeyDown(KeyCode.Alpha4):
			MessageDeployTank('2')
		if Input.GetKeyDown(KeyCode.Alpha5):
			MessageDeployAA('2')
