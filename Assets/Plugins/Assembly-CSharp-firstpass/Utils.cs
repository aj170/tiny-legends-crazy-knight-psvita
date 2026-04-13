using System;
using System.Globalization;
using System.IO;
using UnityEngine;

public class Utils
{
	private static string m_SavePath;

	static Utils()
	{
		string persistentDataPath = Application.persistentDataPath;
		//persistentDataPath += "/../Documents"; retards
		if (!Directory.Exists(persistentDataPath))
		{
			Directory.CreateDirectory(persistentDataPath);
		}
		m_SavePath = persistentDataPath;
	}

	public static bool CreateDocumentSubDir(string dirname)
	{
		string path = m_SavePath + "/" + dirname;
		if (!Directory.Exists(path))
		{
			Directory.CreateDirectory(path);
			return true;
		}
		return false;
	}

	public static void DeleteDocumentDir(string dirname)
	{
		string path = m_SavePath + "/" + dirname;
		if (Directory.Exists(path))
		{
			Directory.Delete(path, true);
		}
	}

	public static string SavePath()
	{
		return m_SavePath;
	}

	public static string GetTextAsset(string txt_name)
	{
		TextAsset textAsset = Resources.Load(txt_name) as TextAsset;
		if (null != textAsset)
		{
			return textAsset.text;
		}
		return string.Empty;
	}

	public static void FileSaveString(string name, string content)
	{
		string path = SavePath() + "/" + name;
		try
		{
			FileStream fileStream = new FileStream(path, FileMode.Create);
			StreamWriter streamWriter = new StreamWriter(fileStream);
			streamWriter.Write(content);
			streamWriter.Close();
			fileStream.Close();
		}
		catch
		{
		}
	}

	public static void FileGetString(string name, ref string content)
	{
		string path = SavePath() + "/" + name;
		if (!File.Exists(path))
		{
			return;
		}
		try
		{
			FileStream fileStream = new FileStream(path, FileMode.Open);
			StreamReader streamReader = new StreamReader(fileStream);
			content = streamReader.ReadToEnd();
			streamReader.Close();
			fileStream.Close();
		}
		catch
		{
		}
	}

	public static bool IsRetina()
	{
		return false;
	}

	public static bool ProbabilityIsRandomHit(float rate)
	{
		float num = UnityEngine.Random.Range(0f, 1f);
		float num2 = rate / 2f;
		float num3 = UnityEngine.Random.Range(num2, 1f - num2);
		if (num3 - num2 < num && num < num3 + num2)
		{
			return true;
		}
		return false;
	}

	public static bool IsChineseLetter(string input)
	{
		for (int i = 0; i < input.Length; i++)
		{
			int num = Convert.ToInt32(Convert.ToChar(input.Substring(i, 1)));
			if (num >= 128)
			{
				return true;
			}
		}
		return false;
	}

	public static string PhotoKey()
	{
		return DateTime.Now.ToString("yyyyMMddHHmmssfff", DateTimeFormatInfo.InvariantInfo) + UnityEngine.Random.Range(1, 10000);
	}

	public static void AvataTakeTempPhoto()
	{
		string filename = "TempPhoto.png";
		ScreenCapture.CaptureScreenshot(filename);
	}
}
