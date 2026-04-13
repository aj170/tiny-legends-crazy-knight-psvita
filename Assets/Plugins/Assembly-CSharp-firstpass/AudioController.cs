using UnityEngine;

public class AudioController : MonoBehaviour
{
	public void PlayAudio(string objName)
	{
		Transform transform = base.transform.Find("Audio");
		if (null == transform)
		{
			GameObject gameObject = new GameObject("Audio");
			gameObject.transform.parent = base.transform;
			gameObject.transform.localPosition = Vector3.zero;
			transform = gameObject.transform;
		}
		int num = objName.LastIndexOf('/');
		num++;
		string text = objName.Substring(num);
		GameObject gameObject2 = null;
		Transform transform2 = base.transform.Find("Audio/" + text);
		if (null == transform2)
		{
			gameObject2 = Object.Instantiate(Resources.Load("SoundEvent/" + objName)) as GameObject;
			gameObject2.name = text;
			gameObject2.transform.parent = transform;
			gameObject2.transform.localPosition = Vector3.zero;
		}
		else
		{
			gameObject2 = transform2.gameObject;
		}
		AudioManager component = gameObject2.GetComponent<AudioManager>();
		component.RandomPlaySound();
	}
}
