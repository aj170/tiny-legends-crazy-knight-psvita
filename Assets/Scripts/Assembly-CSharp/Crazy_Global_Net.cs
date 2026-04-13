using System.Collections.Generic;
using TNetSdk;
using UnityEngine;

public class Crazy_Global_Net
{
	protected static int innermonsterid;

	public static bool IsRoomHost(TNetRoom room, int usid)
	{
		Debug.Log(string.Concat("RoomMaster:", room.RoomMaster, "RoomMasterID:", room.RoomMasterID));
		return usid == room.RoomMasterID;
	}

	public static PlayerSettingInfo GetUserVariable(TNetUser user)
	{
		if (user.GetVariable(TNetUserVarType.PlayerSetting) != null)
		{
			return NetworkClassToObject.PlayerSettingFromJsonObject(user.GetVariable(TNetUserVarType.PlayerSetting));
		}
		return null;
	}

	public static List<TNetUser> RoomAliveUserAsc(List<TNetUser> user, TNetRoom room)
	{
		List<TNetUser> list = new List<TNetUser>();
		foreach (TNetUser item in user)
		{
			if (GetUserVariable(item) != null && GetUserVariable(item).inroom && item.IsJoinedInRoom(room))
			{
				list.Add(item);
			}
		}
		list.Sort((TNetUser a, TNetUser b) => a.Id.CompareTo(b.Id));
		return list;
	}

	public static void SynchronizeMonsterId(int id)
	{
		innermonsterid = id;
	}

	public static int GetRandomMonsterId()
	{
		innermonsterid++;
		return innermonsterid;
	}
}
