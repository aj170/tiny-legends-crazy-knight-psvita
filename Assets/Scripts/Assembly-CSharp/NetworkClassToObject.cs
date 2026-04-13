using System;
using TNetSdk;
using UnityEngine;

public class NetworkClassToObject
{
	public static SFSObject RoomSettingToJsonObject(RoomSettingInfo roomSet)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddInt(roomSet.m_sceneID);
		sFSArray.AddInt(roomSet.m_boosID);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static RoomSettingInfo RoomSettingFromJsonObject(ISFSObject obj)
	{
		try
		{
			RoomSettingInfo roomSettingInfo = new RoomSettingInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			roomSettingInfo.m_sceneID = sFSArray.GetInt(0);
			roomSettingInfo.m_boosID = sFSArray.GetInt(1);
			return roomSettingInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject PlayerSettingToJsonObject(PlayerSettingInfo psi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddInt((int)psi.cpc);
		sFSArray.AddInt(psi.weapon);
		sFSArray.AddBool(psi.ingame);
		sFSArray.AddBool(psi.inroom);
		sFSArray.AddBool(psi.isprepare);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static PlayerSettingInfo PlayerSettingFromJsonObject(ISFSObject obj)
	{
		try
		{
			PlayerSettingInfo playerSettingInfo = new PlayerSettingInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			playerSettingInfo.cpc = (Crazy_PlayerClass)sFSArray.GetInt(0);
			playerSettingInfo.weapon = sFSArray.GetInt(1);
			playerSettingInfo.ingame = sFSArray.GetBool(2);
			playerSettingInfo.inroom = sFSArray.GetBool(3);
			playerSettingInfo.isprepare = sFSArray.GetBool(4);
			return playerSettingInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject PlayerStatusToJsonObject(PlayerStatusInfo psi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddInt((int)psi.status);
		sFSArray.AddUtfString(psi.attackname);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static PlayerStatusInfo PlayerStatusFromJsonObject(ISFSObject obj)
	{
		try
		{
			PlayerStatusInfo playerStatusInfo = new PlayerStatusInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			playerStatusInfo.status = (Crazy_PlayerStatus)sFSArray.GetInt(0);
			playerStatusInfo.attackname = sFSArray.GetUtfString(1);
			return playerStatusInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject MonsterUpdateToJsonObject(MonsterUpdateInfo mui)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddInt(mui.monstertemplateid);
		sFSArray.AddInt(mui.monsterid);
		sFSArray.AddFloat(mui.seed);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static MonsterUpdateInfo MonsterUpdateFromJsonObject(ISFSObject obj)
	{
		try
		{
			MonsterUpdateInfo monsterUpdateInfo = new MonsterUpdateInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			monsterUpdateInfo.monstertemplateid = sFSArray.GetInt(0);
			monsterUpdateInfo.monsterid = sFSArray.GetInt(1);
			monsterUpdateInfo.seed = sFSArray.GetFloat(2);
			return monsterUpdateInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject TransformToJsonObject(TransformInfo tfi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray val = tfi.trans.ToSFSArray();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddUtfString(tfi.objectId);
		sFSArray.AddSFSArray(val);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static TransformInfo TransformFromJsonObject(ISFSObject obj)
	{
		try
		{
			TransformInfo transformInfo = new TransformInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			transformInfo.objectId = sFSArray.GetUtfString(0);
			transformInfo.trans = NetworkTransform.FromSFSArray(sFSArray.GetSFSArray(1));
			return transformInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject MonsterStatusToJsonObject(MonsterStatusInfo msi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddUtfString(msi.objectid);
		sFSArray.AddInt((int)msi.status);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static MonsterStatusInfo MonsterStatusFromJsonObject(ISFSObject obj)
	{
		try
		{
			MonsterStatusInfo monsterStatusInfo = new MonsterStatusInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			monsterStatusInfo.objectid = sFSArray.GetUtfString(0);
			monsterStatusInfo.status = (Crazy_MonsterStatus)sFSArray.GetInt(1);
			return monsterStatusInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject BossStatusToJsonObject(BossStatusInfo bsi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddUtfString(bsi.objectid);
		sFSArray.AddInt(bsi.status);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static BossStatusInfo BossStatusFromJsonObject(ISFSObject obj)
	{
		try
		{
			BossStatusInfo bossStatusInfo = new BossStatusInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			bossStatusInfo.objectid = sFSArray.GetUtfString(0);
			bossStatusInfo.status = sFSArray.GetInt(1);
			return bossStatusInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject BossSkillToJsonObject(BossSkillInfo bsi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddUtfString(bsi.objectid);
		sFSArray.AddInt(bsi.skillid);
		sFSArray.AddFloat(bsi.seed);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static BossSkillInfo BossSkillFromJsonObject(ISFSObject obj)
	{
		try
		{
			BossSkillInfo bossSkillInfo = new BossSkillInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			bossSkillInfo.objectid = sFSArray.GetUtfString(0);
			bossSkillInfo.skillid = sFSArray.GetInt(1);
			bossSkillInfo.seed = sFSArray.GetFloat(2);
			return bossSkillInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject MonsterHurtToJsonObject(MonsterHurtInfo mhi)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddUtfString(mhi.objectid);
		sFSArray.AddFloat(mhi.damage);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static MonsterHurtInfo MonsterHurtFromJsonObject(ISFSObject obj)
	{
		try
		{
			MonsterHurtInfo monsterHurtInfo = new MonsterHurtInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			monsterHurtInfo.objectid = sFSArray.GetUtfString(0);
			monsterHurtInfo.damage = sFSArray.GetFloat(1);
			return monsterHurtInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}

	public static SFSObject ItemToJsonObject(ItemInfo ii)
	{
		SFSObject sFSObject = new SFSObject();
		SFSArray sFSArray = new SFSArray();
		sFSArray.AddInt(ii.id);
		sFSObject.PutSFSArray("D", sFSArray);
		return sFSObject;
	}

	public static ItemInfo ItemFromJsonObject(ISFSObject obj)
	{
		try
		{
			ItemInfo itemInfo = new ItemInfo();
			ISFSArray sFSArray = obj.GetSFSArray("D");
			itemInfo.id = sFSArray.GetInt(0);
			return itemInfo;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return null;
		}
	}
}
