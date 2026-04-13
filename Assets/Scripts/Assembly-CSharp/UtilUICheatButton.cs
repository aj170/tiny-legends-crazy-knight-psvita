using UnityEngine;

public class UtilUICheatButton : MonoBehaviour
{
	public Vector3 showposition;

	private void Start()
	{
        base.gameObject.transform.localPosition = showposition;
        /*if (Crazy_Global.IsTestVersion)
		{
			base.gameObject.transform.localPosition = showposition;
		}*/
	}
}
