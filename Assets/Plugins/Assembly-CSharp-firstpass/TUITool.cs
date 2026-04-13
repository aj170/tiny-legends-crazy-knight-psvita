using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

public static class TUITool
{
	public static string GetHierarchy(GameObject obj)
	{
		string text = obj.name;
		while (obj.transform.parent != null)
		{
			obj = obj.transform.parent.gameObject;
			text = obj.name + "/" + text;
		}
		return "\"" + text + "\"";
	}

	public static void AmendFieldNullString(object obj)
	{
		Type type = obj.GetType();
		List<FieldInfo> list = new List<FieldInfo>(type.GetFields());
		list.AddRange(type.GetFields(BindingFlags.Instance | BindingFlags.NonPublic));
		foreach (FieldInfo item in list)
		{
			if (item.FieldType == typeof(string) && item.GetValue(obj) == null)
			{
				item.SetValue(obj, string.Empty);
			}
		}
	}

	public static int[] UintToNumberArray(uint value)
	{
		string text = value.ToString();
		int[] array = new int[text.Length];
		for (int i = 0; i < array.Length; i++)
		{
			array[i] = Convert.ToInt32(text[text.Length - 1 - i].ToString());
		}
		return array;
	}

	public static void ObjectFunctionInvoke(object obj, string functionName, params object[] @params)
	{
		try
		{
			MethodInfo method = obj.GetType().GetMethod(functionName, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
			method.Invoke(obj, @params);
		}
		catch (Exception ex)
		{
			Debug.LogWarning(ex.Message);
			Debug.LogWarning("functionName:" + functionName);
		}
	}
}
