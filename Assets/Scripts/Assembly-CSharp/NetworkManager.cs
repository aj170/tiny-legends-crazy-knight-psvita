using System;
using System.Collections;
using System.Collections.Generic;
using TNetSdk;
using UnityEngine;

public class NetworkManager : MonoBehaviour
{
	private static NetworkManager instance;

	public static NetworkManager Instance
	{
		get
		{
			if (instance == null)
			{
				instance = new GameObject("NetworkManager").AddComponent<NetworkManager>();
			}
			return instance;
		}
	}

	private void Awake()
	{
		try
		{
			Application.runInBackground = true;
			if (TNetManager.Connection == null)
			{
				OnConnectionLost(null);
			}
			else
			{
				SubscribeDelegates();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnConnectionLost(TNetEventData evt)
	{
		try
		{
			CGUI.Log("OnConnectionLost");
			TNetManager.ConnectionLost();
			FlurryPlugin.endTimedEvent("Fight_Online");
			Hashtable hashtable = new Hashtable();
			hashtable.Add("Reason", "RecieveServerMessage");
			FlurryPlugin.logEvent("Online_Disconnect", hashtable);
			Application.LoadLevel("CrazyConnectionLost");
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void Start()
	{
	}

	private void FixedUpdate()
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Update(Time.fixedDeltaTime);
			}
			else
			{
				OnConnectionLost(null);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void UnsubscribeDelegates()
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				CGUI.Log(GetType().ToString() + ":UnsubscribeDelegates");
				TNetManager.Connection.RemoveAllEventListeners();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void SubscribeDelegates()
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				CGUI.Log(GetType().ToString() + ":SubscribeDelegates");
				TNetManager.Connection.AddEventListener(TNetEventSystem.CONNECTION_KILLED, OnConnectionLost);
				TNetManager.Connection.AddEventListener(TNetEventSystem.CONNECTION_TIMEOUT, OnConnectionLost);
				TNetManager.Connection.AddEventListener(TNetEventSystem.REVERSE_HEART_WAITING, OnHeartWaiting);
				TNetManager.Connection.AddEventListener(TNetEventSystem.REVERSE_HEART_RENEW, OnHeartRenew);
				TNetManager.Connection.AddEventListener(TNetEventSystem.REVERSE_HEART_TIMEOUT, OnHeartTimeout);
				TNetManager.Connection.AddEventListener(TNetEventRoom.USER_VARIABLES_UPDATE, OnUserVariablesUpdate);
				TNetManager.Connection.AddEventListener(TNetEventRoom.USER_EXIT_ROOM, OnUserLeaveRoom);
				TNetManager.Connection.AddEventListener(TNetEventRoom.OBJECT_MESSAGE, OnObjectMessage);
				TNetManager.Connection.AddEventListener(TNetEventRoom.LOCK_STH, OnLock);
				TNetManager.Connection.AddEventListener(TNetEventRoom.ROOM_MASTER_CHANGE, OnHostChange);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnHeartWaiting(TNetEventData evt)
	{
		CGUI.Log("OnHeartWaiting");
	}

	public void OnHeartRenew(TNetEventData evt)
	{
		CGUI.Log("OnHeartRenew");
	}

	public void OnHeartTimeout(TNetEventData evt)
	{
		try
		{
			CGUI.Log("OnHeartTimeout");
			TNetManager.ConnectionLost();
			Hashtable hashtable = new Hashtable();
			hashtable.Add("Reason", "HeartTimeout");
			FlurryPlugin.logEvent("Online_Disconnect", hashtable);
			FlurryPlugin.endTimedEvent("Fight_Online");
			Application.LoadLevel("CrazyConnectionLost");
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void UpdateUserVariables(PlayerSettingInfo info)
	{
		try
		{
			SFSObject sFSObject = NetworkClassToObject.PlayerSettingToJsonObject(info);
			if (TNetManager.Connection != null)
			{
				CGUI.Log("UpdateUserVariables:PlayerSetting:" + sFSObject);
				TNetManager.Connection.Send(new SetUserVariableRequest(TNetUserVarType.PlayerSetting, sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnUserVariablesUpdate(TNetEventData evt)
	{
		try
		{
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			TNetUserVarType tNetUserVarType = (TNetUserVarType)(int)evt.data["key"];
			CGUI.Log("OnUserVariablesUpdate User:" + tNetUser.Name + " | key:" + tNetUserVarType);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnUserLeaveRoom(TNetEventData evt)
	{
		try
		{
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			CGUI.Log("OnUserLeaveRoom:" + tNetUser.Name);
			if (TNetManager.Connection != null)
			{
				if (tNetUser != TNetManager.Connection.Myself)
				{
					TNetRoom curRoom = TNetManager.Connection.CurRoom;
					NetworkPlayerManager.Instance.DeleteCopy(tNetUser);
				}
				else
				{
					UpdateUserVariables(new PlayerSettingInfo(Crazy_PlayerClass.None, -1, false, false, false));
					UnityEngine.Object.Destroy(this);
				}
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void ResetGlobalData()
	{
		try
		{
			Crazy_GlobalData_Net.Instance.Reset();
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnObjectMessage(TNetEventData evt)
	{
		try
		{
			SFSObject dt = (SFSObject)evt.data["message"];
			TNetUser sender = (TNetUser)evt.data["user"];
			HandleObjectMessage(sender, dt);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public bool IsAllRoomUserInGame()
	{
		try
		{
			if (TNetManager.Connection == null || TNetManager.Connection.CurRoom == null)
			{
				return false;
			}
			bool result = true;
			List<TNetUser> userList = TNetManager.Connection.CurRoom.UserList;
			foreach (TNetUser item in userList)
			{
				PlayerSettingInfo userVariable = Crazy_Global_Net.GetUserVariable(item);
				if (userVariable == null || !userVariable.ingame)
				{
					result = false;
				}
			}
			return result;
		}
		catch (Exception message)
		{
			Debug.Log(message);
			return false;
		}
	}

	public void SendLock(int id)
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				CGUI.Log("SendLockSthRequest:" + id);
				TNetManager.Connection.Send(new LockSthRequest(id.ToString()));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnLock(TNetEventData evt)
	{
		try
		{
			RoomLockResCmd.Result result = (RoomLockResCmd.Result)(int)evt.data["result"];
			string s = evt.data["key"].ToString();
			int success = ((result != 0) ? (-1) : 0);
			int id = int.Parse(s);
			HandleLock(success, id);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendGetItem(ItemInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.ItemToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 8);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendMonsterHurt(MonsterHurtInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.MonsterHurtToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 7);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendBossSkill(BossSkillInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.BossSkillToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 6);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendBossStatus(BossStatusInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.BossStatusToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 5);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendMonsterStatus(MonsterStatusInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.MonsterStatusToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 4);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendMonsterUpdate(MonsterUpdateInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.MonsterUpdateToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 1);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendStatus(PlayerStatusInfo info)
	{
		try
		{
			SFSObject val = NetworkClassToObject.PlayerStatusToJsonObject(info);
			SFSObject sFSObject = new SFSObject();
			sFSObject.PutSFSObject("param", val);
			sFSObject.PutInt("type", 3);
			if (TNetManager.Connection != null)
			{
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendLeave()
	{
		try
		{
			OnLeaveGameRoom();
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnLeaveGameRoom()
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				CGUI.Log("Send LeaveRoomRequest");
				TNetManager.Connection.Send(new LeaveRoomRequest());
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void SendTransform(NetworkTransform trans, string id)
	{
		try
		{
			if (TNetManager.Connection != null)
			{
				TransformInfo tfi = new TransformInfo(trans, TNetManager.Connection.TimeManager.NetworkTime, TNetManager.Connection.TimeManager.AveragePing, id);
				SFSObject val = NetworkClassToObject.TransformToJsonObject(tfi);
				SFSObject sFSObject = new SFSObject();
				sFSObject.PutSFSObject("param", val);
				sFSObject.PutInt("type", 0);
				TNetManager.Connection.Send(new BroadcastMessageRequest(sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleLock(int success, int id)
	{
		try
		{
			if (success == 0)
			{
				CGUI.Log("GetItemSuccess:" + id);
				if (TNetManager.Connection != null)
				{
					NetworkItemManager.Instance.GetItemSuccess(TNetManager.Connection.Myself, id);
				}
			}
			else
			{
				CGUI.Log("GetItemFailed:" + id);
				if (TNetManager.Connection != null)
				{
					NetworkItemManager.Instance.GetItemFailed(TNetManager.Connection.Myself, id);
				}
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnHostChange(TNetEventData evt)
	{
		try
		{
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			CGUI.Log("OnHostChange:" + tNetUser.Name);
			HandleHostChange(tNetUser);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleHostChange(TNetUser user)
	{
		try
		{
			if (TNetManager.Connection != null && user == TNetManager.Connection.Myself)
			{
				DoExtraHostAction();
				CGUI.Log("NewHost:" + TNetManager.Connection.Myself.Name);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandlePlayerStatus(TNetUser user, ISFSObject dt)
	{
		try
		{
			PlayerStatusInfo playerStatusInfo = NetworkClassToObject.PlayerStatusFromJsonObject(dt);
			if (playerStatusInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkPlayerManager.Instance.UpdateNetworkStatus(user, playerStatusInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleMonsterUpdate(TNetUser user, ISFSObject dt)
	{
		try
		{
			MonsterUpdateInfo monsterUpdateInfo = NetworkClassToObject.MonsterUpdateFromJsonObject(dt);
			if (monsterUpdateInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkMonsterManager.Instance.MonsterUpdate(monsterUpdateInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleMonsterStatus(TNetUser user, ISFSObject dt)
	{
		try
		{
			MonsterStatusInfo monsterStatusInfo = NetworkClassToObject.MonsterStatusFromJsonObject(dt);
			if (monsterStatusInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkMonsterManager.Instance.UpdateMonsterStatus(monsterStatusInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleBossStatus(TNetUser user, ISFSObject dt)
	{
		try
		{
			BossStatusInfo bossStatusInfo = NetworkClassToObject.BossStatusFromJsonObject(dt);
			if (bossStatusInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkMonsterManager.Instance.UpdateBossStatus(bossStatusInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleBossSkill(TNetUser user, ISFSObject dt)
	{
		try
		{
			BossSkillInfo bossSkillInfo = NetworkClassToObject.BossSkillFromJsonObject(dt);
			if (bossSkillInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkMonsterManager.Instance.UpdateBossSkill(bossSkillInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleMonsterHurt(TNetUser user, ISFSObject dt)
	{
		try
		{
			MonsterHurtInfo monsterHurtInfo = NetworkClassToObject.MonsterHurtFromJsonObject(dt);
			if (monsterHurtInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkMonsterManager.Instance.UpdateMonsterHurt(monsterHurtInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleGetItem(TNetUser user, ISFSObject dt)
	{
		try
		{
			ItemInfo itemInfo = NetworkClassToObject.ItemFromJsonObject(dt);
			if (itemInfo != null && TNetManager.Connection != null && user != TNetManager.Connection.Myself)
			{
				NetworkItemManager.Instance.UpdateGetItem(user, itemInfo);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleTransformSynchronize(TNetUser user, ISFSObject dt)
	{
		try
		{
			TransformInfo transformInfo = NetworkClassToObject.TransformFromJsonObject(dt);
			if (transformInfo == null || TNetManager.Connection == null || user == TNetManager.Connection.Myself)
			{
				return;
			}
			if (transformInfo.objectId == "this")
			{
				NetworkTransform trans = transformInfo.trans;
				if (!NetworkPlayerManager.Instance.ContainCopy(user))
				{
					NetworkPlayerManager.Instance.CreateCopy(user, Crazy_Global_Net.GetUserVariable(user));
				}
				NetworkPlayerManager.Instance.UpdateNetworkTrans(user, trans);
			}
			else
			{
				NetworkTransform trans2 = transformInfo.trans;
				NetworkMonsterManager.Instance.UpdateNetworkTrans(int.Parse(transformInfo.objectId), trans2);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void HandleObjectMessage(TNetUser sender, SFSObject dt)
	{
		try
		{
			ObjectMessageType @int = (ObjectMessageType)dt.GetInt("type");
			ISFSObject sFSObject = dt.GetSFSObject("param");
			switch (@int)
			{
			case ObjectMessageType.PlayerStatus:
				HandlePlayerStatus(sender, sFSObject);
				break;
			case ObjectMessageType.MonsterUpdate:
				HandleMonsterUpdate(sender, sFSObject);
				break;
			case ObjectMessageType.TransformSynchronize:
				HandleTransformSynchronize(sender, sFSObject);
				break;
			case ObjectMessageType.MonsterStatus:
				HandleMonsterStatus(sender, sFSObject);
				break;
			case ObjectMessageType.BossStatus:
				HandleBossStatus(sender, sFSObject);
				break;
			case ObjectMessageType.BossSkill:
				HandleBossSkill(sender, sFSObject);
				break;
			case ObjectMessageType.MonsterHurt:
				HandleMonsterHurt(sender, sFSObject);
				break;
			case ObjectMessageType.GetItem:
				HandleGetItem(sender, sFSObject);
				break;
			case ObjectMessageType.PlayerSetting:
				break;
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void Update()
	{
	}

	public int GetPlayerPosition()
	{
		try
		{
			if (TNetManager.Connection != null && TNetManager.Connection.CurRoom != null)
			{
				List<TNetUser> userList = TNetManager.Connection.CurRoom.UserList;
				List<TNetUser> list = Crazy_Global_Net.RoomAliveUserAsc(userList, TNetManager.Connection.CurRoom);
				for (int i = 0; i < list.Count; i++)
				{
					if (list[i] == TNetManager.Connection.Myself)
					{
						return i;
					}
				}
				return -1;
			}
			return -1;
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
		return -1;
	}

	public void DoExtraHostAction()
	{
		try
		{
			NetworkMonsterManager.Instance.GetController();
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnDestroy()
	{
		try
		{
			UnsubscribeDelegates();
			instance = null;
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnApplicationPause(bool pause)
	{
		try
		{
			if (pause)
			{
				TNetManager.ManualDisconnect();
				return;
			}
			TNetManager.ManualDisconnect();
			Hashtable hashtable = new Hashtable();
			hashtable.Add("Reason", "ManualDisconnect");
			FlurryPlugin.logEvent("Online_Disconnect", hashtable);
			FlurryPlugin.endTimedEvent("Fight_Online");
			Application.LoadLevel("CrazyConnectionLost");
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}
}
