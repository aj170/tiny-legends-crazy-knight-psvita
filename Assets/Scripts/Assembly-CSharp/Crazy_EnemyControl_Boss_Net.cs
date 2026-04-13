using System;
using System.Collections.Generic;
using TNetSdk;
using UnityEngine;

public class Crazy_EnemyControl_Boss_Net : Crazy_EnemyControl_Boss
{
	public NetworkTransformSender transsend;

	public NetworkTransformReceiver transreceiver;

	protected int networkid = -1;

	protected bool controller;

	protected Dictionary<TNetUser, GameObject> targets;

	protected float seed;

	protected Dictionary<int, Crazy_Package_Item> net_droplist = new Dictionary<int, Crazy_Package_Item>();

	protected Dictionary<int, Crazy_Package_Item> cur_drop = new Dictionary<int, Crazy_Package_Item>();

	protected List<Vector3> drop_position = new List<Vector3>();

	private List<GameObject> itemdroplist = new List<GameObject>();

	private bool begindrop;

	private float dropinterval = 0.05f;

	private float lastdropinterval;

	private int dropcount;

	public Crazy_PlayTAudio dropitemfx02;

	public void InitSeed(float _seed)
	{
		seed = _seed;
		int num = 0;
		Crazy_BossDrop bossDropInfo = Crazy_BossDrop.GetBossDropInfo(m_id);
		Crazy_Drop dropInfo = Crazy_Drop.GetDropInfo(bossDropInfo.dropid);
		foreach (int item2 in dropInfo.item)
		{
			Crazy_Package packageInfo = Crazy_Package.GetPackageInfo(item2);
			foreach (Crazy_Package_Item item3 in packageInfo.item)
			{
				net_droplist.Add(num, item3);
				num++;
			}
		}
		List<float> list = Crazy_Global.RandomSeed(seed, net_droplist.Count);
		List<float> list2 = new List<float>();
		foreach (float item4 in list)
		{
			float f = item4;
			float item = Mathf.Abs(f) % 100f;
			list2.Add(item);
		}
		for (int i = 0; i < net_droplist.Count; i++)
		{
			if (list2[i] <= net_droplist[i].rate * 100f)
			{
				cur_drop.Add(i, net_droplist[i]);
			}
		}
		itemdroplist = NetworkItemManager.Instance.InitDrop(cur_drop);
		InitItemPosition(Crazy_GlobalData_Net.Instance.sceneID);
	}

	public override void SetWeaponSkillEffect(float move, float speed)
	{
		move /= 3f;
		speed /= 3f;
		skillmoverate = Mathf.Max(move, skillmoverate);
		skillattackrate = Mathf.Max(speed, skillattackrate);
	}

	protected override void preStart()
	{
		base.preStart();
		recycletime = 30f;
		if (TNetManager.Connection != null && TNetManager.Connection.CurRoom != null)
		{
			if (Crazy_Global_Net.IsRoomHost(TNetManager.Connection.CurRoom, TNetManager.Connection.Myself.Id))
			{
				controller = true;
			}
			else
			{
				controller = false;
			}
			InitNetworkTransform();
		}
	}

	public void OnController()
	{
		controller = true;
		DoTransform();
		OffAttack();
	}

	public void OnMonsterStatusReceiver(MonsterStatusInfo info)
	{
		NetworkSwitchMonsterStatus(info.status);
	}

	public void OnMonsterStatusSender(MonsterStatusInfo info)
	{
		NetworkManager.Instance.SendMonsterStatus(info);
	}

	public void OnBossStatusReceiver(BossStatusInfo info)
	{
		NetworkUpdateStatus(info.status);
	}

	public void OnBossStatusSender(BossStatusInfo info)
	{
		NetworkManager.Instance.SendBossStatus(info);
	}

	public void OnBossSkillReceiver(BossSkillInfo info)
	{
		NetworkUpdateSkill(info.skillid, info.seed);
	}

	public void OnBossSkillSender(BossSkillInfo info)
	{
		NetworkManager.Instance.SendBossSkill(info);
	}

	public void OnMonsterHurtReceiver(MonsterHurtInfo info)
	{
		NetworkHurt(info.damage);
	}

	public void OnMonsterHurtSender(MonsterHurtInfo info)
	{
		NetworkManager.Instance.SendMonsterHurt(info);
	}

	protected void InitNetworkTransform()
	{
		transsend = base.gameObject.AddComponent<NetworkTransformSender>();
		transsend.Init(NetworkManager.Instance.SendTransform, networkid.ToString());
		base.gameObject.AddComponent<NetworkTransformInterpolation>();
		DoTransform();
		transreceiver = base.gameObject.AddComponent<NetworkTransformReceiver>();
	}

	protected void DoTransform()
	{
		if (controller)
		{
			transsend.gameObject.SendMessage("StartSendTransform");
			UnityEngine.Object.Destroy(base.gameObject.GetComponent<NetworkTransformInterpolation>());
		}
	}

	public void InitNetworkId(int id)
	{
		networkid = id;
	}

	protected override void updateStatus()
	{
		foreach (Crazy_Boss_Status item in m_status)
		{
			if (IsInStatus(item) && (cur_status == null || cur_status.priority > item.priority))
			{
				cur_status = item;
				if (controller)
				{
					OnBossStatusSender(new BossStatusInfo(networkid.ToString(), cur_status.id));
				}
				updateStatusData();
			}
		}
	}

	protected void NetworkHurt(float damage)
	{
		if (curStatus != Crazy_MonsterStatus.Die)
		{
			if (curHp <= damage)
			{
				curHp = 0f;
				Dying();
				switchMonsterStatus(Crazy_MonsterStatus.Die);
			}
			else
			{
				curHp -= damage;
				OnInvincible(0.1f);
			}
		}
	}

	public override void OffAttack()
	{
		base.OffAttack();
		if (controller)
		{
			UpdateTarget();
		}
	}

	public override bool Hurt(float damage, Crazy_HitData chd, Crazy_Weapon_Type type, bool isskill)
	{
		OnMonsterHurtSender(new MonsterHurtInfo(networkid.ToString(), damage));
		if (curHp <= damage)
		{
			if (isskill)
			{
				Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task28, 0, 0f);
			}
			curHp = 0f;
			Crazy_FightedType crazy_fightedtype = chd.crazy_fightedtype;
			if (crazy_fightedtype == Crazy_FightedType.BeatBack)
			{
				PlayHurtEffect(type);
				Dying();
				switchMonsterStatus(Crazy_MonsterStatus.Die);
			}
			return true;
		}
		PlayHurtEffect(type);
		curHp -= damage;
		OnInvincible(0.1f);
		return false;
	}

	protected void NetworkUpdateStatus(int id)
	{
		cur_status = m_status.Find((Crazy_Boss_Status t) => t.id == id);
		updateStatusData();
	}

	protected virtual void NetworkUpdateSkill(int id, float seed)
	{
		if (cur_use_skill != null)
		{
			cur_use_skill.cur_process = Crazy_Boss_Skill_Process.NotUse;
		}
		Crazy_Boss_Skill value;
		if (m_skill.TryGetValue(id, out value))
		{
			value.cur_process = Crazy_Boss_Skill_Process.Begin;
			cur_use_skill = value;
			updateSkillData();
			value.cur_data.seed = seed;
		}
	}

	protected override void OnSkill(Crazy_Boss_Skill skill)
	{
		if (cur_use_skill != null)
		{
			cur_use_skill.cur_process = Crazy_Boss_Skill_Process.NotUse;
		}
		skill.cur_process = Crazy_Boss_Skill_Process.Begin;
		cur_use_skill = skill;
		updateSkillData();
		if (controller)
		{
			OnBossSkillSender(new BossSkillInfo(networkid.ToString(), cur_use_skill.cur_data.id, cur_use_skill.cur_data.seed));
		}
	}

	protected override void updateData(float deltatime)
	{
		if (controller)
		{
			base.updateData(deltatime);
		}
		else
		{
			updateSkillCoolDown(deltatime);
		}
	}

	protected void UpdateTarget()
	{
		targets = NetworkPlayerManager.Instance.GetPlayer();
		List<TNetUser> list = new List<TNetUser>();
		foreach (TNetUser key in targets.Keys)
		{
			list.Add(key);
		}
		list.Add(TNetManager.Connection.Myself);
		TNetUser tNetUser = list[UnityEngine.Random.Range(0, list.Count)];
		if (tNetUser == TNetManager.Connection.Myself)
		{
			SetRefTarget(target);
		}
		else
		{
			SetRefTarget(targets[tNetUser]);
		}
	}

	protected void SetRefTarget(GameObject tar)
	{
		reftarget = tar;
	}

	protected void NetworkSwitchMonsterStatus(Crazy_MonsterStatus toStatus)
	{
		ResetPreAttack(0f);
		switch (toStatus)
		{
		case Crazy_MonsterStatus.PreAttack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.Prepare;
			}
			break;
		case Crazy_MonsterStatus.Attack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.Use;
			}
			OnAttack();
			break;
		case Crazy_MonsterStatus.EndAttack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.End;
			}
			break;
		case Crazy_MonsterStatus.Die:
			Die();
			break;
		}
		PlayAnimation(toStatus);
		curStatus = toStatus;
	}

	protected override void switchMonsterStatus(Crazy_MonsterStatus toStatus)
	{
		if (!controller || (toStatus != Crazy_MonsterStatus.Idle && toStatus != Crazy_MonsterStatus.HitRecover && curStatus > toStatus) || curStatus == toStatus)
		{
			return;
		}
		ResetPreAttack(0f);
		switch (toStatus)
		{
		case Crazy_MonsterStatus.PreAttack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.Prepare;
			}
			updateTurnRound();
			break;
		case Crazy_MonsterStatus.Attack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.Use;
			}
			OnAttack();
			break;
		case Crazy_MonsterStatus.EndAttack:
			if (cur_use_skill != null)
			{
				cur_use_skill.cur_process = Crazy_Boss_Skill_Process.End;
			}
			break;
		case Crazy_MonsterStatus.Die:
			Die();
			break;
		}
		PlayAnimation(toStatus);
		curStatus = toStatus;
		if (controller)
		{
			OnMonsterStatusSender(new MonsterStatusInfo(networkid.ToString(), curStatus));
		}
	}

	protected override void Update()
	{
		try
		{
			if (controller)
			{
				base.Update();
				updateDrop();
				return;
			}
			updateDrop();
			updateinvincible();
			updateBloodSlot();
			if (Crazy_GlobalData.cur_game_state == Crazy_GameState.Game)
			{
				activetime += Time.deltaTime;
				if (is_pause)
				{
					last_pause_time += Time.deltaTime;
					if (last_pause_time >= pause_time)
					{
						OffPause();
					}
					return;
				}
				_interval_update += Time.deltaTime;
				if (_interval_update >= _Interval_Update)
				{
					updateData(_interval_update);
					_interval_update = 0f;
				}
				switch (curStatus)
				{
				case Crazy_MonsterStatus.Die:
					updateDie(Time.deltaTime);
					break;
				case Crazy_MonsterStatus.Hurt:
					updateHurt(Time.deltaTime);
					break;
				case Crazy_MonsterStatus.HitRecover:
					updateHitRecover(Time.deltaTime);
					break;
				case Crazy_MonsterStatus.PreAttack:
				case Crazy_MonsterStatus.Attack:
					updateAttack(Time.deltaTime);
					break;
				case Crazy_MonsterStatus.EndAttack:
					updateEndAttack(Time.deltaTime);
					break;
				}
				relive();
				reaction(Time.deltaTime);
				updateAlert();
			}
			else
			{
				base.GetComponent<Animation>().Stop();
			}
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	protected override void Die()
	{
		base.Die();
		Invoke("BeginDieDrop", 2f);
		Crazy_SceneManager.GetInstance().GetScene().OnGameEnd();
	}

	protected void InitItemPosition(int sceneid)
	{
		Crazy_SceneItem sceneItemInfo = Crazy_SceneItem.GetSceneItemInfo(sceneid);
		Crazy_ItemPoint crazyItemPoint = Crazy_ItemPoint.GetCrazyItemPoint(sceneItemInfo.itempointid);
		foreach (Vector2 item4 in crazyItemPoint.point)
		{
			Vector3 item = new Vector3(item4.x, 0f, item4.y);
			drop_position.Add(item);
		}
		List<float> list = Crazy_Global.RandomSeed(seed, drop_position.Count * 2);
		List<int> list2 = new List<int>();
		foreach (float item5 in list)
		{
			float f = item5;
			int item2 = Mathf.FloorToInt(Mathf.Abs(f) % (float)drop_position.Count);
			list2.Add(item2);
		}
		int num = 0;
		foreach (int item6 in list2)
		{
			Vector3 item3 = drop_position[item6];
			drop_position.RemoveAt(item6);
			if (num == 0)
			{
				drop_position.Insert(0, item3);
				num = 1;
			}
			else
			{
				drop_position.Add(item3);
				num = 0;
			}
		}
	}

	protected void BeginDieDrop()
	{
		begindrop = true;
		lastdropinterval = 0f;
		dropcount = 0;
		GameObject gameObject = new GameObject("DropItemFx01");
		gameObject.transform.parent = base.gameObject.transform;
		gameObject.transform.localPosition = Vector3.zero;
		gameObject.transform.localEulerAngles = Vector3.zero;
		Crazy_PlayTAudio crazy_PlayTAudio = gameObject.AddComponent<Crazy_PlayTAudio>();
		crazy_PlayTAudio.audioname = "FX_Coins_loop01";
		crazy_PlayTAudio.Play();
		GameObject gameObject2 = new GameObject("DropItemFx02");
		gameObject2.transform.parent = base.gameObject.transform;
		gameObject2.transform.localPosition = Vector3.zero;
		gameObject2.transform.localEulerAngles = Vector3.zero;
		dropitemfx02 = gameObject2.AddComponent<Crazy_PlayTAudio>();
		dropitemfx02.audioname = "FX_Coins_loop02";
		dropitemfx02.Play();
	}

	protected void updateDrop()
	{
		if (!begindrop)
		{
			return;
		}
		lastdropinterval += Time.deltaTime;
		if (!(lastdropinterval >= dropinterval))
		{
			return;
		}
		lastdropinterval -= dropinterval;
		if (itemdroplist.Count != 0)
		{
			if (itemdroplist[0] != null)
			{
				itemdroplist[0].transform.position = base.transform.position;
				Crazy_Flying crazy_Flying = itemdroplist[0].AddComponent<Crazy_Flying>();
				crazy_Flying.gravity = -60f;
				crazy_Flying.time = 0.8f;
				crazy_Flying.OnFly(drop_position[dropcount]);
				dropcount++;
				Crazy_ItemCollider crazy_ItemCollider = itemdroplist[0].AddComponent<Crazy_ItemCollider>();
				crazy_ItemCollider.radius = 1f;
				crazy_ItemCollider.target = target;
			}
			itemdroplist.Remove(itemdroplist[0]);
			if (itemdroplist.Count == 0 && dropitemfx02 != null)
			{
				dropitemfx02.Stop();
			}
		}
	}
}
