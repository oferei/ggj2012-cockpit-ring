import UnityEngine

class Core (MonoBehaviour): 

	def Awake ():
		God.Inst.Core = transform
