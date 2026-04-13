using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using UnityEngine;

public class SFSServerVersion : MonoBehaviour
{
	public OnSFSServerVersion callback;

	public OnSFSServerVersionError callback_error;

	private static SFSServerVersion instance;

	public string SFSDomainServer = string.Empty;

	public int SFSDomainPort;

	public string SFSServer = string.Empty;

	public int SFSPort;

	public string TestSFSDomainServer = string.Empty;

	public int TestSFSDomainPort;

	public string TestSFSServer = string.Empty;

	public int TestSFSPort;

	private int Version = -1;

	//protected string url = "http://account.trinitigame.com/game/TLCK/TLCK_NewVersion_Android.bytes";
	protected string url = ServerX.configUrl;

	protected string key = "324516";

	public static SFSServerVersion Instance
	{
		get
		{
			if (instance == null)
			{
				instance = new GameObject("SFSServerVersion").AddComponent<SFSServerVersion>();
			}
			return instance;
		}
	}

	private void Awake()
	{
		instance = this;
		UnityEngine.Object.DontDestroyOnLoad(base.gameObject);
	}

	public void Initialize()
	{
		StartCoroutine(Init());
	}

	protected string ReadDataFile(string path)
	{
		string path2 = "Data/" + path;
		TextAsset textAsset = Resources.Load(path2) as TextAsset;
		return textAsset.text;
	}

	protected void WriteFile(string FileName, string WriteString)
	{
		FileStream fileStream = new FileStream(FileName, FileMode.Create, FileAccess.ReadWrite);
		StreamWriter streamWriter = new StreamWriter(fileStream);
		streamWriter.WriteLine(WriteString);
		streamWriter.Flush();
		streamWriter.Close();
		fileStream.Close();
	}

	protected void DeXml(string text)
	{
		XmlDocument xmlDocument = new XmlDocument();
		xmlDocument.LoadXml(text);
		XmlNode documentElement = xmlDocument.DocumentElement;
		Version = int.Parse(GetElement(documentElement, "Version", "ver")[0]);
		SFSDomainServer = GetElement(documentElement, "CurrentServer", "domainname")[0];
		SFSDomainPort = int.Parse(GetElement(documentElement, "CurrentServer", "port")[0]);
		SFSServer = GetElement(documentElement, "CurrentServer", "backip")[0];
		SFSPort = int.Parse(GetElement(documentElement, "CurrentServer", "backport")[0]);
		TestSFSDomainServer = GetElement(documentElement, "TestServer", "domainname")[0];
		TestSFSDomainPort = int.Parse(GetElement(documentElement, "TestServer", "port")[0]);
		TestSFSServer = GetElement(documentElement, "TestServer", "backip")[0];
		TestSFSPort = int.Parse(GetElement(documentElement, "TestServer", "backport")[0]);
	}

	private List<string> GetElement(XmlNode node, string elename, string attname)
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

	public void OMake()
	{
		string text = ReadDataFile("TLCK_Version");
		text = XXTEAUtils.Encrypt(text, key);
		string fileName = Utils.SavePath() + "/TLCK_NewVersion_Android.bytes";
		WriteFile(fileName, text);
		Debug.Log("TLCK_Version.bytes output is ok.");
	}

	protected IEnumerator Init()
	{
		Version = 1;
		try
		{
#if UNITY_STANDALONE && !UNITY_EDITOR
			string path = Application.dataPath + "/../online-config.txt";
#else
            string path = Path.Combine(Application.persistentDataPath, "online-config.txt");
#endif
            if (File.Exists(path))
            {
                if (ServerX.Parse(File.ReadAllText(path), ref SFSDomainServer, ref SFSDomainPort))
                {
                    callback(1);
                    yield break;
                }
            }
        }
		catch { }

        WWW www = new WWW(url);
        yield return www;
        if (www.error != null)
        {
            if (callback_error != null)
            {
                callback_error();
            }
            yield break;
        }
		if (ServerX.Parse(www.text, ref SFSDomainServer, ref SFSDomainPort)) callback(1);
		else callback_error();
        /*SFSServer = ServerX.serverIP;
		SFSPort = ServerX.serverPort;
        callback(1);*/
        /*
		WWW www = new WWW(url);
		yield return www;
		if (www.error != null)
		{
			if (callback_error != null)
			{
				callback_error();
			}
			yield break;
		}
		string text = www.text;
		try
		{
			text = XXTEAUtils.Decrypt(text, key);
			if (text == null)
			{
				throw new Exception("XXTEA Failed");
			}
			DeXml(text);
			if (Version == Crazy_Data.CurData().GetVersion())
			{
				if (callback != null)
				{
					callback(1);
				}
			}
			else if (Version < Crazy_Data.CurData().GetVersion())
			{
				if (callback != null)
				{
					callback(2);
				}
			}
			else if (callback != null)
			{
				callback(0);
			}
		}
		catch (Exception e)
		{
			Debug.Log(e);
			if (callback_error != null)
			{
				callback_error();
			}
		}*/
    }
}
