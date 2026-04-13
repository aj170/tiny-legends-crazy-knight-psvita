using System.Collections.Generic;
using UnityEngine;

public class MyguiSpriteAnimation : MonoBehaviour
{
	public int m_FPS = 30;

	public string m_Prefix = string.Empty;

	private TUIMeshSprite mSprite;

	private float mDelta;

	private int mIndex;

	private int m_countOfStage0;

	private bool m_bSwitch;

	private List<string> mSpriteNames = new List<string>();

	public int framesPerSecond
	{
		get
		{
			return m_FPS;
		}
		set
		{
			m_FPS = value;
		}
	}

	public string namePrefix
	{
		get
		{
			return m_Prefix;
		}
		set
		{
			if (m_Prefix != value)
			{
				m_Prefix = value;
				RebuildSpriteList();
			}
		}
	}

	private void Start()
	{
		RebuildSpriteList();
	}

	private void Update()
	{
		if (mSpriteNames.Count <= 1 || !Application.isPlaying)
		{
			return;
		}
		mDelta += Time.deltaTime;
		float num = ((!((float)m_FPS > 0f)) ? 0f : (1f / (float)m_FPS));
		if (!(num < mDelta))
		{
			return;
		}
		mDelta = ((!(num > 0f)) ? 0f : (mDelta - num));
		if (++mIndex >= 12 && !m_bSwitch)
		{
			m_countOfStage0++;
			if (m_countOfStage0 == 3)
			{
				mIndex = 13;
				m_countOfStage0 = 0;
				m_bSwitch = true;
			}
			else
			{
				mIndex = 0;
			}
		}
		if (++mIndex >= mSpriteNames.Count)
		{
			mIndex = 0;
			m_bSwitch = false;
		}
		mSprite.frameName = mSpriteNames[mIndex];
		mSprite.UpdateMesh();
	}

	private void RebuildSpriteList()
	{
		if (mSprite == null)
		{
			mSprite = GetComponent<TUIMeshSprite>();
		}
		mSpriteNames.Clear();
		if (mSprite != null)
		{
			for (int i = 0; i < 24; i++)
			{
				mSpriteNames.Add(i.ToString());
			}
		}
	}
}
