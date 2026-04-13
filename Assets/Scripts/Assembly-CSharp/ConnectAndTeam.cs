using System;
using System.Collections;
using System.Collections.Generic;
using TNetSdk;
using UnityEngine;

public class ConnectAndTeam : MonoBehaviour
{
	private const int TEST_BASIC_GROUP_ID = 800;

	private const int BASIC_GROUP_ID = 1000;

	private const float MAX_WAIT_TIME = 5f;

	public NetBattleEventHandle m_EventHandle;

	private bool bNetBattleTest;

	private int nMaxHallid = 15;

	private int nCurrentHallid = 4;

	private bool bAscend = true;

	protected string serverName = "192.168.0.13";

	protected int serverPort = 9933;

	protected string zone = "TLCK";

	private int m_maxPlayerCount = 4;

	private string m_currentBossName;

	private bool bGameStart;

	private bool bLeavingRoom;

	private bool bRegroupTeam;

	private void FixedUpdate()
	{
		try
		{
			if (TNetManager.Instance != null && !bGameStart)
			{
				TNetManager.Instance.Update(Time.fixedDeltaTime);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	protected void RegisterTNetCallBacks()
	{
		if (TNetManager.Instance != null)
		{
			CGUI.Log(GetType().ToString() + ":RegisterTNetCallBacks");
			Debug.Log(GetType().ToString() + ":RegisterTNetCallBacks");
			TNetManager.Instance.AddEventListener(TNetEventSystem.CONNECTION, OnConnection);
			TNetManager.Instance.AddEventListener(TNetEventSystem.CONNECTION_TIMEOUT, OnConnectionLost);
			TNetManager.Instance.AddEventListener(TNetEventSystem.CONNECTION_KILLED, OnConnectionLost);
			TNetManager.Instance.AddEventListener(TNetEventSystem.LOGIN, OnLogin);
			TNetManager.Instance.AddEventListener(TNetEventSystem.REVERSE_HEART_WAITING, OnHeartWaiting);
			TNetManager.Instance.AddEventListener(TNetEventSystem.REVERSE_HEART_RENEW, OnHeartRenew);
			TNetManager.Instance.AddEventListener(TNetEventSystem.REVERSE_HEART_TIMEOUT, OnHeartTimeout);
			TNetManager.Instance.AddEventListener(TNetEventRoom.GET_ROOM_LIST, OnGetRoomList);
			TNetManager.Instance.AddEventListener(TNetEventRoom.ROOM_CREATION, OnCreateRoom);
			TNetManager.Instance.AddEventListener(TNetEventRoom.ROOM_JOIN, OnJoinRoom);
			TNetManager.Instance.AddEventListener(TNetEventRoom.ROOM_VARIABLES_UPDATE, OnRoomVariablesUpdate);
			TNetManager.Instance.AddEventListener(TNetEventRoom.USER_VARIABLES_UPDATE, OnUserVariablesUpdate);
			TNetManager.Instance.AddEventListener(TNetEventRoom.USER_ENTER_ROOM, OnUserEnterRoom);
			TNetManager.Instance.AddEventListener(TNetEventRoom.USER_EXIT_ROOM, OnLeaveRoom);
			TNetManager.Instance.AddEventListener(TNetEventRoom.ROOM_START, OnGameStart);
			TNetManager.Instance.AddEventListener(TNetEventRoom.ROOM_MASTER_CHANGE, OnHostChange);
		}
	}

	private void UnregisterTNetCallBacks()
	{
		try
		{
			if (TNetManager.Instance != null)
			{
				CGUI.Log(GetType().ToString() + ":UnregisterTNetCallBacks");
				TNetManager.Instance.RemoveAllEventListeners();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void Awake()
	{
		TNetManager.CreateTNetObject();
		Crazy_GlobalData_Net.Instance.Reset();
		Crazy_GlobalData.cur_leveltype = Crazy_LevelType.NetBoss;
		nMaxHallid = 1000 + Crazy_NetBattle.GetNetBattleInfoList().Count;
		nCurrentHallid = Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).hallid;
		if (nCurrentHallid == nMaxHallid)
		{
			bAscend = false;
		}
		Crazy_NetBattle netBattleInfo = Crazy_NetBattle.GetNetBattleInfo(nCurrentHallid);
		int index = UnityEngine.Random.Range(0, netBattleInfo.bossItems.Count);
		Crazy_GlobalData_Net.Instance.bossID = netBattleInfo.bossItems[index].bossid;
		CGUI.Log("Boss ID:" + netBattleInfo.bossItems[index].bossid);
		Crazy_GlobalData_Net.Instance.sceneID = netBattleInfo.bossItems[index].sceneid;
		m_maxPlayerCount = netBattleInfo.bossItems[index].maxcount;
		m_currentBossName = netBattleInfo.bossItems[index].bossname;
		if (m_EventHandle == null)
		{
			m_EventHandle = base.gameObject.AddComponent<NetBattleEventHandle>();
		}
	}

	private void OnEnable()
	{
	}

	private void Start()
	{
		FlurryPlugin.logEvent("Online_Connect", true);
		Application.runInBackground = true;
		if (Crazy_Global.CheckCheat())
		{
			Hashtable hashtable = new Hashtable();
			hashtable.Add("IsConnectSuccess", "NO");
			FlurryPlugin.endTimedEvent("Online_Connect", hashtable);
			Hashtable hashtable2 = new Hashtable();
			hashtable2.Add("Reason", "Cheat");
			FlurryPlugin.logEvent("Online_Disconnect", hashtable2);
			Application.LoadLevel("CrazyConnectionLost");
		}
		else
		{
			SFSServerVersion.Instance.callback = OnGetServerSuccess;
			SFSServerVersion.Instance.callback_error = OnGetServerFailed;
			SFSServerVersion.Instance.Initialize();
		}
	}

	private IEnumerator TotalWaitTime(int playerCount)
	{
		do
		{
			if (bGameStart)
			{
				yield break;
			}
			yield return new WaitForSeconds(5f);
			CGUI.Log("Wait Time:" + 5f + "---------player count:" + TNetManager.Instance.CurRoom.UserCount);
		}
		while (playerCount != TNetManager.Instance.CurRoom.UserCount);
		sendLeaveRoom();
		bRegroupTeam = true;
	}

	private void RegroupTeam()
	{
		if (bAscend)
		{
			nCurrentHallid++;
			if (nCurrentHallid >= nMaxHallid)
			{
				nCurrentHallid = nMaxHallid;
				bAscend = false;
			}
		}
		else
		{
			nCurrentHallid--;
			if (bNetBattleTest)
			{
				if (nCurrentHallid <= 1800)
				{
					nCurrentHallid = 1801;
					bAscend = true;
				}
			}
			else if (nCurrentHallid <= 1000)
			{
				nCurrentHallid = 1001;
				bAscend = true;
			}
		}
		sendGetRoomList(nCurrentHallid);
	}

	private void sendGameStart()
	{
		try
		{
			if (TNetManager.Instance != null)
			{
				CGUI.Log("SendGameStart:" + TNetManager.Instance.Myself.Name);
				TNetManager.Instance.Send(new RoomStartRequest());
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnGameStart(TNetEventData evt)
	{
		if (bLeavingRoom)
		{
			Debug.Log("OnRoomStartCancel");
			return;
		}
		try
		{
			int id = (ushort)evt.data["userId"];
			CGUI.Log("OnGameStart:" + TNetManager.Instance.CurRoom.GetUserById(id).Name);
			m_EventHandle.StartGame();
			m_EventHandle.UpdateConnectInfo("Start Battle...");
			bGameStart = true;
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnGetServerSuccess(int match)
	{
		CGUI.Log("GetServerSuccess");
		switch (match)
		{
		case 1:
			CGUI.Log("ServerMatch");
			serverName = SFSServerVersion.Instance.SFSDomainServer;
			serverPort = SFSServerVersion.Instance.SFSDomainPort;
			InitServer();
			bNetBattleTest = false;
			break;
		case 2:
			serverName = SFSServerVersion.Instance.TestSFSDomainServer;
			serverPort = SFSServerVersion.Instance.TestSFSDomainPort;
			InitServer();
			bNetBattleTest = true;
			nCurrentHallid += 800;
			nMaxHallid += 800;
			break;
		default:
		{
			Hashtable hashtable = new Hashtable();
			hashtable.Add("IsConnectSuccess", "NO");
			FlurryPlugin.endTimedEvent("Online_Connect", hashtable);
			CGUI.Log("Version Error");
			m_EventHandle.ShowVersionUpdate();
			m_EventHandle.UpdateConnectInfo("Update your game!");
			break;
		}
		}
	}

	public void OnGetServerFailed()
	{
		Hashtable hashtable = new Hashtable();
		hashtable.Add("IsConnectSuccess", "NO");
		FlurryPlugin.endTimedEvent("Online_Connect", hashtable);
		CGUI.Log("GetServerFailed");
		if (Application.internetReachability == NetworkReachability.NotReachable)
		{
			m_EventHandle.UpdateConnectInfo("You need to connect to a network to play this game.");
		}
		else
		{
			m_EventHandle.UpdateConnectInfo("Our server is down for maintenance. Please try again later.");
		}
	}

	private void InitServer()
	{
		// its already set on line 238

		/*serverName = TNetManager.Instance.GetHostAddresses(serverName);
		if (serverName == string.Empty)
		{
			if (bNetBattleTest)
			{
				serverName = SFSServerVersion.Instance.TestSFSServer;
				serverPort = SFSServerVersion.Instance.TestSFSPort;
			}
			else
			{
				serverName = SFSServerVersion.Instance.SFSServer;
				serverPort = SFSServerVersion.Instance.SFSPort;
			}
		}*/
		Debug.Log("domain to ip=====================" + serverName);
		TNetManager.Connect(serverName, serverPort);
		RegisterTNetCallBacks();
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
		CGUI.Log("OnHeartTimeout");
		TNetManager.ConnectionLost();
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Reason", "HeartTimeout");
		FlurryPlugin.logEvent("Online_Disconnect", hashtable);
		Application.LoadLevel("CrazyConnectionLost");
	}

	public void OnConnectionLost(TNetEventData evt)
	{
		CGUI.Log("OnConnectionLost");
		TNetManager.ConnectionLost();
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Reason", "RecieveServerMessage");
		FlurryPlugin.logEvent("Online_Disconnect", hashtable);
		Application.LoadLevel("CrazyConnectionLost");
	}

	public void OnConnection(TNetEventData evt)
	{
		m_EventHandle.UpdateConnectInfo("Connect Success");
		Hashtable hashtable = new Hashtable();
		hashtable.Add("IsConnectSuccess", "YES");
		FlurryPlugin.endTimedEvent("Online_Connect", hashtable);
		CGUI.Log("Connect Success");
		TNetManager.ConnectionSuccess();
		string netName = Crazy_Data.CurData().GetNetName();
		TNetManager.Login(netName);
	}

	public void OnLogin(TNetEventData evt)
	{
		if ((int)evt.data["result"] == 0)
		{
			TNetManager.LoginSuccess();
			CGUI.Log("LoginSuccess");
			sendGetRoomList(nCurrentHallid);
			return;
		}
		TNetManager.LoginFailed();
		CGUI.Log("LoginFailed");
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Reason", "LoginFailed");
		FlurryPlugin.logEvent("Online_Disconnect", hashtable);
		Application.LoadLevel("CrazyConnectionLost");
	}

	private void sendGetRoomList(int hallid)
	{
		FlurryPlugin.logEvent("Find_Game", true);
		if (TNetManager.Instance != null)
		{
			TNetManager.Instance.Send(new GetRoomListRequest(hallid, 0, 10, RoomDragListCmd.ListType.not_full_not_game));
		}
	}

	public void OnGetRoomList(TNetEventData evt)
	{
		try
		{
			List<TNetRoom> list = (List<TNetRoom>)evt.data["roomList"];
			if (list.Count == 0)
			{
				sendCreateRoom();
			}
			else
			{
				sendJoinRoom(list[0].Id, string.Empty);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void sendCreateRoom()
	{
		try
		{
			if (TNetManager.Instance != null)
			{
				string room_name = TNetManager.Instance.Myself.Name + "'s Room";
				TNetManager.Instance.Send(new CreateRoomRequest(room_name, string.Empty, nCurrentHallid, m_maxPlayerCount, RoomCreateCmd.RoomType.limit, RoomCreateCmd.RoomSwitchMasterType.Auto, string.Empty));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnCreateRoom(TNetEventData evt)
	{
		try
		{
			if ((int)evt.data["result"] == 0)
			{
				CGUI.Log("Create Room Success:--------------hallid:" + nCurrentHallid);
				sendRoomVariables(new RoomSettingInfo(Crazy_GlobalData_Net.Instance.sceneID, Crazy_GlobalData_Net.Instance.bossID));
			}
			else
			{
				CGUI.Log("Create Room Fail");
				sendCreateRoom();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void sendJoinRoom(int roomid, string pwd)
	{
		try
		{
			if (TNetManager.Instance != null)
			{
				Debug.Log(GetType().ToString() + ":JoinRoom:" + roomid);
				CGUI.Log(GetType().ToString() + ":JoinRoom:" + roomid);
				TNetManager.Instance.Send(new JoinRoomRequest(roomid, pwd));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnJoinRoom(TNetEventData evt)
	{
		try
		{
			if ((int)evt.data["result"] == 0)
			{
				TNetRoom tNetRoom = (TNetRoom)evt.data["room"];
				CGUI.Log("Join Room Success");
				sendUserVariables(new PlayerSettingInfo(Crazy_PlayerClass.None, -1, false, true, true));
				if (m_maxPlayerCount == 1)
				{
					sendGameStart();
				}
				else
				{
					StartCoroutine(TotalWaitTime(tNetRoom.UserCount));
				}
				m_EventHandle.UpdatePlayerCount(tNetRoom.UserCount + "/" + tNetRoom.MaxUsers);
			}
			else
			{
				CGUI.Log("JoinRoomFailed");
				sendGetRoomList(nCurrentHallid);
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void sendUserVariables(PlayerSettingInfo info)
	{
		try
		{
			SFSObject sFSObject = NetworkClassToObject.PlayerSettingToJsonObject(info);
			if (TNetManager.Instance != null)
			{
				CGUI.Log("UpdateUserVariables:PlayerSetting:" + sFSObject);
				TNetManager.Instance.Send(new SetUserVariableRequest(TNetUserVarType.PlayerSetting, sFSObject));
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
			TNetRoom curRoom = TNetManager.Instance.CurRoom;
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			TNetUserVarType tNetUserVarType = (TNetUserVarType)(int)evt.data["key"];
			if (!Crazy_Global_Net.IsRoomHost(curRoom, TNetManager.Instance.Myself.Id) || curRoom.UserCount < curRoom.MaxUsers)
			{
				return;
			}
			bool flag = true;
			foreach (TNetUser user in curRoom.UserList)
			{
				PlayerSettingInfo userVariable = Crazy_Global_Net.GetUserVariable(user);
				if (userVariable == null || !userVariable.isprepare)
				{
					flag = false;
				}
			}
			if (flag)
			{
				sendGameStart();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void sendRoomVariables(RoomSettingInfo info)
	{
		try
		{
			SFSObject sFSObject = NetworkClassToObject.RoomSettingToJsonObject(info);
			if (TNetManager.Instance != null)
			{
				CGUI.Log("UpdateRoomVariables:PlayerSetting:" + sFSObject);
				TNetManager.Instance.Send(new SetRoomVariableRequest(TNetRoomVarType.RoomSetting, sFSObject));
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void OnRoomVariablesUpdate(TNetEventData evt)
	{
		try
		{
			TNetRoom curRoom = TNetManager.Instance.CurRoom;
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			TNetUserVarType tNetUserVarType = (TNetUserVarType)(int)evt.data["key"];
			if (curRoom != null)
			{
				RoomSettingInfo roomSettingInfo = NetworkClassToObject.RoomSettingFromJsonObject(TNetManager.Instance.CurRoom.GetVariable(TNetRoomVarType.RoomSetting));
				Crazy_GlobalData_Net.Instance.bossID = roomSettingInfo.m_boosID;
				Crazy_GlobalData_Net.Instance.sceneID = roomSettingInfo.m_sceneID;
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnUserEnterRoom(TNetEventData evt)
	{
		try
		{
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			CGUI.Log("OnUserEnterRoom:" + tNetUser.Name + ":" + tNetUser.Id);
			TNetRoom curRoom = TNetManager.Instance.CurRoom;
			m_EventHandle.UpdatePlayerCount(curRoom.UserCount + "/" + curRoom.MaxUsers);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	public void sendLeaveRoom()
	{
		try
		{
			if (TNetManager.Instance != null)
			{
				CGUI.Log("Send LeaveRoomRequest");
				TNetManager.Instance.Send(new LeaveRoomRequest());
				bLeavingRoom = true;
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnLeaveRoom(TNetEventData evt)
	{
		try
		{
			TNetUser tNetUser = (TNetUser)evt.data["user"];
			CGUI.Log("OnUserLeaveRoom:" + tNetUser.Name);
			if (tNetUser != TNetManager.Instance.Myself)
			{
				TNetRoom curRoom = TNetManager.Instance.CurRoom;
				m_EventHandle.UpdatePlayerCount(curRoom.UserCount + "/" + curRoom.MaxUsers);
				return;
			}
			CGUI.Log("you have left room");
			Crazy_GlobalData_Net.Instance.Reset();
			sendUserVariables(new PlayerSettingInfo(Crazy_PlayerClass.None, -1, false, false, false));
			bLeavingRoom = false;
			if (bRegroupTeam)
			{
				bRegroupTeam = false;
				RegroupTeam();
			}
			else
			{
				TNetManager.ManualDisconnect();
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
			Debug.Log("OnHostChange:" + tNetUser.Name + ":" + tNetUser.Id);
			CGUI.Log("OnHostChange:" + tNetUser.Name + ":" + tNetUser.Id);
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void OnDestroy()
	{
		SFSServerVersion.Instance.callback = null;
		SFSServerVersion.Instance.callback_error = null;
		UnregisterTNetCallBacks();
	}

	private void OnApplicationPause(bool pause)
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
		Application.LoadLevel("CrazyConnectionLost");
	}
}
