using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class AudioManager : MonoBehaviour
{
	private class AudioProperty
	{
		public int m_iCounts;

		public float m_fLength;

		public int m_iMaxSameNum;

		public float m_fDelayTimes;

		public Dictionary<int, float> m_mapStartTime = new Dictionary<int, float>();
	}

	private class ProbabilityItem
	{
		public int m_iIndex;

		public float m_fProbGap;
	}

	public static bool s_bSoundOn = true;

	public static bool s_bMusicOn = true;

	private static Hashtable s_AudioPropertyCenter = new Hashtable();

	private static int m_iCurrentFrameCount = -1;

	public AudioClip[] m_AudioClips;

	public int m_iMaxSameNum;

	public float m_fDelayTime;

	public bool m_bTogetherPlay;

	public float[] m_Probability;

	private int m_iLastPlayIndex = -1;

	private List<int> m_randomList = new List<int>();

	public void RandomPlaySound()
	{
		if (!s_bSoundOn || m_AudioClips.Length == 0)
		{
			return;
		}
		if (m_bTogetherPlay)
		{
			for (int i = 0; i < m_AudioClips.Length; i++)
			{
				AudioClip audioClip = m_AudioClips[i];
				if (null != audioClip && IsCanPlay(audioClip))
				{
					PlayAudio(audioClip, false);
				}
			}
			return;
		}
		if (m_Probability.Length != 0)
		{
			List<ProbabilityItem> list = new List<ProbabilityItem>();
			float num = 0f;
			float num2 = 0f;
			for (int j = 0; j < m_Probability.Length; j++)
			{
				if (j == m_iLastPlayIndex)
				{
					num2 = m_Probability[j];
					continue;
				}
				num += m_Probability[j];
				ProbabilityItem probabilityItem = new ProbabilityItem();
				probabilityItem.m_iIndex = j;
				probabilityItem.m_fProbGap = num;
				list.Add(probabilityItem);
			}
			if (list.Count == 0)
			{
				return;
			}
			float num3 = num2 / (float)list.Count;
			float num4 = Random.Range(0f, 1f);
			int num5 = -1;
			for (int k = 0; k < list.Count; k++)
			{
				ProbabilityItem probabilityItem2 = list[k];
				if (num4 <= probabilityItem2.m_fProbGap + num3 * (float)(k + 1))
				{
					num5 = probabilityItem2.m_iIndex;
					break;
				}
			}
			for (int l = 0; l < list.Count; l++)
			{
				ProbabilityItem probabilityItem3 = list[l];
			}
			if (0 <= num5 && num5 < m_AudioClips.Length)
			{
				m_iLastPlayIndex = num5;
				AudioClip audioClip2 = m_AudioClips[num5];
				if (null != audioClip2 && IsCanPlay(audioClip2))
				{
					PlayAudio(audioClip2, false);
				}
			}
			return;
		}
		if (m_randomList.Count == 0)
		{
			for (int m = 0; m < m_AudioClips.Length; m++)
			{
				m_randomList.Add(m);
			}
		}
		int num6 = Random.Range(0, 1000);
		num6 %= m_randomList.Count;
		int num7 = m_randomList[num6];
		m_randomList.RemoveAt(num6);
		AudioClip audioClip3 = m_AudioClips[num7];
		if (null != audioClip3 && IsCanPlay(audioClip3))
		{
			PlayAudio(audioClip3, false);
		}
	}

	public void PlaySound(int index, bool bLoop)
	{
		if (s_bSoundOn && index < m_AudioClips.Length)
		{
			AudioClip clip = m_AudioClips[index];
			if (bLoop)
			{
				PlayAudio(clip, true);
			}
			else if (IsCanPlay(clip))
			{
				PlayAudio(clip, false);
			}
		}
	}

	public void PlayMusic(int index, bool bLoop)
	{
		if (s_bMusicOn && index < m_AudioClips.Length)
		{
			AudioClip clip = m_AudioClips[index];
			if (bLoop)
			{
				PlayAudio(clip, true);
			}
			else if (IsCanPlay(clip))
			{
				PlayAudio(clip, false);
			}
		}
	}

	public void Stop()
	{
		base.GetComponent<AudioSource>().Stop();
	}

	public void Pause()
	{
		base.GetComponent<AudioSource>().Pause();
	}

	private void PlayAudio(AudioClip clip, bool bLoop)
	{
		base.GetComponent<AudioSource>().clip = clip;
		base.GetComponent<AudioSource>().loop = bLoop;
		base.GetComponent<AudioSource>().Play();
	}

	private void Update()
	{
		if (Time.frameCount == m_iCurrentFrameCount)
		{
			return;
		}
		m_iCurrentFrameCount = Time.frameCount;
		foreach (AudioProperty value2 in s_AudioPropertyCenter.Values)
		{
			List<int> list = new List<int>();
			foreach (KeyValuePair<int, float> item in value2.m_mapStartTime)
			{
				float value = item.Value;
				int key = item.Key;
				if (Time.time >= value + value2.m_fLength)
				{
					list.Add(key);
				}
			}
			if (list.Count <= 0)
			{
				continue;
			}
			foreach (int item2 in list)
			{
				value2.m_mapStartTime.Remove(item2);
			}
		}
	}

	private bool IsCanPlay(AudioClip clip)
	{
		AudioProperty audioProperty = null;
		string key = base.gameObject.name + "_" + clip.name;
		if (s_AudioPropertyCenter.ContainsKey(key))
		{
			audioProperty = s_AudioPropertyCenter[key] as AudioProperty;
		}
		else
		{
			audioProperty = new AudioProperty();
			audioProperty.m_iCounts = 0;
			audioProperty.m_fLength = clip.length;
			audioProperty.m_fDelayTimes = m_fDelayTime;
			audioProperty.m_iMaxSameNum = m_iMaxSameNum;
			s_AudioPropertyCenter.Add(key, audioProperty);
		}
		bool flag = false;
		if (audioProperty.m_iMaxSameNum <= 0)
		{
			flag = true;
		}
		else
		{
			int num = 0;
			foreach (KeyValuePair<int, float> item in audioProperty.m_mapStartTime)
			{
				float value = item.Value;
				if (Time.time - value <= audioProperty.m_fDelayTimes)
				{
					num++;
				}
			}
			if (num < audioProperty.m_iMaxSameNum)
			{
				flag = true;
			}
		}
		if (flag)
		{
			audioProperty.m_mapStartTime.Add(++audioProperty.m_iCounts, Time.time);
		}
		return flag;
	}
}
