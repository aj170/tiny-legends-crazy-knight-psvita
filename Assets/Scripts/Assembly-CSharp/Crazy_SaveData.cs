using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using UnityEngine;

[Serializable]
public class Crazy_SaveData
{
	public class GameCenterData
	{
		public int m_killnumber;

		public GameCenterData(int count)
		{
			m_killnumber = count;
		}
	}

	public class ClassData
	{
		public int m_level;

		public int m_exp;

		public bool m_unlock;

		public int m_weapon_id;

		public ClassData(int level, int exp, int weapon_id)
		{
			m_level = level;
			m_exp = exp;
			m_weapon_id = weapon_id;
			m_unlock = false;
		}
	}

	public struct Task
	{
		public int task_id;

		public int branch_number;

		public float[] task_branch;
	}

	public static string XXTEAUtilsKey = "128904";

	private static int MaxWeaponNumber = 91;

	private static int MaxTaskNumber = 30;

	private static int CurrentVersion = 2700;

	private static int Version1010_TotalProcess = 18;

	private static int Version1100_NewWeaponId = 46;

	private static int Version1100_NewHeroLevel = 10;

	private static int Version1100_NewHeroWeaponId = 46;

	private static int RangedProcessSeq = 10;

	private static int NetProcessSeq = 11;

	private static int ShowPropSeq = 7;

	private static int Version2100_NewHeroLevel = 1;

	private static int Version2100_NewHeroWeaponId;

	private static int Version2500_NewHeroLevel = 5;

	private static int Version2500_NewHeroWeaponId = 84;

	private int m_version;

	private int m_money;

	private int m_crystal;

	private bool[] m_weapon;

	private int m_boss_level;

	private int m_process;

	private int m_min_stage;

	private int m_max_stage;

	private bool m_ismixmonster;

	private bool m_doaction;

	private bool m_weaponicon;

	private bool m_heroicon;

	private bool m_mapstory;

	private Crazy_PlayerClass m_class;

	private Dictionary<Crazy_PlayerClass, ClassData> m_class_data;

	private GameCenterData m_gamecenter;

	private bool m_present = ((!Crazy_Const.AMAZON_IAP_CONST) ? true : false);

	private int m_first_version = 1010;

	private int m_play_times;

	private string m_first_logintime = string.Empty;

	private int m_allplay_time;

	private int m_total_money;

	private float[] m_tasks = new float[MaxTaskNumber];

	private Task[] m_tasks_imp = new Task[MaxTaskNumber];

	private bool m_isranged;

	private bool m_isnet;

	private string m_netname;

	private bool m_isrecommend;

	private bool m_recommend_present;

	private bool m_iscommunicate;

	private static bool UpdateVersion1100;

	private static bool UpdateVersion2000;

	private static bool UpdateVersion2100;

	private static bool UpdateVersion2200;

	private static bool UpdateVersion2500;

	private bool m_bNotification;

	private Dictionary<int, int> propProperty = new Dictionary<int, int>();

	private bool m_bShowPropPanel;

	private int m_nLastProp = -1;

	private bool m_bShowNewbiePack = true;

	private bool m_bGetNewbiePack;

	private bool m_bShowDiscount = true;

	private string m_strShowDiscountTime = string.Empty;

	private string m_strLastLoginTime = string.Empty;

	private string m_strLastLeaveTime = string.Empty;

	private string m_strDiscountType = string.Empty;

	private string m_strLastDailyAwardTime = string.Empty;

	private int m_nLastDailyAwardID;

	private string m_strMageSellTime = string.Empty;

	public Crazy_SaveData()
	{
	}

	public Crazy_SaveData(int num)
	{
		Reset(num);
		InitTask(ref m_tasks_imp);
		InitPropProperty();
	}

	public int GetWeaponId()
	{
		return m_class_data[m_class].m_weapon_id;
	}

	public void SetWeaponId(int weaponid)
	{
		m_class_data[m_class].m_weapon_id = weaponid;
	}

	public int GetMoney()
	{
		return m_money;
	}

	public void SetMoney(int money)
	{
		m_total_money += Mathf.Max(money - m_money, 0);
		m_money = money;
	}

	public int GetCrystal()
	{
		return m_crystal;
	}

	public void SetCrystal(int crystal)
	{
		m_crystal = crystal;
	}

	public void AddCrystal(int crystal)
	{
		m_crystal += crystal;
	}

	public bool[] GetWeapon()
	{
		return m_weapon;
	}

	public void SetWeapon(int number, bool type)
	{
		if (number < m_weapon.GetLength(0))
		{
			m_weapon[number] = type;
		}
	}

	public float[] GetTask()
	{
		return m_tasks;
	}

	public float GetTask(int id)
	{
		return m_tasks[id];
	}

	public void SetTask(int id, float percent)
	{
		m_tasks[id] = percent;
	}

	public float GetTaskBranch(int id, int branchid)
	{
		return m_tasks_imp[id].task_branch[branchid];
	}

	public bool SetTaskBranch(int id, int branchid, float percent)
	{
		if (GetTask(id) >= 1f)
		{
			return false;
		}
		m_tasks_imp[id].task_branch[branchid] = percent;
		float num = 0f;
		float num2 = 1f / (float)m_tasks_imp[id].branch_number;
		bool flag = true;
		float[] task_branch = m_tasks_imp[id].task_branch;
		foreach (float num3 in task_branch)
		{
			num += num2 * num3;
			if (num3 != 1f)
			{
				flag = false;
			}
		}
		if (flag)
		{
			SetTask(id, 1f);
			return true;
		}
		SetTask(id, num);
		return false;
	}

	public int GetLevel(Crazy_PlayerClass c)
	{
		return m_class_data[c].m_level;
	}

	public int GetLevel()
	{
		return m_class_data[m_class].m_level;
	}

	public void SetLevel(int level)
	{
		m_class_data[m_class].m_level = level;
	}

	public int GetBossLevel()
	{
		return m_boss_level;
	}

	public void SetBossLevel(int boss_level)
	{
		m_boss_level = boss_level;
	}

	public int GetExp()
	{
		return m_class_data[m_class].m_exp;
	}

	public void SetExp(int exp)
	{
		m_class_data[m_class].m_exp = exp;
	}

	public Crazy_PlayerClass GetPlayerClass()
	{
		return m_class;
	}

	public void SetPlayerClass(Crazy_PlayerClass _class)
	{
		m_class = _class;
	}

	public bool GetUnlock(Crazy_PlayerClass c)
	{
		return m_class_data[c].m_unlock;
	}

	public void SetUnlock(Crazy_PlayerClass c, bool _unlock)
	{
		m_class_data[c].m_unlock = _unlock;
	}

	public int GetKillNumber()
	{
		return m_gamecenter.m_killnumber;
	}

	public void AddKillNumber(int kills)
	{
		m_gamecenter.m_killnumber += kills;
	}

	public int GetProcess()
	{
		return m_process;
	}

	public void SetProcess(int id)
	{
		m_process = id;
		m_doaction = false;
		m_mapstory = false;
	}

	public int GetMinStage()
	{
		return m_min_stage;
	}

	public int GetMaxStage()
	{
		return m_max_stage;
	}

	public void SetMinMaxStage(int min, int max)
	{
		m_min_stage = min;
		m_max_stage = max;
		m_doaction = true;
	}

	public bool GetMixMonster()
	{
		return m_ismixmonster;
	}

	public void SetMixMonster(bool mix)
	{
		m_ismixmonster = mix;
		m_doaction = true;
	}

	public bool GetWeaponIcon()
	{
		return m_weaponicon;
	}

	public void SetWeaponIcon(bool icon)
	{
		m_weaponicon = icon;
		m_doaction = true;
	}

	public bool GetHeroIcon()
	{
		return m_heroicon;
	}

	public void SetHeroIconDirectly(bool icon)
	{
		m_heroicon = icon;
	}

	public void SetHeroIcon(bool icon)
	{
		m_heroicon = icon;
		m_doaction = true;
	}

	public bool GetRanged()
	{
		return m_isranged;
	}

	public void SetRanged(bool ranged)
	{
		m_isranged = ranged;
		m_doaction = true;
	}

	public bool GetNet()
	{
		return m_isnet;
	}

	public void SetNet(bool net)
	{
		m_isnet = net;
		m_doaction = true;
	}

	public bool GetDoAction()
	{
		return m_doaction;
	}

	public bool GetMapStory()
	{
		return m_mapstory;
	}

	public void SetMapStory(bool story)
	{
		m_mapstory = story;
	}

	public void UpdateVersion()
	{
		m_version = CurrentVersion;
	}

	public bool GetPresent()
	{
		return m_present;
	}

	public void TenCrystalPresent()
	{
		if (!m_present)
		{
			m_present = true;
		}
	}

	public int GetPlayTimes()
	{
		return m_play_times;
	}

	public void AddPlayTimes()
	{
		m_play_times++;
		if (m_play_times == 1)
		{
			m_first_version = m_version;
		}
	}

	public int GetFirstVersion()
	{
		return m_first_version;
	}

	public void UpdateFirstLoginTime(string time)
	{
		if (m_first_logintime == string.Empty)
		{
			m_first_logintime = time;
		}
	}

	public void AddAllPlayTime(int time)
	{
		m_allplay_time += time;
	}

	public int GetAllPlayTime()
	{
		return m_allplay_time;
	}

	public string GetFirstLoginTime()
	{
		return m_first_logintime;
	}

	public int GetTotalMoney()
	{
		return m_total_money;
	}

	public string GetNetName()
	{
		return m_netname;
	}

	public void SetNetName(string name)
	{
		m_netname = name;
	}

	public int GetVersion()
	{
		return m_version;
	}

	public bool GetRecommend()
	{
		return m_isrecommend;
	}

	public void SetRecommend(bool recommend)
	{
		m_isrecommend = recommend;
	}

	public bool GetRecommendPresent()
	{
		return m_recommend_present;
	}

	public void SetRecommendPresent(bool recommendpresent)
	{
		m_recommend_present = recommendpresent;
	}

	public bool GetCommunicate()
	{
		return m_iscommunicate;
	}

	public void SetCommunicate(bool communicate)
	{
		m_iscommunicate = communicate;
	}

	public bool IsNotification()
	{
		return m_bNotification;
	}

	public void SetNotification(bool bNotification)
	{
		m_bNotification = bNotification;
	}

	public bool IsShowPropPanel()
	{
		return m_bShowPropPanel;
	}

	public void SetShowPropPanel(bool bShow)
	{
		m_bShowPropPanel = bShow;
	}

	public int GetLastProp()
	{
		return m_nLastProp;
	}

	public void SetLastProp(int id)
	{
		m_nLastProp = id;
	}

	public int GetPropCount(int propID)
	{
		int value = 0;
		propProperty.TryGetValue(propID, out value);
		return value;
	}

	public void SetPropCount(int propID, int count)
	{
		propProperty[propID] += count;
	}

	public bool IsShowNewbie()
	{
		return m_bShowNewbiePack;
	}

	public void SetShowNewbie(bool b)
	{
		m_bShowNewbiePack = b;
	}

	public bool IsGetNewbiePack()
	{
		return m_bGetNewbiePack;
	}

	public void SetGetNewbiePack(bool b)
	{
		m_bGetNewbiePack = b;
	}

	public bool IsShowDiscount()
	{
		return m_bShowDiscount;
	}

	public void SetShowDiscount(bool b)
	{
		m_bShowDiscount = b;
	}

	public string GetDiscountTime()
	{
		return m_strShowDiscountTime;
	}

	public void SetDiscountTime(string str)
	{
		m_strShowDiscountTime = str;
	}

	public string GetLastLoginTime()
	{
		return m_strLastLoginTime;
	}

	public void SetLastLoginTime(string str)
	{
		m_strLastLoginTime = str;
	}

	public string GetLastLeaveTime()
	{
		return m_strLastLeaveTime;
	}

	public void SetLastLeaveTime(string str)
	{
		m_strLastLeaveTime = str;
	}

	public string GetDiscountType()
	{
		return m_strDiscountType;
	}

	public void SetDiscountType(string str)
	{
		m_strDiscountType = str;
	}

	public string GetLastDailyAwardTime()
	{
		return m_strLastDailyAwardTime;
	}

	public void SetLastDailyAwardTime(string str)
	{
		m_strLastDailyAwardTime = str;
	}

	public int GetLastDailyAwardID()
	{
		return m_nLastDailyAwardID;
	}

	public void SetLastDailyAwardID(int id)
	{
		m_nLastDailyAwardID = id;
	}

	public string GetMageSellTime()
	{
		return m_strMageSellTime;
	}

	public void SetMageSellTime(string str)
	{
		m_strMageSellTime = str;
	}

	protected static void InitTask(ref Task[] tasks_imp)
	{
		for (int i = 0; i < MaxTaskNumber; i++)
		{
			tasks_imp[i].task_id = i;
			switch (i)
			{
			case 5:
				tasks_imp[i].branch_number = 14;
				break;
			case 25:
				tasks_imp[i].branch_number = 4;
				break;
			default:
				tasks_imp[i].branch_number = 1;
				break;
			}
			tasks_imp[i].task_branch = new float[tasks_imp[i].branch_number];
		}
	}

	protected void InitPropProperty()
	{
		List<Crazy_PropItem> skillItems = Crazy_PropItem.GetSkillItems();
		Crazy_PropItem crazy_PropItem = null;
		int count = skillItems.Count;
		int value = 3;
		propProperty.Clear();
		for (int i = 0; i < count; i++)
		{
			crazy_PropItem = skillItems[i];
			propProperty.Add(crazy_PropItem.m_nPropID, value);
			value = 0;
		}
	}

	protected void Reset(int num)
	{
		m_version = CurrentVersion;
		m_money = 0;
		m_weapon = new bool[num];
		for (int i = 0; i < num; i++)
		{
			m_weapon[i] = false;
		}
		m_weapon[0] = true;
		m_weapon[Version1100_NewWeaponId] = true;
		m_weapon[Version2500_NewHeroWeaponId] = true;
		m_bShowPropPanel = false;
		InitPropProperty();
		m_boss_level = 1;
		m_class = Crazy_PlayerClass.Knight;
		m_class_data = new Dictionary<Crazy_PlayerClass, ClassData>();
		ClassData classData = new ClassData(1, 0, 0);
		classData.m_unlock = true;
		m_class_data.Add(Crazy_PlayerClass.Knight, classData);
		classData = new ClassData(10, 0, 2);
		m_class_data.Add(Crazy_PlayerClass.Fighter, classData);
		classData = new ClassData(15, 0, 1);
		m_class_data.Add(Crazy_PlayerClass.Warrior, classData);
		classData = new ClassData(Version1100_NewHeroLevel, 0, Version1100_NewHeroWeaponId);
		m_class_data.Add(Crazy_PlayerClass.Rogue, classData);
		classData = new ClassData(Version2100_NewHeroLevel, 0, Version2100_NewHeroWeaponId);
		m_class_data.Add(Crazy_PlayerClass.Paladin, classData);
		if (m_recommend_present)
		{
			classData.m_unlock = true;
		}
		classData = new ClassData(Version2500_NewHeroLevel, 0, Version2500_NewHeroWeaponId);
		m_class_data.Add(Crazy_PlayerClass.Mage, classData);
		m_gamecenter = new GameCenterData(0);
		m_process = 0;
		m_min_stage = 1;
		m_max_stage = 1;
		m_ismixmonster = false;
		m_doaction = false;
		m_weaponicon = false;
		if (m_recommend_present)
		{
			m_heroicon = true;
		}
		else
		{
			m_heroicon = false;
		}
		m_mapstory = false;
		m_isranged = false;
		m_isnet = false;
		m_netname = string.Empty;
	}

	public static Crazy_SaveData ResetData(Crazy_SaveData savedata)
	{
		savedata.Reset(MaxWeaponNumber);
		SaveData(savedata);
		return savedata;
	}

	public static Crazy_SaveData ReadData()
	{
		string path = Utils.SavePath() + "/Save.data";
		if (File.Exists(path))
		{
			return DeCodeData();
		}
		return new Crazy_SaveData(MaxWeaponNumber);
	}

	public static void SaveData(Crazy_SaveData savedata)
	{
		EnCodeData(savedata);
	}

	private static XmlElement AddElement(XmlDocument doc, XmlNode root, string elename, string attname, string data)
	{
		XmlElement xmlElement = doc.CreateElement(elename);
		xmlElement.SetAttribute(attname, data);
		root.AppendChild(xmlElement);
		return xmlElement;
	}

	public static void DeleteData()
	{
		string path = Utils.SavePath() + "/Save.data";
		if (File.Exists(path))
		{
			File.Delete(path);
		}
	}

	private static int CheckVersion(int version)
	{
		if (CurrentVersion > version)
		{
			return updateVersion(version);
		}
		return CurrentVersion;
	}

	private static int updateVersion(int version)
	{
		switch (version)
		{
		case 1000:
		case 1010:
			UpdateVersion1100 = true;
			UpdateVersion2000 = true;
			UpdateVersion2100 = true;
			UpdateVersion2200 = true;
			UpdateVersion2500 = true;
			break;
		case 1100:
			UpdateVersion2000 = true;
			UpdateVersion2100 = true;
			UpdateVersion2200 = true;
			UpdateVersion2500 = true;
			break;
		case 2000:
		case 2010:
			UpdateVersion2100 = true;
			UpdateVersion2200 = true;
			UpdateVersion2500 = true;
			break;
		case 2100:
		case 2110:
		case 2120:
			UpdateVersion2200 = true;
			UpdateVersion2500 = true;
			break;
		case 2200:
			UpdateVersion2500 = true;
			break;
		}
		return CurrentVersion;
	}

	private static List<string> GetElement(XmlNode node, string elename, string attname)
	{
		List<string> list = new List<string>();
		foreach (XmlNode childNode in node.ChildNodes)
		{
			if (elename == childNode.Name)
			{
				XmlElement xmlElement = (XmlElement)childNode;
				string item = xmlElement.GetAttribute(attname).Trim();
				list.Add(item);
			}
		}
		return list;
	}

	private static Crazy_SaveData DeCodeData()
	{
		Crazy_SaveData crazy_SaveData = new Crazy_SaveData();
		string path = Utils.SavePath() + "/Save.data";
		XmlDocument xmlDocument = new XmlDocument();
		FileStream fileStream = File.Open(path, FileMode.Open);
		BinaryReader binaryReader = new BinaryReader(fileStream);
		string text = binaryReader.ReadString();
		binaryReader.Close();
		fileStream.Close();
		try
		{
			string text2 = XXTEAUtils.Decrypt(text, XXTEAUtilsKey);
			if (text2 == null)
			{
				throw new Exception("XXTEA Failed");
			}
			xmlDocument.LoadXml(text2);
		}
		catch (Exception)
		{
			try
			{
				string text3 = Encrypt.Decode(text);
				if (text3 == null)
				{
					throw new Exception("Encrypt Failed");
				}
				xmlDocument.LoadXml(text3);
			}
			catch (Exception)
			{
				return new Crazy_SaveData(MaxWeaponNumber);
			}
		}
		XmlNode documentElement = xmlDocument.DocumentElement;
		crazy_SaveData.m_version = CheckVersion(int.Parse(GetElement(documentElement, "Version", "number")[0]));
		crazy_SaveData.m_money = int.Parse(GetElement(documentElement, "Money", "count")[0]);
		crazy_SaveData.m_crystal = int.Parse(GetElement(documentElement, "Crystal", "count")[0]);
		crazy_SaveData.m_boss_level = int.Parse(GetElement(documentElement, "BossLevel", "count")[0]);
		crazy_SaveData.m_class = (Crazy_PlayerClass)int.Parse(GetElement(documentElement, "Class", "type")[0]);
		crazy_SaveData.m_process = int.Parse(GetElement(documentElement, "Process", "current")[0]);
		crazy_SaveData.m_min_stage = int.Parse(GetElement(documentElement, "MinStage", "stage")[0]);
		crazy_SaveData.m_max_stage = int.Parse(GetElement(documentElement, "MaxStage", "stage")[0]);
		crazy_SaveData.m_ismixmonster = bool.Parse(GetElement(documentElement, "MixMonster", "bool")[0]);
		crazy_SaveData.m_doaction = bool.Parse(GetElement(documentElement, "DoAction", "bool")[0]);
		crazy_SaveData.m_weaponicon = bool.Parse(GetElement(documentElement, "WeaponIcon", "bool")[0]);
		crazy_SaveData.m_heroicon = bool.Parse(GetElement(documentElement, "HeroIcon", "bool")[0]);
		crazy_SaveData.m_mapstory = bool.Parse(GetElement(documentElement, "MapStory", "bool")[0]);
		List<string> element = GetElement(documentElement, "Present", "bool");
		if (element.Count == 0)
		{
			crazy_SaveData.m_present = ((!Crazy_Const.AMAZON_IAP_CONST) ? true : false);
		}
		else
		{
			crazy_SaveData.m_present = bool.Parse(element[0]);
		}
		List<string> element2 = GetElement(documentElement, "FirstVersion", "number");
		if (element2.Count == 0)
		{
			crazy_SaveData.m_first_version = crazy_SaveData.m_version;
		}
		else
		{
			crazy_SaveData.m_first_version = int.Parse(element2[0]);
		}
		List<string> element3 = GetElement(documentElement, "PlayTimes", "count");
		if (element3.Count == 0)
		{
			crazy_SaveData.m_play_times = 0;
		}
		else
		{
			crazy_SaveData.m_play_times = int.Parse(element3[0]);
		}
		List<string> element4 = GetElement(documentElement, "FirstLoginTime", "time");
		if (element4.Count == 0)
		{
			crazy_SaveData.m_first_logintime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_first_logintime = element4[0];
		}
		List<string> element5 = GetElement(documentElement, "LastLoginTime", "time");
		if (element5.Count == 0)
		{
			crazy_SaveData.m_strLastLoginTime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strLastLoginTime = element5[0];
		}
		List<string> element6 = GetElement(documentElement, "LastLeaveTime", "time");
		if (element6.Count == 0)
		{
			crazy_SaveData.m_strLastLeaveTime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strLastLeaveTime = element6[0];
		}
		List<string> element7 = GetElement(documentElement, "AllPlayTime", "time");
		if (element7.Count == 0)
		{
			crazy_SaveData.m_allplay_time = 0;
		}
		else
		{
			crazy_SaveData.m_allplay_time = int.Parse(element7[0]);
		}
		List<string> element8 = GetElement(documentElement, "TotalMoney", "count");
		if (element8.Count == 0)
		{
			crazy_SaveData.m_total_money = 0;
		}
		else
		{
			crazy_SaveData.m_total_money = int.Parse(element8[0]);
		}
		List<string> element9 = GetElement(documentElement, "Ranged", "bool");
		if (element9.Count == 0)
		{
			crazy_SaveData.m_isranged = false;
		}
		else
		{
			crazy_SaveData.m_isranged = bool.Parse(element9[0]);
		}
		List<string> element10 = GetElement(documentElement, "Net", "bool");
		if (element10.Count == 0)
		{
			crazy_SaveData.m_isnet = false;
		}
		else
		{
			crazy_SaveData.m_isnet = bool.Parse(element10[0]);
		}
		List<string> element11 = GetElement(documentElement, "NetName", "string");
		if (element11.Count == 0)
		{
			crazy_SaveData.m_netname = string.Empty;
		}
		else
		{
			crazy_SaveData.m_netname = element11[0];
		}
		List<string> element12 = GetElement(documentElement, "Recommend", "bool");
		if (element12.Count == 0)
		{
			crazy_SaveData.m_isrecommend = false;
		}
		else
		{
			crazy_SaveData.m_isrecommend = bool.Parse(element12[0]);
		}
		List<string> element13 = GetElement(documentElement, "RecommendPresent", "bool");
		if (element13.Count == 0)
		{
			crazy_SaveData.m_recommend_present = false;
		}
		else
		{
			crazy_SaveData.m_recommend_present = bool.Parse(element13[0]);
		}
		List<string> element14 = GetElement(documentElement, "Communicate", "bool");
		if (element14.Count == 0)
		{
			crazy_SaveData.m_iscommunicate = false;
		}
		else
		{
			crazy_SaveData.m_iscommunicate = bool.Parse(element14[0]);
		}
		List<string> element15 = GetElement(documentElement, "Notification", "bool");
		if (element15.Count == 0)
		{
			crazy_SaveData.m_bNotification = false;
		}
		else
		{
			crazy_SaveData.m_bNotification = bool.Parse(element15[0]);
		}
		List<string> element16 = GetElement(documentElement, "ShowPropPanel", "bool");
		if (element16.Count == 0)
		{
			crazy_SaveData.m_bShowPropPanel = false;
		}
		else
		{
			crazy_SaveData.m_bShowPropPanel = bool.Parse(element16[0]);
		}
		List<string> element17 = GetElement(documentElement, "LastProp", "id");
		if (element17.Count == 0)
		{
			crazy_SaveData.m_nLastProp = 1;
		}
		else
		{
			crazy_SaveData.m_nLastProp = int.Parse(element17[0]);
		}
		List<string> element18 = GetElement(documentElement, "UseNewbie", "bool");
		if (element18.Count == 0)
		{
			crazy_SaveData.m_bShowNewbiePack = true;
		}
		else
		{
			crazy_SaveData.m_bShowNewbiePack = bool.Parse(element18[0]);
		}
		List<string> element19 = GetElement(documentElement, "GetNewbiePack", "bool");
		if (element19.Count == 0)
		{
			crazy_SaveData.m_bGetNewbiePack = false;
		}
		else
		{
			crazy_SaveData.m_bGetNewbiePack = bool.Parse(element19[0]);
		}
		List<string> element20 = GetElement(documentElement, "UseDiscount", "bool");
		if (element20.Count == 0)
		{
			crazy_SaveData.m_bShowDiscount = true;
		}
		else
		{
			crazy_SaveData.m_bShowDiscount = bool.Parse(element20[0]);
		}
		List<string> element21 = GetElement(documentElement, "DiscountTime", "time");
		if (element21.Count == 0)
		{
			crazy_SaveData.m_strShowDiscountTime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strShowDiscountTime = element21[0];
		}
		List<string> element22 = GetElement(documentElement, "DiscountType", "type");
		if (element22.Count == 0)
		{
			crazy_SaveData.m_strDiscountType = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strDiscountType = element22[0];
		}
		List<string> element23 = GetElement(documentElement, "MageSellTime", "time");
		if (element23.Count == 0)
		{
			crazy_SaveData.m_strMageSellTime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strMageSellTime = element23[0];
		}
		List<string> element24 = GetElement(documentElement, "LastDailyAwardID", "id");
		if (element24.Count == 0)
		{
			crazy_SaveData.m_nLastDailyAwardID = 0;
		}
		else
		{
			crazy_SaveData.m_nLastDailyAwardID = int.Parse(element24[0]);
		}
		List<string> element25 = GetElement(documentElement, "LastDailyAwardTime", "time");
		if (element25.Count == 0)
		{
			crazy_SaveData.m_strLastDailyAwardTime = string.Empty;
		}
		else
		{
			crazy_SaveData.m_strLastDailyAwardTime = element25[0];
		}
		XmlNode previousSibling = documentElement.LastChild.PreviousSibling.PreviousSibling.PreviousSibling.PreviousSibling.PreviousSibling;
		List<string> element26 = GetElement(previousSibling, "Prop", "imp");
		if (element26.Count == 0)
		{
			crazy_SaveData.InitPropProperty();
		}
		else
		{
			foreach (XmlNode childNode in previousSibling.ChildNodes)
			{
				if ("Prop" == childNode.Name)
				{
					int key = int.Parse(GetElement(childNode, "id", "id")[0]);
					int value = int.Parse(GetElement(childNode, "count", "count")[0]);
					crazy_SaveData.propProperty[key] = value;
				}
			}
		}
		XmlNode previousSibling2 = documentElement.LastChild.PreviousSibling.PreviousSibling.PreviousSibling.PreviousSibling;
		List<string> element27 = GetElement(previousSibling2, "taskimp", "imp");
		crazy_SaveData.m_tasks_imp = new Task[MaxTaskNumber];
		if (element27.Count == 0)
		{
			Debug.LogWarning("SaveData Update To New Version!");
			InitTask(ref crazy_SaveData.m_tasks_imp);
		}
		else
		{
			foreach (XmlNode childNode2 in previousSibling2.ChildNodes)
			{
				if ("taskimp" == childNode2.Name)
				{
					int num = int.Parse(GetElement(childNode2, "id", "id")[0]);
					crazy_SaveData.m_tasks_imp[num].task_id = num;
					crazy_SaveData.m_tasks_imp[num].branch_number = int.Parse(GetElement(childNode2, "number", "number")[0]);
					crazy_SaveData.m_tasks_imp[num].task_branch = new float[crazy_SaveData.m_tasks_imp[num].branch_number];
					List<string> element28 = GetElement(childNode2, "branch", "branch");
					for (int i = 0; i < crazy_SaveData.m_tasks_imp[num].branch_number; i++)
					{
						crazy_SaveData.m_tasks_imp[num].task_branch[i] = float.Parse(element28[i]);
					}
				}
			}
		}
		XmlNode previousSibling3 = documentElement.LastChild.PreviousSibling.PreviousSibling.PreviousSibling;
		List<string> element29 = GetElement(previousSibling3, "Task", "percent");
		if (element29.Count == 0)
		{
			Debug.LogWarning("SaveData Update To New Version!");
		}
		crazy_SaveData.m_tasks = new float[MaxTaskNumber];
		for (int j = 0; j < MaxTaskNumber; j++)
		{
			if (j < element29.Count)
			{
				crazy_SaveData.m_tasks[j] = float.Parse(element29[j]);
			}
			else
			{
				crazy_SaveData.m_tasks[j] = 0f;
			}
		}
		XmlNode previousSibling4 = documentElement.LastChild.PreviousSibling.PreviousSibling;
		crazy_SaveData.m_gamecenter = new GameCenterData(0);
		crazy_SaveData.m_gamecenter.m_killnumber = int.Parse(GetElement(previousSibling4, "KillNumber", "count")[0]);
		XmlNode previousSibling5 = documentElement.LastChild.PreviousSibling;
		crazy_SaveData.m_class_data = new Dictionary<Crazy_PlayerClass, ClassData>();
		foreach (XmlNode childNode3 in previousSibling5.ChildNodes)
		{
			if ("Class" == childNode3.Name)
			{
				ClassData classData = new ClassData(int.Parse(GetElement(childNode3, "Level", "count")[0]), int.Parse(GetElement(childNode3, "Exp", "count")[0]), int.Parse(GetElement(childNode3, "WeaponId", "id")[0]));
				classData.m_unlock = bool.Parse(GetElement(childNode3, "Unlock", "bool")[0]);
				crazy_SaveData.m_class_data.Add((Crazy_PlayerClass)int.Parse(GetElement(childNode3, "Type", "type")[0]), classData);
			}
		}
		XmlNode lastChild = documentElement.LastChild;
		List<string> element30 = GetElement(lastChild, "Weapon", "use");
		crazy_SaveData.m_weapon = new bool[MaxWeaponNumber];
		for (int k = 0; k < MaxWeaponNumber; k++)
		{
			if (k < element30.Count)
			{
				crazy_SaveData.m_weapon[k] = bool.Parse(element30[k]);
			}
			else
			{
				crazy_SaveData.m_weapon[k] = false;
			}
		}
		if (UpdateVersion1100)
		{
			if (crazy_SaveData.m_process > Version1010_TotalProcess)
			{
				crazy_SaveData.m_process = -1;
			}
			Crazy_Process processInfo = Crazy_Process.GetProcessInfo(crazy_SaveData.m_process);
			if (processInfo == null || (processInfo != null && processInfo.seq > RangedProcessSeq))
			{
				crazy_SaveData.m_isranged = true;
			}
			crazy_SaveData.m_weapon[Version1100_NewWeaponId] = true;
			ClassData value2 = new ClassData(Version1100_NewHeroLevel, 0, Version1100_NewHeroWeaponId);
			crazy_SaveData.m_class_data.Add(Crazy_PlayerClass.Rogue, value2);
			UpdateVersion1100 = false;
		}
		if (UpdateVersion2000)
		{
			Crazy_Process processInfo2 = Crazy_Process.GetProcessInfo(crazy_SaveData.m_process);
			if (processInfo2 == null || (processInfo2 != null && processInfo2.seq > NetProcessSeq))
			{
				crazy_SaveData.m_isnet = true;
			}
			UpdateVersion2000 = false;
		}
		if (UpdateVersion2100)
		{
			ClassData value3 = new ClassData(Version2100_NewHeroLevel, 0, Version2100_NewHeroWeaponId);
			crazy_SaveData.m_class_data.Add(Crazy_PlayerClass.Paladin, value3);
			UpdateVersion2100 = false;
		}
		if (UpdateVersion2200)
		{
			Crazy_Process processInfo3 = Crazy_Process.GetProcessInfo(crazy_SaveData.m_process);
			if (processInfo3 == null || (processInfo3 != null && processInfo3.seq > ShowPropSeq))
			{
				crazy_SaveData.m_bShowPropPanel = true;
			}
			UpdateVersion2200 = false;
		}
		if (UpdateVersion2500)
		{
			crazy_SaveData.m_weapon[Version2500_NewHeroWeaponId] = true;
			ClassData value4 = new ClassData(Version2500_NewHeroLevel, 0, Version2500_NewHeroWeaponId);
			crazy_SaveData.m_class_data.Add(Crazy_PlayerClass.Mage, value4);
			UpdateVersion2500 = false;
		}
		return crazy_SaveData;
	}

	private static void EnCodeData(Crazy_SaveData savedata)
	{
		string path = Utils.SavePath() + "/Save.data";
		XmlDocument xmlDocument = new XmlDocument();
		XmlElement root = AddElement(xmlDocument, xmlDocument, "Config", "digest", "Crazy_Knight_Test SaveData");
		AddElement(xmlDocument, root, "Version", "number", savedata.m_version.ToString());
		AddElement(xmlDocument, root, "Money", "count", savedata.m_money.ToString());
		AddElement(xmlDocument, root, "Crystal", "count", savedata.m_crystal.ToString());
		AddElement(xmlDocument, root, "BossLevel", "count", savedata.m_boss_level.ToString());
		int @class = (int)savedata.m_class;
		AddElement(xmlDocument, root, "Class", "type", @class.ToString());
		AddElement(xmlDocument, root, "ClassExplain", "type", savedata.m_class.ToString());
		AddElement(xmlDocument, root, "Process", "current", savedata.m_process.ToString());
		AddElement(xmlDocument, root, "MinStage", "stage", savedata.m_min_stage.ToString());
		AddElement(xmlDocument, root, "MaxStage", "stage", savedata.m_max_stage.ToString());
		AddElement(xmlDocument, root, "MixMonster", "bool", savedata.m_ismixmonster.ToString());
		AddElement(xmlDocument, root, "DoAction", "bool", savedata.m_doaction.ToString());
		AddElement(xmlDocument, root, "WeaponIcon", "bool", savedata.m_weaponicon.ToString());
		AddElement(xmlDocument, root, "HeroIcon", "bool", savedata.m_heroicon.ToString());
		AddElement(xmlDocument, root, "MapStory", "bool", savedata.m_mapstory.ToString());
		AddElement(xmlDocument, root, "Present", "bool", savedata.m_present.ToString());
		AddElement(xmlDocument, root, "FirstVersion", "number", savedata.m_first_version.ToString());
		AddElement(xmlDocument, root, "PlayTimes", "count", savedata.m_play_times.ToString());
		AddElement(xmlDocument, root, "FirstLoginTime", "time", savedata.m_first_logintime.ToString());
		AddElement(xmlDocument, root, "LastLoginTime", "time", savedata.m_strLastLoginTime.ToString());
		AddElement(xmlDocument, root, "LastLeaveTime", "time", savedata.m_strLastLeaveTime.ToString());
		AddElement(xmlDocument, root, "AllPlayTime", "time", savedata.m_allplay_time.ToString());
		AddElement(xmlDocument, root, "TotalMoney", "count", savedata.m_total_money.ToString());
		AddElement(xmlDocument, root, "Ranged", "bool", savedata.m_isranged.ToString());
		AddElement(xmlDocument, root, "Net", "bool", savedata.m_isnet.ToString());
		AddElement(xmlDocument, root, "NetName", "string", savedata.m_netname.ToString());
		AddElement(xmlDocument, root, "Recommend", "bool", savedata.m_isrecommend.ToString());
		AddElement(xmlDocument, root, "RecommendPresent", "bool", savedata.m_recommend_present.ToString());
		AddElement(xmlDocument, root, "Communicate", "bool", savedata.m_iscommunicate.ToString());
		AddElement(xmlDocument, root, "Notification", "bool", savedata.m_bNotification.ToString());
		AddElement(xmlDocument, root, "ShowPropPanel", "bool", savedata.m_bShowPropPanel.ToString());
		AddElement(xmlDocument, root, "LastProp", "id", savedata.m_nLastProp.ToString());
		AddElement(xmlDocument, root, "UseNewbie", "bool", savedata.m_bShowNewbiePack.ToString());
		AddElement(xmlDocument, root, "GetNewbiePack", "bool", savedata.m_bGetNewbiePack.ToString());
		AddElement(xmlDocument, root, "UseDiscount", "bool", savedata.m_bShowDiscount.ToString());
		AddElement(xmlDocument, root, "DiscountTime", "time", savedata.m_strShowDiscountTime.ToString());
		AddElement(xmlDocument, root, "DiscountType", "type", savedata.m_strDiscountType.ToString());
		AddElement(xmlDocument, root, "MageSellTime", "time", savedata.m_strMageSellTime.ToString());
		AddElement(xmlDocument, root, "LastDailyAwardID", "id", savedata.m_nLastDailyAwardID.ToString());
		AddElement(xmlDocument, root, "LastDailyAwardTime", "time", savedata.m_strLastDailyAwardTime.ToString());
		XmlElement root2 = AddElement(xmlDocument, root, "PropProperty", "Property", "PropProperty Information");
		foreach (int key in savedata.propProperty.Keys)
		{
			XmlElement root3 = AddElement(xmlDocument, root2, "Prop", "imp", "PropCount");
			AddElement(xmlDocument, root3, "id", "id", key.ToString());
			AddElement(xmlDocument, root3, "count", "count", savedata.propProperty[key].ToString());
		}
		XmlElement root4 = AddElement(xmlDocument, root, "TaskImp", "taskimp", "TaskImp Information");
		Task[] tasks_imp = savedata.m_tasks_imp;
		for (int i = 0; i < tasks_imp.Length; i++)
		{
			Task task = tasks_imp[i];
			XmlElement root5 = AddElement(xmlDocument, root4, "taskimp", "imp", "impinfo");
			AddElement(xmlDocument, root5, "id", "id", task.task_id.ToString());
			AddElement(xmlDocument, root5, "number", "number", task.branch_number.ToString());
			for (int j = 0; j < task.branch_number; j++)
			{
				AddElement(xmlDocument, root5, "branch", "branch", task.task_branch[j].ToString());
			}
		}
		XmlElement root6 = AddElement(xmlDocument, root, "Task", "task", "Task Information");
		float[] tasks = savedata.m_tasks;
		for (int k = 0; k < tasks.Length; k++)
		{
			AddElement(xmlDocument, root6, "Task", "percent", tasks[k].ToString());
		}
		XmlElement root7 = AddElement(xmlDocument, root, "GameCenter", "gamecenter", "GameCenter Infomation");
		AddElement(xmlDocument, root7, "KillNumber", "count", savedata.m_gamecenter.m_killnumber.ToString());
		XmlElement root8 = AddElement(xmlDocument, root, "Classes", "explain", "Classes' Information");
		foreach (Crazy_PlayerClass key2 in savedata.m_class_data.Keys)
		{
			XmlElement root9 = AddElement(xmlDocument, root8, "Class", "explain", "Class' Information");
			int num = (int)key2;
			AddElement(xmlDocument, root9, "Type", "type", num.ToString());
			AddElement(xmlDocument, root9, "TypeExplain", "type", key2.ToString());
			AddElement(xmlDocument, root9, "Level", "count", savedata.m_class_data[key2].m_level.ToString());
			AddElement(xmlDocument, root9, "Exp", "count", savedata.m_class_data[key2].m_exp.ToString());
			AddElement(xmlDocument, root9, "Unlock", "bool", savedata.m_class_data[key2].m_unlock.ToString());
			AddElement(xmlDocument, root9, "WeaponId", "id", savedata.m_class_data[key2].m_weapon_id.ToString());
		}
		XmlElement root10 = AddElement(xmlDocument, root, "Weapons", "explain", "Weapons' Information");
		bool[] weapon = savedata.m_weapon;
		foreach (bool flag in weapon)
		{
			AddElement(xmlDocument, root10, "Weapon", "use", flag.ToString());
		}
		FileStream fileStream = File.Open(path, FileMode.Create);
		BinaryWriter binaryWriter = new BinaryWriter(fileStream);
		binaryWriter.Write(XXTEAUtils.Encrypt(xmlDocument.OuterXml, XXTEAUtilsKey));
		binaryWriter.Close();
		fileStream.Close();
	}
}
