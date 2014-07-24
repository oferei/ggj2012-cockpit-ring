import UnityEngine

class Starter (MonoBehaviour): 

	def Update ():
		if Input.GetMouseButtonDown(0) or Input.GetKeyDown("space"):
			end()
	
	def end():
		Application.LoadLevel("Game")
