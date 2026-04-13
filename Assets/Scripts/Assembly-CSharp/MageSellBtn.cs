using System;
using UnityEngine;

public class MageSellBtn : MonoBehaviour
{
	public TUIMeshSprite sprite_bk;

	public TUIMeshSprite sprite_top;

	public TUIMeshText text_time;

	public GameObject go_MageSellPanel;

	private float fDelta;

	private int nShowTime = 600;

	private void Start()
	{
		//MyGUIEventListener.Get(base.gameObject).EventHandleOnPressed += OnDiscountPress;
		//MyGUIEventListener.Get(base.gameObject).EventHandleOnReleased += OnDiscountRelease;
		MyGUIEventListener.Get(base.gameObject).EventHandleOnClicked += OnOpenMagePanel;
		if (Crazy_Data.CurData().GetMageSellTime() == string.Empty || Crazy_Data.CurData().GetUnlock(Crazy_PlayerClass.Mage))
		{
			base.gameObject.SetActiveRecursively(false);
			return;
		}
		TimeSpan timeSpan = DateTime.Now - DateTime.Parse(Crazy_Data.CurData().GetMageSellTime());
		if (timeSpan.TotalSeconds >= 600.0)
		{
			base.gameObject.SetActiveRecursively(false);
			return;
		}
		if (timeSpan.TotalSeconds <= 0.0)
		{
			text_time.text = "09:59";
			text_time.UpdateMesh();
			return;
		}
		nShowTime = 600 - (int)timeSpan.TotalSeconds;
		string text = (nShowTime / 60).ToString("D02");
		string text2 = (nShowTime % 60).ToString("D02");
		text_time.text = text + ":" + text2;
		text_time.UpdateMesh();
	}

	private void OnDiscountPress(GameObject go, Vector2 pos)
	{
		sprite_bk.frameName = "discount_bk_press";
		sprite_bk.UpdateMesh();
		text_time.color = new Color(0.27f, 0.02f, 0.004f);
		text_time.UpdateMesh();
	}

	private void OnDiscountRelease(GameObject go, Vector2 pos)
	{
		sprite_bk.frameName = "discount_bk_normal";
		sprite_bk.UpdateMesh();
		text_time.color = new Color(1f, 1f, 1f);
		text_time.UpdateMesh();
	}

	private void OnOpenMagePanel(GameObject go)
	{
		go_MageSellPanel.SetActiveRecursively(true);
		go_MageSellPanel.GetComponent<MageSellPanel>().SetCountZero(nShowTime);
	}

	private void Update()
	{
		if (!(Crazy_Data.CurData().GetMageSellTime() == string.Empty))
		{
			fDelta += Time.deltaTime;
			TimeSpan timeSpan = DateTime.Now - DateTime.Parse(Crazy_Data.CurData().GetMageSellTime());
			if (timeSpan.TotalSeconds >= 600.0)
			{
				base.gameObject.SetActiveRecursively(false);
			}
			else if (timeSpan.TotalSeconds <= 0.0)
			{
				text_time.text = "09:59";
				text_time.UpdateMesh();
			}
			else if (fDelta >= 1f)
			{
				fDelta = 0f;
				nShowTime--;
				string text = (nShowTime / 60).ToString("D02");
				string text2 = (nShowTime % 60).ToString("D02");
				text_time.text = text + ":" + text2;
				text_time.UpdateMesh();
			}
		}
	}

	private void OnApplicationPause(bool pause)
	{
		if (Crazy_Data.CurData().GetMageSellTime() != string.Empty)
		{
			TimeSpan timeSpan = DateTime.Now - DateTime.Parse(Crazy_Data.CurData().GetMageSellTime());
			if (timeSpan.TotalSeconds <= 0.0)
			{
				nShowTime = 600;
			}
			else
			{
				nShowTime = 600 - (int)timeSpan.TotalSeconds;
			}
		}
	}
}
