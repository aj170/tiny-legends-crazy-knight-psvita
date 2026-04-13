using System.Collections;
using UnityEngine;

public class UICrazyMain : MonoBehaviour
{
	public bool omake;

	private void Awake()
	{
		Crazy_Achievement.Initialize();
		Crazy_AttackStatus.Initialize();
		Crazy_Award.Initialize();
		Crazy_BossDrop.Initialize();
		Crazy_BossStatusInfo.Initialize("irongolemstatus", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill"));
		Crazy_BossStatusInfo.Initialize("irongolemstatus1", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill1"));
		Crazy_BossStatusInfo.Initialize("irongolemstatus2", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill2"));
		Crazy_BossStatusInfo.Initialize("irongolemstatus3", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill3"));
		Crazy_BossStatusInfo.Initialize("irongolemstatus4", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill4"));
		Crazy_BossStatusInfo.Initialize("irongolemstatus5", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolemskill5"));
		Crazy_BossStatusInfo.Initialize("irongolem_netstatus", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolem_netskill"));
		Crazy_BossStatusInfo.Initialize("irongolem1_netstatus", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolem1_netskill"));
		Crazy_BossStatusInfo.Initialize("irongolem2_netstatus", Crazy_BossSkillInfo.GetCrazyBossSkill("irongolem2_netskill"));
		Crazy_Boss_Level.Initialize();
		Crazy_ComboLevel.Initialize();
		Crazy_Drop.Initialize();
		Crazy_ItemPoint.Initialize();
		Crazy_Land.Initialize();
		Crazy_Language.Initialize();
		Crazy_LoadingInfo.Initialize();
		Crazy_LevelModify.Initialize();
		Crazy_Monster_Level_Manager.Initialize();
		Crazy_Monster_Template_Manager.Initialize();
		Crazy_NetBoss.Initialize();
		Crazy_NetUIMass.Initialize();
		Crazy_NetUISequence.Initialize();
		Crazy_Package.Initialize();
		Crazy_PlayerClass_Level.Initialize();
		Crazy_Process.Initialize();
		Crazy_Roll.Initialize();
		Crazy_ScenePoint.Initialize();
		Crazy_SceneItem.Initialize();
		Crazy_SkillInfo.Initialize();
		Crazy_StoryProcess.Initialize();
		Crazy_Wave_Information.Initialize();
		Crazy_Weapon.Initialize();
		OpenClickNew.Initialize();
		GameCenterPlugin.Initialize();
		FlurryPlugin.StartSession("4CCQ6X62G7DVDJYQ7ZQP");
		Crazy_Data.CurData().UpdateFirstLoginTime(Crazy_Global.GetCurSystemTime());
		Crazy_Data.CurData().AddPlayTimes();
		Crazy_Data.SaveData();
		if (omake)
		{
			SFSServerVersion.Instance.OMake();
			CommunicationVersion.Instance.OMake();
			SocialVersion.Instance.OMake();
		}
	}

	private void Start()
	{
		if (Crazy_Beginner.instance.isCheckJailbreak)
		{
			Hashtable data = new Hashtable();
			if (OtherPlugin.IsIAPCrack())
			{
				FlurryPlugin.logEvent("Jailbreak", data);
			}
			else
			{
				FlurryPlugin.logEvent("Non-Jailbreak", data);
			}
			Crazy_Beginner.instance.isCheckJailbreak = false;
		}
	}
}
