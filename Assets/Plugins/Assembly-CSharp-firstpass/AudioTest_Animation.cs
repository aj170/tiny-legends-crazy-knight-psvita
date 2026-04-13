using UnityEngine;

public class AudioTest_Animation : MonoBehaviour
{
	public string m_strAnimationName;

	public WrapMode m_WrapMode = WrapMode.Once;

	public string m_strAudioSuffix = "_audio";

	private void Start()
	{
		base.GetComponent<Animation>()[m_strAnimationName].layer = 1;
		base.GetComponent<Animation>()[m_strAnimationName].wrapMode = m_WrapMode;
		base.GetComponent<Animation>().Play(m_strAnimationName);
		string text = m_strAnimationName + m_strAudioSuffix;
		if (null != base.GetComponent<Animation>().GetClip(text))
		{
			base.GetComponent<Animation>()[text].layer = 0;
			base.GetComponent<Animation>()[text].wrapMode = m_WrapMode;
			base.GetComponent<Animation>().Play(text);
		}
	}
}
