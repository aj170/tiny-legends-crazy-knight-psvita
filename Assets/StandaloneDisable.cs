using UnityEngine;

public class StandaloneDisable : MonoBehaviour
{
	[SerializeField] GameObject[] toDisable;

#if UNITY_STANDALONE
	void Start() 
	{
		foreach (GameObject go in toDisable) go.SetActive(false);
	}
#endif
}
