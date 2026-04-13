using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using LitJson;
using UnityEngine;

public class Crazy_DataCollection
{
	private static Crazy_DataCollection s_instance;

	public int jailbreak;

	public string firstlogindata;

	public int totalTime;

	public int dayTotalTime;

	public int dayPlayTime;

	public int lastLevel;

	public int p1lastLevel;

	public int p2lastLevel;

	public int p3lastLevel;

	public int task;

	public int totalMoney;

	public int nowMoney;

	public int dayGetMoney;

	public int dayUsedMoney;

	public int DailyTCTimes;

	public int DailyTCNum;

	public Dictionary<string, int> equipUsedInfos;

	public int dayUI1Count;

	public int dayUI2Count;

	public int dayUI3Count;

	public int dayUI4Count;

	public int dayUI5Count;

	public int dayUI6Count;

	public int lastUi;

	public int fightNum;

	public int succNum;

	public int dayPlayLongTime;

	public int dayPlayShortTime;

	public int dayPlayAvgTime;

	public string deviceid;

	public string createdate;

	public string gamename;

	private string url = "http://account.trinitigame.com/gameapi/turboPlatform2.do?action=logAllInfo";

	private Dictionary<int, string> currentSendingTask = new Dictionary<int, string>();

	public string currentDate = string.Empty;

	private List<string> collections;

	private List<string> cur_data;

	public static Crazy_DataCollection Instance()
	{
		if (s_instance == null)
		{
			s_instance = new Crazy_DataCollection();
		}
		return s_instance;
	}

	public static void DeleteInstance()
	{
		if (s_instance != null)
		{
			s_instance = null;
		}
	}

	private Hashtable CreateCollectionDataMap()
	{
		Hashtable hashtable = new Hashtable();
		hashtable.Add("jailbreak", jailbreak.ToString());
		hashtable.Add("firstlogindata", firstlogindata);
		hashtable.Add("totalTime", totalTime);
		hashtable.Add("dayTotalTime", dayTotalTime);
		hashtable.Add("dayPlayTime", dayPlayTime);
		hashtable.Add("lastLevel", lastLevel);
		hashtable.Add("p1lastLevel", p1lastLevel);
		hashtable.Add("p2lastLevel", p2lastLevel);
		hashtable.Add("p3lastLevel", p3lastLevel);
		hashtable.Add("task", task);
		hashtable.Add("totalMoney", totalMoney);
		hashtable.Add("nowMoney", nowMoney);
		hashtable.Add("dayGetMoney", dayGetMoney);
		hashtable.Add("dayUsedMoney", dayUsedMoney);
		hashtable.Add("DailyTCTimes", DailyTCTimes);
		hashtable.Add("DailyTCNum", DailyTCNum);
		Hashtable hashtable2 = new Hashtable();
		foreach (string key in equipUsedInfos.Keys)
		{
			hashtable2.Add(key, equipUsedInfos[key]);
		}
		string value = JsonMapper.ToJson(hashtable2);
		hashtable.Add("equipUsedInfos", value);
		hashtable.Add("dayUI1Count", dayUI1Count);
		hashtable.Add("dayUI2Count", dayUI2Count);
		hashtable.Add("dayUI3Count", dayUI3Count);
		hashtable.Add("dayUI4Count", dayUI4Count);
		hashtable.Add("dayUI5Count", dayUI5Count);
		hashtable.Add("dayUI6Count", dayUI6Count);
		hashtable.Add("lastUi", lastUi);
		hashtable.Add("fightNum", fightNum);
		hashtable.Add("succNum", succNum);
		hashtable.Add("dayPlayLongTime", dayPlayLongTime);
		hashtable.Add("dayPlayShortTime", dayPlayShortTime);
		hashtable.Add("dayPlayAvgTime", dayPlayAvgTime);
		hashtable.Add("deviceid", deviceid);
		hashtable.Add("createdate", createdate);
		hashtable.Add("gamename", gamename);
		return hashtable;
	}

	public void SentData()
	{
		if (!currentSendingTask.ContainsValue(currentDate))
		{
			Debug.LogWarning("Senting Data : " + currentDate);
			string value = JsonMapper.ToJson(CreateCollectionDataMap());
			Hashtable hashtable = new Hashtable();
			hashtable["gamename"] = "tlck";
			hashtable["data"] = value;
			string request = JsonMapper.ToJson(hashtable);
			int key = HttpManager.Instance().SendRequest(url, request, currentDate, 15f, OnResponse, OnRequestTimeout);
			currentSendingTask.Add(key, currentDate);
		}
	}

	private void OnResponse(int task_id, string param, int code, string response)
	{
		Debug.LogWarning("OnResponse code : " + code + " &  param : " + param);
		if (param != null && param != string.Empty)
		{
			currentSendingTask.Remove(task_id);
			RemoveCollections(param);
		}
	}

	private void OnRequestTimeout(int task_id, string param)
	{
		Debug.LogWarning("OnRequestTimeout");
	}

	private void InitData()
	{
		jailbreak = (OtherPlugin.IsJailBreak() ? 1 : 0);
		firstlogindata = Crazy_Data.CurData().GetFirstLoginTime();
		totalTime = Crazy_Data.CurData().GetAllPlayTime();
		dayTotalTime = 0;
		dayPlayTime = 1;
		lastLevel = Crazy_Data.CurData().GetLevel();
		p1lastLevel = Crazy_Data.CurData().GetLevel(Crazy_PlayerClass.Knight);
		p2lastLevel = Crazy_Data.CurData().GetLevel(Crazy_PlayerClass.Fighter);
		p3lastLevel = Crazy_Data.CurData().GetLevel(Crazy_PlayerClass.Warrior);
		task = Crazy_Data.CurData().GetProcess();
		totalMoney = Crazy_Data.CurData().GetTotalMoney();
		nowMoney = Crazy_Data.CurData().GetMoney();
		dayGetMoney = 0;
		dayUsedMoney = 0;
		DailyTCTimes = 0;
		DailyTCNum = 0;
		equipUsedInfos = new Dictionary<string, int>();
		bool[] weapon = Crazy_Data.CurData().GetWeapon();
		List<Crazy_Weapon> list = Crazy_Weapon.ReadWeaponInfo();
		foreach (Crazy_Weapon item in list)
		{
			equipUsedInfos.Add(item.dcid, weapon[item.id] ? 1 : 0);
		}
		dayUI1Count = 0;
		dayUI2Count = 0;
		dayUI3Count = 0;
		dayUI4Count = 0;
		dayUI5Count = 0;
		dayUI6Count = 0;
		lastUi = 0;
		fightNum = 0;
		succNum = 0;
		dayPlayLongTime = 0;
		dayPlayShortTime = -1;
		dayPlayAvgTime = 0;
		deviceid = OtherPlugin.GetMacAddr();
		createdate = Crazy_Global.GetCurSystemData();
		gamename = "TLCK";
	}

	public void Initialize(string str)
	{
		InitData();
		EnCodeDataCollection();
		currentDate = str;
		AddCollections(str);
	}

	public List<string> GetCollections()
	{
		return collections;
	}

	private void AddCollections(string str)
	{
		if (collections == null)
		{
			collections = new List<string>();
		}
		collections.Add(str);
		SaveCurDataCollection(str);
		SavePlayerData("Collection");
	}

	private void RemoveCollections(string str)
	{
		if (collections != null)
		{
			collections.Remove(str);
			RemoveCurDataCollection(str);
			SavePlayerData("Collection");
		}
	}

	public void LoadPlayerData(string path)
	{
		string text = Utils.SavePath() + "/" + path + ".data";
		if (File.Exists(text))
		{
			collections = DeCodeData(text);
		}
	}

	private void RemoveCurDataCollection(string path)
	{
		string path2 = Utils.SavePath() + "/" + path + ".data";
		if (File.Exists(path2))
		{
			File.Delete(path2);
		}
	}

	public void SavePlayerData(string path)
	{
		string filename = Utils.SavePath() + "/" + path + ".data";
		EnCodeData(filename, collections);
	}

	public void LoadCurDataCollection(string path)
	{
		string text = Utils.SavePath() + "/" + path + ".data";
		if (File.Exists(text))
		{
			cur_data = DeCodeData(text);
			currentDate = path;
		}
	}

	public void SaveCurDataCollection(string path)
	{
		string filename = Utils.SavePath() + "/" + path + ".data";
		EnCodeData(filename, cur_data);
	}

	public void EnCodeDataCollection()
	{
		cur_data = new List<string>();
		cur_data.Add(jailbreak.ToString());
		cur_data.Add(firstlogindata);
		cur_data.Add(totalTime.ToString());
		cur_data.Add(dayTotalTime.ToString());
		cur_data.Add(dayPlayTime.ToString());
		cur_data.Add(lastLevel.ToString());
		cur_data.Add(p1lastLevel.ToString());
		cur_data.Add(p2lastLevel.ToString());
		cur_data.Add(p3lastLevel.ToString());
		cur_data.Add(task.ToString());
		cur_data.Add(totalMoney.ToString());
		cur_data.Add(nowMoney.ToString());
		cur_data.Add(dayGetMoney.ToString());
		cur_data.Add(dayUsedMoney.ToString());
		cur_data.Add(DailyTCTimes.ToString());
		cur_data.Add(DailyTCNum.ToString());
		string text = string.Empty;
		foreach (string key in equipUsedInfos.Keys)
		{
			string text2 = key + "&" + equipUsedInfos[key] + "|";
			text += text2;
		}
		cur_data.Add(text);
		cur_data.Add(dayUI1Count.ToString());
		cur_data.Add(dayUI2Count.ToString());
		cur_data.Add(dayUI3Count.ToString());
		cur_data.Add(dayUI4Count.ToString());
		cur_data.Add(dayUI5Count.ToString());
		cur_data.Add(dayUI6Count.ToString());
		cur_data.Add(lastUi.ToString());
		cur_data.Add(fightNum.ToString());
		cur_data.Add(succNum.ToString());
		cur_data.Add(dayPlayLongTime.ToString());
		cur_data.Add(dayPlayShortTime.ToString());
		cur_data.Add(dayPlayAvgTime.ToString());
		cur_data.Add(deviceid);
		cur_data.Add(createdate);
		cur_data.Add(gamename);
	}

	public bool DeCodeDataCollection()
	{
		if (cur_data == null || cur_data.Count != 32)
		{
			return false;
		}
		jailbreak = int.Parse(cur_data[0]);
		firstlogindata = cur_data[1];
		totalTime = int.Parse(cur_data[2]);
		dayTotalTime = int.Parse(cur_data[3]);
		dayPlayTime = int.Parse(cur_data[4]);
		lastLevel = int.Parse(cur_data[5]);
		p1lastLevel = int.Parse(cur_data[6]);
		p2lastLevel = int.Parse(cur_data[7]);
		p3lastLevel = int.Parse(cur_data[8]);
		task = int.Parse(cur_data[9]);
		totalMoney = int.Parse(cur_data[10]);
		nowMoney = int.Parse(cur_data[11]);
		dayGetMoney = int.Parse(cur_data[12]);
		dayUsedMoney = int.Parse(cur_data[13]);
		DailyTCTimes = int.Parse(cur_data[14]);
		DailyTCNum = int.Parse(cur_data[15]);
		string text = cur_data[16];
		equipUsedInfos = new Dictionary<string, int>();
		string[] array = text.Split("|".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
		string[] array2 = array;
		foreach (string text2 in array2)
		{
			string[] array3 = text2.Split("&".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
			equipUsedInfos.Add(array3[0], int.Parse(array3[1]));
		}
		dayUI1Count = int.Parse(cur_data[17]);
		dayUI2Count = int.Parse(cur_data[18]);
		dayUI3Count = int.Parse(cur_data[19]);
		dayUI4Count = int.Parse(cur_data[20]);
		dayUI5Count = int.Parse(cur_data[21]);
		dayUI6Count = int.Parse(cur_data[22]);
		lastUi = int.Parse(cur_data[23]);
		fightNum = int.Parse(cur_data[24]);
		succNum = int.Parse(cur_data[25]);
		dayPlayLongTime = int.Parse(cur_data[26]);
		dayPlayShortTime = int.Parse(cur_data[27]);
		dayPlayAvgTime = int.Parse(cur_data[28]);
		deviceid = cur_data[29];
		createdate = cur_data[30];
		gamename = cur_data[31];
		return true;
	}

	private void EnCodeData(string filename, List<string> data)
	{
		XmlDocument xmlDocument = new XmlDocument();
		XmlElement root = AddElement(xmlDocument, xmlDocument, "Config", "Digest", "Data");
		foreach (string datum in data)
		{
			AddElement(xmlDocument, root, "Data", "string", datum);
		}
		FileStream fileStream = File.Open(filename, FileMode.Create);
		BinaryWriter binaryWriter = new BinaryWriter(fileStream);
		binaryWriter.Write(XXTEAUtils.Encrypt(xmlDocument.OuterXml, Crazy_SaveData.XXTEAUtilsKey));
		binaryWriter.Close();
		fileStream.Close();
	}

	private List<string> DeCodeData(string filename)
	{
		List<string> list = new List<string>();
		XmlDocument xmlDocument = new XmlDocument();
		FileStream fileStream = File.Open(filename, FileMode.Open);
		BinaryReader binaryReader = new BinaryReader(fileStream);
		string text = binaryReader.ReadString();
		binaryReader.Close();
		fileStream.Close();
		try
		{
			string text2 = XXTEAUtils.Decrypt(text, Crazy_SaveData.XXTEAUtilsKey);
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
				if (File.Exists(filename))
				{
					File.Delete(filename);
				}
				return null;
			}
		}
		XmlNode documentElement = xmlDocument.DocumentElement;
		foreach (XmlNode childNode in documentElement.ChildNodes)
		{
			if ("Data" == childNode.Name)
			{
				XmlElement xmlElement = (XmlElement)childNode;
				string item = xmlElement.GetAttribute("string").Trim();
				list.Add(item);
			}
		}
		if (list.Count == 0)
		{
			return null;
		}
		return list;
	}

	private XmlElement AddElement(XmlDocument doc, XmlNode root, string elename, string attname, string data)
	{
		XmlElement xmlElement = doc.CreateElement(elename);
		xmlElement.SetAttribute(attname, data);
		root.AppendChild(xmlElement);
		return xmlElement;
	}
}
