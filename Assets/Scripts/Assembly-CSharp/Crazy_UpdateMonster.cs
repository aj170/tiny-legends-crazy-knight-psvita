using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Crazy_UpdateMonster : MonoBehaviour
{
	protected static List<float> bosspercent = new List<float>();

	protected static float cur_percent = 0f;

	protected static int monster_count;

	private GameObject enemyNodeObj;

	private int id;

	public int max_number = 50;

	private float CheckInterval = 1f;

	private float checkInterval;

	private float RanderCheckInterval = 0.5f;

	private float rendercheckInterval;

	private Crazy_Wave_Data wave_data;

	private int cur_control;

	private int cur_data;

	private int cur_number;

	private int volume = 50;

	private int message = -1;

	private int number = 1;

	private int rate = 1;

	private int bgm = -1;

	private int count = 1;

	private Crazy_Wave_Control cur_wave_control;

	private bool islastcontrol;

	private bool isstopupmonster;

	private bool isendless;

	private int endlessnumber;

	private List<int> monster;

	private List<int> boss;

	private List<int> ranged;

	private float speedmodify = 1f;

	private float preattacktimemodify = 1f;

	private float rangedcd = 1f;

	private int rangedcount = 1;

	private float rangeout = 100f;

	private int upMonsterNumber;

	private UICrazyScene my_scene;

	protected float gametime;

	protected int gamemonster;

	protected Dictionary<string, Object> monster_copy;

	public static List<float> GetBossPercent()
	{
		return bosspercent;
	}

	public static float GetCurPercent()
	{
		return cur_percent;
	}

	public void SetScene(UICrazyScene scene)
	{
		my_scene = scene;
	}

	public void SetRange(float rout)
	{
		rangeout = rout;
	}

	private static void UpdateMonstersPercent(int count)
	{
		if (monster_count == 0)
		{
			cur_percent = 0f;
		}
		cur_percent = (float)count / (float)monster_count;
	}

	private static void UpdateBossPercent(List<int> bosscount)
	{
		bosspercent.Clear();
		foreach (int item2 in bosscount)
		{
			if (monster_count != 0)
			{
				float item = (float)item2 / (float)monster_count;
				bosspercent.Add(item);
			}
		}
	}

	private static void ResetCurPercent()
	{
		cur_percent = 0f;
	}

	private static void UpMonsterNumber(Crazy_Wave_Data cwd)
	{
		ResetCurPercent();
		List<int> list = new List<int>();
		monster_count = 0;
		foreach (Crazy_Wave_Control controldatum in cwd.controldata)
		{
			foreach (Crazy_Monster_Control item2 in controldatum.monsterlist)
			{
				monster_count++;
				if (item2.id == 3)
				{
					int item = monster_count;
					list.Add(item);
				}
			}
		}
		UpdateBossPercent(list);
	}

	private void Awake()
	{
		Crazy_GlobalData.enemyList = new Dictionary<int, GameObject>();
		enemyNodeObj = new GameObject("AllEnemies");
		enemyNodeObj.transform.parent = GameObject.Find("Scene").transform;
		enemyNodeObj.transform.position = new Vector3(0f, 0f, 0f);
		enemyNodeObj.AddComponent<CombineChildren>();
		id = 0;
		monster = Crazy_Land.GetLandinfo(Crazy_GlobalData.cur_stage).monster;
		boss = Crazy_Land.GetLandinfo(Crazy_GlobalData.cur_stage).boss;
		ranged = Crazy_Land.GetLandinfo(Crazy_GlobalData.cur_stage).ranged;
		if (!Crazy_Data.CurData().GetMixMonster())
		{
			monster = new List<int>();
			monster.Add(Crazy_Land.GetLandinfo(Crazy_GlobalData.cur_stage).monster[0]);
			boss = new List<int>();
			boss.Add(Crazy_Land.GetLandinfo(Crazy_GlobalData.cur_stage).boss[0]);
		}
		InitMonsterCopy();
		Crazy_Modify modify = Crazy_LevelModify.GetModify(Crazy_GlobalData.cur_leveltype, Crazy_GlobalData.cur_level);
		speedmodify = modify.speedmodify;
		preattacktimemodify = modify.preattacktimemodify;
		rangedcd = modify.rangedcooldown;
		rangedcount = modify.rangedcount;
		wave_data = Crazy_Wave_Information.GetWaveInformation(Crazy_GlobalData.cur_wave);
		UpMonsterNumber(wave_data);
		gametime = Crazy_LevelModify.GetModify(Crazy_GlobalData.cur_leveltype, Crazy_GlobalData.cur_level).time;
		gamemonster = Crazy_LevelModify.GetModify(Crazy_GlobalData.cur_leveltype, Crazy_GlobalData.cur_level).quantity;
		Crazy_EnemyManagement.ResetActiveNumber();
		Crazy_EnemyManagement.ResetRangedEnemyNumber();
		Crazy_ItemManager.Clear();
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Level", Crazy_Data.CurData().GetLevel());
		hashtable.Add("StageLevel", Crazy_GlobalData.cur_level);
		FlurryPlugin.logEvent("Fight", hashtable, true);
	}

	private GameObject LoadMonster(string path)
	{
		return Object.Instantiate(monster_copy[path]) as GameObject;
	}

	private void InitMonsterCopy()
	{
		monster_copy = new Dictionary<string, Object>();
		foreach (int item in monster)
		{
			Crazy_Monster_Template monsterTemplate = Crazy_Monster_Template_Manager.GetMonsterTemplate(item);
			Object value = Resources.Load(monsterTemplate.path);
			monster_copy.Add(monsterTemplate.path, value);
		}
		foreach (int item2 in boss)
		{
			Crazy_Monster_Template monsterTemplate2 = Crazy_Monster_Template_Manager.GetMonsterTemplate(item2);
			Object value2 = Resources.Load(monsterTemplate2.path);
			monster_copy.Add(monsterTemplate2.path, value2);
		}
		foreach (int item3 in ranged)
		{
			Crazy_Monster_Template monsterTemplate3 = Crazy_Monster_Template_Manager.GetMonsterTemplate(item3);
			Object value3 = Resources.Load(monsterTemplate3.path);
			monster_copy.Add(monsterTemplate3.path, value3);
		}
		if (Crazy_GlobalData.cur_leveltype != Crazy_LevelType.Boss)
		{
			return;
		}
		Crazy_Boss_Level bossLevel = Crazy_Boss_Level.GetBossLevel(Crazy_GlobalData.cur_level);
		List<Crazy_Boss_Data> bossData = bossLevel.GetBossData();
		foreach (Crazy_Boss_Data item4 in bossData)
		{
			Crazy_Monster_Template monsterTemplate4 = Crazy_Monster_Template_Manager.GetMonsterTemplate(item4.id);
			Object value4 = Resources.Load(monsterTemplate4.path);
			monster_copy.Add(monsterTemplate4.path, value4);
		}
	}

	private void Update()
	{
		if (Crazy_GlobalData.cur_game_state == Crazy_GameState.Game)
		{
			Crazy_GlobalData.cur_player_time += Time.deltaTime;
			checkInterval -= Time.deltaTime;
			rendercheckInterval -= Time.deltaTime;
			if (rendercheckInterval < 0f)
			{
				rendercheckInterval = RanderCheckInterval;
			}
			if (checkInterval < 0f)
			{
				checkInterval = CheckInterval;
				UpdateMonsters();
				UpdateGameState();
			}
		}
	}

	private void UpdateGameState()
	{
		switch (Crazy_GlobalData.cur_leveltype)
		{
		case Crazy_LevelType.Normal1:
		case Crazy_LevelType.Boss:
			break;
		case Crazy_LevelType.Normal2:
			if (Crazy_GlobalData.cur_kill_number >= gamemonster)
			{
				my_scene.OnGameEnd();
				if (gametime - Crazy_GlobalData.cur_player_time <= 1f)
				{
					Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task05, 0, 0f);
				}
			}
			else if (Crazy_GlobalData.cur_player_time >= gametime)
			{
				my_scene.OnGameFailed();
			}
			break;
		case Crazy_LevelType.Normal3:
			if (Crazy_GlobalData.cur_player_time >= gametime)
			{
				my_scene.OnGameEnd();
				if (Crazy_GlobalData.cur_kill_number == 0)
				{
					Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task07, 0, 0f);
				}
			}
			break;
		}
	}

	private void UpdateMonsters()
	{
		if (isstopupmonster)
		{
			if (Crazy_GlobalData.enemyList.Count == 0)
			{
				switch (Crazy_GlobalData.cur_leveltype)
				{
				case Crazy_LevelType.Normal1:
				case Crazy_LevelType.Boss:
					my_scene.OnGameEnd();
					break;
				case Crazy_LevelType.Normal2:
				case Crazy_LevelType.Normal3:
					break;
				}
			}
		}
		else if (isendless)
		{
			UpdateMonstersEndless();
		}
		else
		{
			if (Crazy_GlobalData.enemyList.Count >= volume)
			{
				return;
			}
			if (cur_wave_control != null)
			{
				for (cur_number = 0; cur_number < number; cur_number++)
				{
					ReadMonsterParament();
				}
			}
			else if (islastcontrol && (Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Boss || Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Normal1 || Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Normal2))
			{
				isstopupmonster = true;
			}
			else
			{
				islastcontrol = false;
				ReadControlParament();
			}
		}
	}

	private void CreateMonsterEndless(int id_template, int id_level)
	{
		Crazy_Monster_Template monsterTemplate = Crazy_Monster_Template_Manager.GetMonsterTemplate(id_template);
		Crazy_Monster_Level monsterLevel = Crazy_Monster_Level_Manager.GetMonsterLevel(id_level);
		GameObject gameObject = LoadMonster(monsterTemplate.path);
		gameObject.name = monsterTemplate.name;
		Crazy_EnemyControl crazy_EnemyControl = gameObject.GetComponent("Crazy_EnemyControl") as Crazy_EnemyControl;
		crazy_EnemyControl.InitData(monsterTemplate, monsterLevel, -1, speedmodify, preattacktimemodify);
		crazy_EnemyControl.SetEffect(Crazy_SceneManager.GetInstance().GetScene().monstereffect);
		crazy_EnemyControl.SetHint(Crazy_SceneManager.GetInstance().GetScene().monsterhint);
		gameObject.layer = LayerMask.NameToLayer("Enemy");
		gameObject.transform.parent = enemyNodeObj.transform;
		Crazy_Point randomCrazyPoint = Crazy_ScenePoint.GetRandomCrazyPoint(Crazy_GlobalData.cur_scene_id);
		crazy_EnemyControl.SetRange(randomCrazyPoint, rangeout);
		gameObject.transform.localPosition = Crazy_Global.FindMonsterAppPosition(randomCrazyPoint);
		Crazy_GlobalData.enemyList.Add(id, gameObject);
		id++;
		upMonsterNumber++;
		UpdateMonstersPercent(upMonsterNumber);
	}

	private void CreateBoss(Crazy_Boss_Data data, Crazy_Monster_Control cmc)
	{
		Crazy_Monster_Template monsterTemplate = Crazy_Monster_Template_Manager.GetMonsterTemplate(data.id);
		Crazy_Monster_Level crazy_Monster_Level = new Crazy_Monster_Level(Crazy_GlobalData.cur_level);
		crazy_Monster_Level.exp = data.exp;
		crazy_Monster_Level.gold = data.gold;
		crazy_Monster_Level.hp = data.hp;
		GameObject gameObject = LoadMonster(monsterTemplate.path);
		gameObject.name = monsterTemplate.name;
		Crazy_EnemyControl_Boss crazy_EnemyControl_Boss = gameObject.GetComponent("Crazy_EnemyControl_Boss") as Crazy_EnemyControl_Boss;
		crazy_EnemyControl_Boss.InitData(monsterTemplate, crazy_Monster_Level, cmc.item, data.movemodify, data.force);
		crazy_EnemyControl_Boss.SetEffect(Crazy_SceneManager.GetInstance().GetScene().monstereffect);
		crazy_EnemyControl_Boss.SetHint(Crazy_SceneManager.GetInstance().GetScene().monsterhint);
		gameObject.layer = LayerMask.NameToLayer("Enemy");
		gameObject.transform.parent = enemyNodeObj.transform;
		Crazy_Point randomCrazyPoint = Crazy_ScenePoint.GetRandomCrazyPoint(Crazy_GlobalData.cur_scene_id);
		crazy_EnemyControl_Boss.SetRange(randomCrazyPoint, rangeout);
		gameObject.transform.localPosition = Crazy_Global.FindMonsterAppPosition(randomCrazyPoint);
		Crazy_GlobalData.enemyList.Add(id, gameObject);
		id++;
		upMonsterNumber++;
		UpdateMonstersPercent(upMonsterNumber);
	}

	private void CreateMonster(Crazy_Monster_Control cmc)
	{
		Crazy_Monster_Template crazy_Monster_Template = null;
		Crazy_Monster_Level crazy_Monster_Level = null;
		int num = 0;
		switch ((Crazy_MonsterType)cmc.id)
		{
		default:
			return;
		case Crazy_MonsterType.Normal:
			crazy_Monster_Template = Crazy_Monster_Template_Manager.GetMonsterTemplate(monster[Random.Range(0, monster.Count)]);
			num = ((Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Boss) ? Random.Range(Crazy_GlobalData.cur_level, Crazy_GlobalData.cur_level + 5) : Mathf.Max(1, Crazy_GlobalData.cur_level + Random.Range(-2, 3)));
			crazy_Monster_Level = Crazy_Monster_Level_Manager.GetMonsterLevel(num);
			break;
		case Crazy_MonsterType.MiddleBoss:
			crazy_Monster_Template = Crazy_Monster_Template_Manager.GetMonsterTemplate(boss[Random.Range(0, boss.Count)]);
			num = ((Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Boss) ? Random.Range(Crazy_GlobalData.cur_level, Crazy_GlobalData.cur_level + 5) : Mathf.Max(1, Crazy_GlobalData.cur_level + Random.Range(-2, 3)));
			crazy_Monster_Level = Crazy_Monster_Level_Manager.GetMiddleBossLevel(num);
			break;
		case Crazy_MonsterType.Boss:
		{
			Crazy_Boss_Level bossLevel = Crazy_Boss_Level.GetBossLevel(Crazy_GlobalData.cur_level);
			Crazy_Boss_Data nextBossData = bossLevel.GetNextBossData();
			CreateBoss(nextBossData, cmc);
			return;
		}
		case Crazy_MonsterType.Ranged:
			if (Crazy_Data.CurData().GetRanged() && Crazy_EnemyManagement.AddRangedEnemyNumber())
			{
				crazy_Monster_Template = Crazy_Monster_Template_Manager.GetMonsterTemplate(ranged[Random.Range(0, ranged.Count)]);
				num = ((Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Boss) ? Random.Range(Crazy_GlobalData.cur_level, Crazy_GlobalData.cur_level + 5) : Mathf.Max(1, Crazy_GlobalData.cur_level + Random.Range(-2, 3)));
				crazy_Monster_Level = Crazy_Monster_Level_Manager.GetMonsterLevel(num);
			}
			else
			{
				crazy_Monster_Template = Crazy_Monster_Template_Manager.GetMonsterTemplate(monster[Random.Range(0, monster.Count)]);
				num = ((Crazy_GlobalData.cur_leveltype == Crazy_LevelType.Boss) ? Random.Range(Crazy_GlobalData.cur_level, Crazy_GlobalData.cur_level + 5) : Mathf.Max(1, Crazy_GlobalData.cur_level + Random.Range(-2, 3)));
				crazy_Monster_Level = Crazy_Monster_Level_Manager.GetMonsterLevel(num);
			}
			break;
		}
		if (crazy_Monster_Template != null && crazy_Monster_Level != null)
		{
			GameObject gameObject = LoadMonster(crazy_Monster_Template.path);
			gameObject.name = crazy_Monster_Template.name;
			Crazy_EnemyControl crazy_EnemyControl = gameObject.GetComponent("Crazy_EnemyControl") as Crazy_EnemyControl;
			crazy_EnemyControl.InitData(crazy_Monster_Template, crazy_Monster_Level, cmc.item, speedmodify, preattacktimemodify);
			gameObject.SendMessage("SetRemoteCoolDown", rangedcd, SendMessageOptions.DontRequireReceiver);
			gameObject.SendMessage("SetRemoteCount", rangedcount, SendMessageOptions.DontRequireReceiver);
			crazy_EnemyControl.SetEffect(Crazy_SceneManager.GetInstance().GetScene().monstereffect);
			crazy_EnemyControl.SetHint(Crazy_SceneManager.GetInstance().GetScene().monsterhint);
			gameObject.layer = LayerMask.NameToLayer("Enemy");
			gameObject.transform.parent = enemyNodeObj.transform;
			Crazy_Point randomCrazyPoint = Crazy_ScenePoint.GetRandomCrazyPoint(Crazy_GlobalData.cur_scene_id);
			crazy_EnemyControl.SetRange(randomCrazyPoint, rangeout);
			gameObject.transform.localPosition = Crazy_Global.FindMonsterAppPosition(randomCrazyPoint);
			Crazy_GlobalData.enemyList.Add(id, gameObject);
			id++;
			upMonsterNumber++;
			UpdateMonstersPercent(upMonsterNumber);
		}
	}

	private void ReadControlParament()
	{
		Crazy_Wave_Control crazy_Wave_Control = wave_data.controldata[cur_control];
		if (crazy_Wave_Control.volume != -1)
		{
			volume = crazy_Wave_Control.volume;
		}
		if (crazy_Wave_Control.number != -1)
		{
			number = crazy_Wave_Control.number;
		}
		if (crazy_Wave_Control.rate != -1)
		{
			rate = crazy_Wave_Control.rate;
			CheckInterval = rate;
			if (number != 0)
			{
				CheckInterval = Mathf.Max(CheckInterval / (float)number, 0.1f);
				number = 1;
			}
		}
		if (crazy_Wave_Control.bgm != -1)
		{
			bgm = crazy_Wave_Control.bgm;
		}
		if (crazy_Wave_Control.message != -1)
		{
			message = crazy_Wave_Control.message;
			Message();
		}
		if (crazy_Wave_Control.count != -1)
		{
			count = crazy_Wave_Control.count;
			Crazy_EnemyManagement.SetMaxActiveNumber(count);
		}
		cur_wave_control = crazy_Wave_Control;
		cur_control++;
		if (cur_control >= wave_data.controldata.ToArray().GetLength(0))
		{
			cur_control = 0;
			islastcontrol = true;
		}
		if (cur_wave_control.monsterlist.ToArray().GetLength(0) == 0)
		{
			cur_wave_control = null;
		}
	}

	private void ReadMonsterParament()
	{
		if (cur_wave_control != null)
		{
			CreateMonster(cur_wave_control.monsterlist[cur_data]);
			cur_data++;
			if (cur_data >= cur_wave_control.monsterlist.ToArray().GetLength(0))
			{
				cur_wave_control = null;
				cur_data = 0;
			}
		}
	}

	protected void UpdateMonstersEndless()
	{
		if (Crazy_GlobalData.enemyList.Count < volume)
		{
			cur_number = 0;
			while (cur_number < number)
			{
				ReadMonsterEndless();
				cur_number++;
				endlessnumber++;
			}
		}
	}

	protected void ReadMonsterEndless()
	{
		int num = endlessnumber / 200;
		int num2 = Random.Range(0, 100);
		if (num2 < Mathf.Max(95 - 5 * num, 65))
		{
			CreateMonsterEndless(Random.Range(1, 12), Mathf.Min(1 + num, 8));
		}
		else
		{
			CreateMonsterEndless(Random.Range(12, 23), Mathf.Min(3 + num, 10));
		}
	}

	protected void Message()
	{
		string text = string.Empty;
		switch (message)
		{
		case 1:
			text = string.Empty;
			break;
		case 2:
			text = string.Empty;
			break;
		case 3:
			text = "MONSTERS INCOMING";
			break;
		case 4:
			text = "BOSS INCOMING";
			break;
		case 5:
			text = string.Empty;
			break;
		}
		Crazy_SceneManager.GetInstance().GetScene().SendHintMessage("#" + text.ToUpper() + "$");
	}
}
