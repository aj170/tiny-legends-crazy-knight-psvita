using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using UnityEngine;

public class Crazy_Global
{
	public enum CrazyProcessAction
	{
		WeaponIcon = 1,
		MaxStage3 = 2,
		MaxStage6 = 3,
		MixMonster = 4,
		HeroIcon = 5,
		Ranged = 6,
		Net = 7,
		ShowProp = 8
	}

	public static bool IsTestVersion;

	protected static string SocialIP = string.Empty;

	protected static int SocialPort;

	public static string ServerTime = string.Empty;

	public static bool IsFirstCommunication = true;

	public static bool IsCommunicationSuccess;

	protected static GameObject Taudiocontroller;

	public static void SetSocialData()
	{
		SocialIP = SocialVersion.Instance.SocialIP;
		SocialPort = SocialVersion.Instance.SocialPort;
	}

	public static void ShowChatRoom(string name)
	{
		if (SocialIP != string.Empty)
		{
			TChatRoom.ShowChatRoom(SocialIP, SocialPort, name);
		}
	}

	public static bool CheckCheat()
	{
		Crazy_Weapon crazy_Weapon = Crazy_Weapon.FindWeaponByID(Crazy_Weapon.ReadWeaponInfo(), Crazy_Data.CurData().GetWeaponId());
		int num = crazy_Weapon.damage + Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage;
		bool flag = OtherPlugin.IsJailBreak();
		return Crazy_Data.CurData().GetLevel() > 30 || num > 10000 || crazy_Weapon.move > 15f || flag;
	}

	public static void OnRecommend()
	{
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Level", Crazy_Data.CurData().GetLevel());
		FlurryPlugin.logEvent("TLHE_Ad_Click", hashtable);
		Crazy_Data.CurData().SetRecommend(true);
		Crazy_Data.SaveData();
		OpenTLHEURL();
	}

	public static void SetServerTime(string serverTime)
	{
		ServerTime = serverTime;
	}

	public static void SetCommunicationSuccess(bool success)
	{
		IsCommunicationSuccess = success;
	}

	public static void SetCommunication()
	{
		Debug.Log("SetCommunication");
		Crazy_Data.CurData().SetCommunicate(true);
		Crazy_Data.SaveData();
	}

	public static void SetRecommendPresent()
	{
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Level", Crazy_Data.CurData().GetLevel());
		FlurryPlugin.logEvent("TLHE_Reward", hashtable);
		Debug.Log("SetRecommendPresent");
		Crazy_Data.CurData().SetRecommendPresent(true);
		Crazy_Data.CurData().SetUnlock(Crazy_PlayerClass.Paladin, true);
		Crazy_Data.CurData().SetHeroIconDirectly(true);
		Crazy_Data.SaveData();
	}

	public static void OpenTLHEURL()
	{
		Application.OpenURL(CommunicationVersion.Instance.CommUrl);
	}

	public static void OpenReviewURL()
	{
		if (Crazy_Const.AMAZON_IAP_CONST)
		{
			Application.OpenURL("http://www.amazon.com/gp/mas/dl/android?p=com.trinitigame.android.tlck");
		}
		else
		{
			Application.OpenURL("market://details?id=com.trinitigame.android.tlck");
		}
	}

	public static void _OpenURL(string url)
	{
		if (Crazy_Const.AMAZON_IAP_CONST)
		{
			Application.OpenURL(url);
		}
		else
		{
			Application.OpenURL("market://details?id=com.trinitigame.android.tlck");
		}
	}

	public static void OpenSupportURL()
	{
		Application.OpenURL("http://www.trinitigame.com/support?game=TLCK&version=2.7");
	}

	public static void Prize(int id)
	{
		Crazy_Award awardInfo = Crazy_Award.GetAwardInfo(id);
		foreach (Crazy_Award_Item item in awardInfo.item)
		{
			switch (item.type)
			{
			case Crazy_Award_Item_Type.Currency:
				switch (item.id)
				{
				case 0:
					Crazy_Data.CurData().SetMoney(Crazy_Data.CurData().GetMoney() + item.count);
					Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task23, 0, item.count);
					Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task24, 0, item.count);
					Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task25, 0, item.count);
					break;
				case 1:
					Crazy_Data.CurData().SetCrystal(Crazy_Data.CurData().GetCrystal() + item.count);
					break;
				}
				break;
			case Crazy_Award_Item_Type.Weapon:
				Crazy_Data.CurData().SetWeapon(item.id, true);
				break;
			}
		}
		Crazy_Data.SaveData();
	}

	public static XmlDocument ReadXml(string path)
	{
		string path2 = "Data/" + path;
		TextAsset textAsset = Resources.Load(path2) as TextAsset;
		XmlDocument xmlDocument = new XmlDocument();
		xmlDocument.LoadXml(textAsset.text);
		return xmlDocument;
	}

	public static List<float> RandomSeed(float seed, int number)
	{
		List<float> list = new List<float>();
		for (int i = 0; i < number; i++)
		{
			seed = NextSeed(seed, 239641f, 1251325f, 9940613f);
			list.Add(seed);
		}
		return list;
	}

	protected static float NextSeed(float seed, float a, float b, float c)
	{
		return Mathf.Abs((seed * a + b) % c) - (c - 1f) / 2f;
	}

	public static bool IsHD()
	{
		bool flag = false;
		float num = Mathf.Max(Screen.width, Screen.height);
		float num2 = Mathf.Min(Screen.width, Screen.height);
		if (num <= 1136f && num >= 960f && num <= 768f && num >= 640f)
		{
			return true;
		}
		return true;
	}

	public static bool IsIPadSize()
	{
		return false;
	}

	public static bool IsIPhone5Size()
	{
		return false;
	}

	public static GameObject LoadAssetsPrefab(string path)
	{
		return UnityEngine.Object.Instantiate(Resources.Load(path)) as GameObject;
	}

	public static Vector2 RotatebyAngle(Vector2 original, Vector2 forward, float angle, float distance)
	{
		Vector2 vector = Rotate(forward, angle);
		return original + vector * distance;
	}

	public static Vector2 Rotate(Vector2 forward, float angle)
	{
		Vector2 rhs = new Vector2(Mathf.Cos(angle * ((float)Math.PI / 180f)), 0f - Mathf.Sin(angle * ((float)Math.PI / 180f)));
		Vector2 result = new Vector2(y: Vector2.Dot(forward, new Vector2(0f - rhs.y, rhs.x)), x: Vector2.Dot(forward, rhs));
		result.Normalize();
		return result;
	}

	public static Vector3 FindMonsterAppPosition(float min, float max)
	{
		float num = UnityEngine.Random.Range(0f - max, max);
		float num2;
		if (num >= 0f - min && num <= min)
		{
			num2 = UnityEngine.Random.Range(min, max);
			num2 = ((UnityEngine.Random.Range(0, 2) != 0) ? num2 : (num2 * -1f));
		}
		else
		{
			num2 = UnityEngine.Random.Range(0f - max, max);
		}
		return new Vector3(num, 0f, num2);
	}

	public static Vector3 FindMonsterAppPosition(Crazy_Point point)
	{
		float num = UnityEngine.Random.Range(0f, point.range);
		float num2 = UnityEngine.Random.Range(0f, num);
		float num3 = num - num2;
		num2 = ((UnityEngine.Random.Range(0, 2) != 0) ? num2 : (num2 * -1f));
		num3 = ((UnityEngine.Random.Range(0, 2) != 0) ? num3 : (num3 * -1f));
		return new Vector3(point.point.x + num2, 0f, point.point.y + num3);
	}

	public static List<int> RandomRange(int begin, int end, int num)
	{
		List<int> list = new List<int>();
		for (int i = begin; i < end; i++)
		{
			list.Add(i);
		}
		int count = list.Count;
		for (int j = 0; j < Mathf.Max(count - num, 0); j++)
		{
			int index = UnityEngine.Random.Range(0, list.Count);
			list.RemoveAt(index);
		}
		return list;
	}

	public static AudioListener GetAudioListener()
	{
		return TAudioManager.instance.AudioListener;
	}

	public static string SecondToMinuteSecond(int second)
	{
		TimeSpan timeSpan = new TimeSpan(0, 0, second);
		return timeSpan.Minutes.ToString("D02") + ":" + timeSpan.Seconds.ToString("D02");
	}

	public static void PlayBGM(string name)
	{
		if (Taudiocontroller == null)
		{
			Taudiocontroller = new GameObject("TAudioControllerEx", typeof(TAudioControllerEx));
			UnityEngine.Object.DontDestroyOnLoad(Taudiocontroller);
		}
		TAudioControllerEx component = Taudiocontroller.GetComponent<TAudioControllerEx>();
		component.PlayMusic(name);
	}

	public static void PlayAddBGM(string name)
	{
		if (Taudiocontroller == null)
		{
			Taudiocontroller = new GameObject("TAudioControllerEx", typeof(TAudioControllerEx));
			UnityEngine.Object.DontDestroyOnLoad(Taudiocontroller);
		}
		TAudioControllerEx component = Taudiocontroller.GetComponent<TAudioControllerEx>();
		component.PlayAudio(name);
	}

	public static void ShowIPadOpenClik()
	{
		if (Screen.width >= 1024 && Screen.height >= 768)
		{
			OpenClickNew.Show(false);
		}
	}

	public static void HideIPadOpenClik()
	{
		if (Screen.width >= 1024 && Screen.height >= 768)
		{
			OpenClickNew.Hide();
		}
	}

	public static float FloatRegionRandom(List<FloatRegionPercent> frp)
	{
		if (frp.Count == 0)
		{
			Debug.LogWarning("No FloatRegion");
			return 0f;
		}
		float num = UnityEngine.Random.Range(0f, 1f);
		foreach (FloatRegionPercent item in frp)
		{
			if (num < item.percent)
			{
				return item.fr.RandomFloat();
			}
			num -= item.percent;
		}
		Debug.LogWarning("FloatRegion Percent Error Return Random");
		return frp[0].fr.RandomFloat();
	}

	public static Crazy_Process GetActiveProcess()
	{
		int process = Crazy_Data.CurData().GetProcess();
		Crazy_Process processInfo = Crazy_Process.GetProcessInfo(process);
		if (processInfo == null)
		{
			return null;
		}
		if (Crazy_Data.CurData().GetLevel() < processInfo.condition)
		{
			return null;
		}
		return processInfo;
	}

	public static void DoProcessAction()
	{
		Crazy_Process activeProcess = GetActiveProcess();
		if (activeProcess != null && activeProcess.action != -1 && !Crazy_Data.CurData().GetDoAction())
		{
			switch ((CrazyProcessAction)activeProcess.action)
			{
			case CrazyProcessAction.WeaponIcon:
				Crazy_Data.CurData().SetWeaponIcon(true);
				break;
			case CrazyProcessAction.MaxStage3:
				Crazy_Data.CurData().SetMinMaxStage(2, 4);
				break;
			case CrazyProcessAction.MaxStage6:
				Crazy_Data.CurData().SetMinMaxStage(4, 6);
				break;
			case CrazyProcessAction.MixMonster:
				Crazy_Data.CurData().SetMixMonster(true);
				break;
			case CrazyProcessAction.HeroIcon:
				Crazy_Data.CurData().SetHeroIcon(true);
				break;
			case CrazyProcessAction.Ranged:
				Crazy_Data.CurData().SetRanged(true);
				break;
			case CrazyProcessAction.Net:
				Crazy_Data.CurData().SetNet(true);
				break;
			case CrazyProcessAction.ShowProp:
				Crazy_Data.CurData().SetShowPropPanel(true);
				break;
			}
			Crazy_Data.SaveData();
		}
	}

	public static string GetCurSystemTime()
	{
		return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
	}

	public static string GetCurSystemData()
	{
		return DateTime.Now.ToString("yyyy-MM-dd");
	}

	public static void EventAnimation(AnimationClip ani, float time, string functionname, int intP = 0, float floatP = 0f, string stringP = "", UnityEngine.Object objectP = null)
	{
		AnimationEvent animationEvent = new AnimationEvent();
		animationEvent.functionName = functionname;
		animationEvent.time = time;
		animationEvent.intParameter = intP;
		animationEvent.floatParameter = floatP;
		animationEvent.stringParameter = stringP;
		animationEvent.objectReferenceParameter = objectP;
		ani.AddEvent(animationEvent);
	}
}
