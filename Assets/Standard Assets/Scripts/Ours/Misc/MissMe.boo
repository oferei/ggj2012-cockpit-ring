import UnityEngine

class MissMe: 
	
	static def IgnoreFriendlyCollisions(newObj as CommObj, ignore as bool):
		//Debug.Log("IgnoreFriendlyCollisions(${newObj.gameObject.name})")
		newObjId = newObj.playerId
		for obj as CommObj in Object.FindObjectsOfType(CommObj):
			//Debug.Log("    IgnoreFriendlyCollisions(${newObj.gameObject.name}, ${obj.gameObject.name})")
			continue if newObj.GetInstanceID() == obj.GetInstanceID()
			//Debug.Log("    IgnoreFriendlyCollisions - CHILD-PARENT") if obj.transform.IsChildOf(newObj.transform)
			continue if obj.transform.IsChildOf(newObj.transform)
			//Debug.Log("    IgnoreFriendlyCollisions - CHILD-PARENT") if newObj.transform.IsChildOf(obj.transform)
			continue if newObj.transform.IsChildOf(obj.transform)
			if newObjId == obj.playerId:
				DeepIgnoreCollision(newObj.gameObject, obj.gameObject, ignore)
	
	static def DeepIgnoreCollision(obj1 as GameObject, obj2 as GameObject, ignore):
		//Debug.Log("DeepIgnoreCollision(${obj1.name}, ${obj2.name})")
		assert obj1.GetInstanceID() != obj2.GetInstanceID()
		assert not obj1.transform.IsChildOf(obj2.transform)
		assert not obj2.transform.IsChildOf(obj1.transform)
		for col1 as Collider in obj1.GetComponentsInChildren(Collider):
			//Debug.Log("!col1.enabled") if not col1.enabled
			continue if not col1.enabled
			for col2 as Collider in obj2.GetComponentsInChildren(Collider):
				//Debug.Log("!col2.enabled") if not col2.enabled
				continue if not col2.enabled
				Physics.IgnoreCollision(col1, col2, ignore)
