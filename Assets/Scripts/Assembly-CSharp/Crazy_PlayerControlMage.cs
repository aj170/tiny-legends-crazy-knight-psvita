using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Crazy_PlayerControlMage : Crazy_PlayerControl
{
	private string m_attackAnimName;

	private GameObject obj;

	private GameObject meteorPlayerEffectobj;

	private GameObject meteorEffectobj;

	private GameObject[] meteorHitEffectobj = new GameObject[5];

	private GameObject mageAttackEffectobj;

	private GameObject blinkStartEffectobj;

	private GameObject blinkEndEffectobj;

	protected new float animationspeedmodify = 1f;

	private void CreateMeteorEffect(Vector3 pos)
	{
		meteorEffectobj = (GameObject)Object.Instantiate(obj, pos, Quaternion.identity);
		meteorEffectobj.layer = LayerMask.NameToLayer("Player");
		meteorEffectobj.name = "meteor_effect";
		meteorEffectobj.transform.parent = RootNode.transform;
	}

	protected override void InitWeaponEffect()
	{
		attackeffectdic.Clear();
		attackeffectdic = new Dictionary<string, GameObject>();
		if (cur_weapon.type == Crazy_Weapon_Type.Staff)
		{
			blinkStartEffectobj = Crazy_Global.LoadAssetsPrefab("Prefabs/flash/blinkStart_pfb");
			blinkStartEffectobj.layer = LayerMask.NameToLayer("Player");
			blinkStartEffectobj.name = "blinkStart_effect";
			blinkStartEffectobj.transform.parent = RootNode.transform;
			blinkStartEffectobj.transform.position = base.transform.position;
			blinkEndEffectobj = Crazy_Global.LoadAssetsPrefab("Prefabs/flash/blinkEnd_pfb");
			blinkEndEffectobj.layer = LayerMask.NameToLayer("Player");
			blinkEndEffectobj.name = "blinkEnd_effect";
			blinkEndEffectobj.transform.parent = base.gameObject.transform;
			blinkEndEffectobj.transform.localPosition = Vector3.zero;
			meteorPlayerEffectobj = Crazy_Global.LoadAssetsPrefab("Prefabs/staffskilleffect/meteorPlayerEffect_pfb");
			meteorPlayerEffectobj.layer = LayerMask.NameToLayer("Player");
			meteorPlayerEffectobj.name = "staffplayer_effect";
			meteorPlayerEffectobj.transform.parent = base.gameObject.transform;
			meteorPlayerEffectobj.transform.localPosition = Vector3.zero;
			meteorPlayerEffectobj.SetActiveRecursively(false);
			obj = (GameObject)Resources.Load("Prefabs/staffskilleffect/meteorEffect_pfb");
			for (int i = 0; i < 5; i++)
			{
				meteorHitEffectobj[i] = Crazy_Global.LoadAssetsPrefab("Prefabs/staffskilleffect/meteorHitEffect_pfb");
				meteorHitEffectobj[i].layer = LayerMask.NameToLayer("Player");
				meteorHitEffectobj[i].name = "meteor_hit_effect";
				meteorHitEffectobj[i].transform.parent = RootNode.transform;
				meteorHitEffectobj[i].transform.localPosition = Vector3.zero;
			}
			mageAttackEffectobj = Crazy_Global.LoadAssetsPrefab("Prefabs/mageAttackEffect/mobao_pfb");
			mageAttackEffectobj.layer = LayerMask.NameToLayer("Player");
			mageAttackEffectobj.name = "attack_effect";
			mageAttackEffectobj.transform.parent = base.gameObject.transform;
			mageAttackEffectobj.transform.localPosition = Vector3.zero;
		}
	}

	protected override void updateRoll()
	{
		if (rollrecover)
		{
			lastrollrecovertime += Time.deltaTime;
			if (lastrollrecovertime >= rollrecovertime)
			{
				rollrecover = false;
				if (IsDie() || IsDeject() || IsCelebrate())
				{
					return;
				}
				switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
			}
		}
		if (rollcooldown)
		{
			lastrollcooldowntime += Time.deltaTime;
			if (lastrollcooldowntime >= rollcooldowntime)
			{
				rollcooldown = false;
			}
		}
	}

	protected override void ResetRoll()
	{
	}

	protected override bool CheckAnimation()
	{
		return Mathf.Abs(base.GetComponent<Animation>()["Attack01_Staff01_merge"].speed - 1f * animationspeedmodify) <= 0.01f;
	}

	protected override void ModifyAnimation()
	{
		base.GetComponent<Animation>().wrapMode = WrapMode.Once;
		base.GetComponent<Animation>()["Forward01_Staff01_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Idle01_Staff01_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Death01_Staff01_merge"].wrapMode = WrapMode.ClampForever;
		base.GetComponent<Animation>()["Idle_Staff01_celebrate01_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Attack01_Staff01_merge"].wrapMode = WrapMode.Once;
		base.GetComponent<Animation>()["Skill01_Loop_Staff_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Forward01_Staff01_merge"].layer = 0;
		base.GetComponent<Animation>()["Idle01_Staff01_merge"].layer = 0;
		base.GetComponent<Animation>()["Attack01_Staff01_merge"].layer = 2;
		base.GetComponent<Animation>()["Skill01_Start_Staff_merge"].layer = 2;
		base.GetComponent<Animation>()["Skill01_Loop_Staff_merge"].layer = 2;
		base.GetComponent<Animation>()["Skill01_End_Staff_merge"].layer = 2;
		base.GetComponent<Animation>()["Blink01_Staff_merge"].layer = 3;
		base.GetComponent<Animation>()["Damage01_Staff01_merge"].layer = 3;
		base.GetComponent<Animation>()["Knockdown_Staff01_merge"].layer = 3;
		base.GetComponent<Animation>()["Death01_Staff01_merge"].layer = 4;
		base.GetComponent<Animation>()["Idle_Staff01_celebrate01_merge"].layer = 5;
		base.GetComponent<Animation>()["Attack01_Staff01_merge"].speed = 1f * animationspeedmodify;
		base.GetComponent<Animation>()["Skill01_Start_Staff_merge"].speed = 1f * animationspeedmodify;
		base.GetComponent<Animation>()["Skill01_Loop_Staff_merge"].speed = 1f * animationspeedmodify;
		base.GetComponent<Animation>()["Skill01_End_Staff_merge"].speed = 1f * animationspeedmodify;
		AddAnimationEvent();
	}

	protected override void Roll()
	{
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		rollrecover = true;
		lastrollrecovertime = 0f;
		rollcooldown = true;
		lastrollcooldowntime = 0f;
		if (curMoveDir == Vector3.zero)
		{
			rolldir = base.transform.forward;
		}
		else
		{
			rolldir = curMoveDir;
		}
		base.GetComponent<Animation>().CrossFade("Blink01_Staff_merge", 0.1f);
		blinkStartEffectobj.transform.position = base.transform.position;
		blinkStartEffectobj.transform.GetComponentInChildren<ParticleSystem>().Play();
		PlayTAudio("Shanxian");
		StartCoroutine(Blink(rolldir, 7.5f));
	}

	private IEnumerator Blink(Vector3 movedir, float movedistance)
	{
		yield return new WaitForSeconds(0.18f);
		Vector3 modifydistance = default(Vector3);
		int iteration = 3;
		bool btouchother = checkCollideToWall(movedir * movedistance, ref modifydistance, ref iteration);
		btouchground = checkCollideToGround(movedir * movedistance);
		if (btouchother)
		{
			base.transform.position += modifydistance;
		}
		else if (btouchground)
		{
			base.transform.position += movedir * movedistance;
		}
		blinkEndEffectobj.transform.GetComponentInChildren<ParticleSystem>().Play();
	}

	protected override void StopAttack()
	{
		if (is_attack_pause)
		{
			OffAttackPause();
		}
		if (m_attackAnimName != string.Empty)
		{
			base.GetComponent<Animation>().Stop(m_attackAnimName);
		}
		AttackRecover();
		OnEndAttack();
	}

	public override void Attack()
	{
		usingskill = false;
		if (is_attack_pause)
		{
			return;
		}
		attacklist.Clear();
		OffAttackMove();
		attackrecovering = true;
		PlayTAudio("Mobao");
		mageAttackEffectobj.transform.GetComponentInChildren<ParticleSystem>().Play();
		lastattackingtime = 0f;
		cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
		base.GetComponent<Animation>().Stop(cur_attackstatus.attackanimname);
		AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
		isattackenemy = false;
		lastattackrecoveringtime = cur_attackstatus.attackrecover;
		lastattackmovetime = 0f;
		lastattackjudgmenttime.Clear();
		foreach (Crazy_AttackJudgmentInfo item in cur_attackstatus.attackjudgmentinfo)
		{
			lastattackjudgmenttime.Add(item.attackjudgmenttime);
		}
		lastadvattackeffecttime = cur_attackstatus.attackadveffectdata.begintime;
	}

	private void PlayPlayerEffect()
	{
		meteorPlayerEffectobj.SetActiveRecursively(true);
		meteorPlayerEffectobj.transform.GetComponentInChildren<ParticleSystem>().Stop(true);
		meteorPlayerEffectobj.transform.GetComponentInChildren<ParticleSystem>().Play(true);
		PlayTAudio("Ani_Staff_Skill01_start01");
	}

	private void PlayMeteorEffect(int i)
	{
		if (Crazy_GlobalData.enemyList == null || Crazy_GlobalData.enemyList.Count == 0)
		{
			CreateMeteorEffect(base.transform.position);
			meteorHitEffectobj[i].transform.localPosition = base.transform.position;
		}
		else
		{
			List<GameObject> list = new List<GameObject>();
			foreach (GameObject value in Crazy_GlobalData.enemyList.Values)
			{
				list.Add(value);
			}
			int index = Random.Range(0, list.Count - 1);
			Vector3 vector = new Vector3(list[index].transform.position.x, 0f, list[index].transform.position.z);
			if (i == 4)
			{
				CreateMeteorEffect(base.transform.position);
				meteorHitEffectobj[i].transform.position = base.transform.position;
			}
			else
			{
				CreateMeteorEffect(vector);
				meteorHitEffectobj[i].transform.position = vector;
			}
		}
		meteorEffectobj.transform.GetComponentInChildren<ParticleSystem>().Play(true);
		PlayTAudio("Ani_Staff_Skill01_shot01");
	}

	private void PlayMeteorHitEffect(int i)
	{
		PlayShakeSceenEffect(0.2f, 0.01f, 2f);
		meteorHitEffectobj[i].transform.GetComponentInChildren<ParticleSystem>().Stop(true);
		meteorHitEffectobj[i].transform.GetComponentInChildren<ParticleSystem>().Play(true);
		PlayTAudio("Ani_Staff_Skill01_hit01");
	}

	public override void Skill()
	{
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		energy = 0;
		usingskill = true;
		attacklist.Clear();
		OffAttackMove();
		attackrecovering = true;
		lastattackingtime = 0f;
		base.GetComponent<Animation>().Stop("Skill01_Start_" + cur_weapon.type_name + "_merge");
		base.GetComponent<Animation>().Stop("Skill01_Loop_" + cur_weapon.type_name + "_merge");
		base.GetComponent<Animation>().Stop("Skill01_End_" + cur_weapon.type_name + "_merge");
		cur_attackstatus = attackstatus["Skill01_" + cur_weapon.type_name + "01"];
		isattackenemy = false;
		lastattackrecoveringtime = cur_attackstatus.attackrecover;
		lastattackmovetime = 0f;
		lastattackjudgmenttime.Clear();
		foreach (Crazy_AttackJudgmentInfo item in cur_attackstatus.attackjudgmentinfo)
		{
			lastattackjudgmenttime.Add(item.attackjudgmenttime);
		}
		lastadvattackeffecttime = cur_attackstatus.attackadveffectdata.begintime;
		OnInvincible3(cur_attackstatus.attacktime / animationspeedmodify + 4f);
		if (useeffect)
		{
			PlayPlayerEffect();
			if (cur_weapon.type == Crazy_Weapon_Type.Staff)
			{
				StartCoroutine(PlayMeteorDown());
			}
		}
	}

	private IEnumerator PlayMeteorDown()
	{
		AnimationCrossFade("Skill01_Start_" + cur_weapon.type_name + "_merge", 0.1f);
		yield return new WaitForSeconds(1.667f);
		AnimationCrossFade("Skill01_Loop_" + cur_weapon.type_name + "_merge", 0.1f);
		for (int i = 0; i < 5; i++)
		{
			PlayMeteorEffect(i);
			yield return new WaitForSeconds(0.7f);
			PlayMeteorHitEffect(i);
			Object.DestroyObject(meteorEffectobj);
			MeteorAttackHurt(i);
		}
		base.GetComponent<Animation>().Stop("Skill01_Loop_" + cur_weapon.type_name + "_merge");
		AnimationCrossFade("Skill01_End_" + cur_weapon.type_name + "_merge", 0.1f);
		meteorPlayerEffectobj.SetActiveRecursively(false);
		yield return null;
	}

	protected Vector3 GetMeteorPoint(int index)
	{
		Vector2 original = new Vector2(meteorHitEffectobj[index].transform.position.x, meteorHitEffectobj[index].transform.position.z);
		Vector2 forward = new Vector2(meteorHitEffectobj[index].transform.forward.x, meteorHitEffectobj[index].transform.forward.z);
		Vector2 vector = Crazy_Global.RotatebyAngle(original, forward, cur_attackstatus.attackjudgmentinfo[index].attackpoint.angle, cur_attackstatus.attackjudgmentinfo[index].attackpoint.length);
		Vector3 result = new Vector3(vector.x, base.transform.position.y, vector.y);
		return result;
	}

	private void MeteorAttackHurt(int index)
	{
		int num = 0;
		ExtraAttackMaker(0);
		ExtraAttackEffect();
		if (Crazy_GlobalData.enemyList == null)
		{
			return;
		}
		Dictionary<int, GameObject>.KeyCollection keys = Crazy_GlobalData.enemyList.Keys;
		foreach (int item in keys)
		{
			GameObject curEnemyObj;
			if (!Crazy_GlobalData.enemyList.TryGetValue(item, out curEnemyObj) || attacklist.Exists((GameObject a) => a == curEnemyObj))
			{
				continue;
			}
			Crazy_EnemyControl crazy_EnemyControl = curEnemyObj.GetComponent("Crazy_EnemyControl") as Crazy_EnemyControl;
			if (crazy_EnemyControl.IsDie() || !crazy_EnemyControl.GetActive())
			{
				continue;
			}
			Vector3 position = meteorHitEffectobj[index].transform.position;
			Vector3 vector = new Vector3(crazy_EnemyControl.transform.position.x, 0f, crazy_EnemyControl.transform.position.z);
			Vector3 vector2 = position - vector;
			explodepos = position;
			float sqrMagnitude = vector2.sqrMagnitude;
			if (!(sqrMagnitude < (cur_attackstatus.attackjudgmentinfo[0].attackrange + crazy_EnemyControl.GetHitBox()) * (cur_attackstatus.attackjudgmentinfo[0].attackrange + crazy_EnemyControl.GetHitBox())))
			{
				continue;
			}
			float num2 = Vector3.Angle(-vector2, base.transform.forward);
			if (num2 < cur_attackstatus.attackjudgmentinfo[0].attackangle)
			{
				if (!is_attack_pause && is_attack_pause_on && cur_attackstatus.attackjudgmentinfo[0].attackpause)
				{
					PlayAttackPauseEffect(cur_attackstatus.attackjudgmentinfo[0].attackpausetime, 0.1f);
					crazy_EnemyControl.Pause(cur_attackstatus.attackjudgmentinfo[0].attackpausetime);
				}
				else if (is_attack_pause)
				{
					crazy_EnemyControl.Pause(cur_attackstatus.attackjudgmentinfo[0].attackpausetime);
				}
				if (!is_shakescreen_effect && cur_attackstatus.attackjudgmentinfo[0].attackshake)
				{
					PlayShakeSceenEffect(cur_attackstatus.attackjudgmentinfo[0].attackshaketime, cur_attackstatus.attackjudgmentinfo[0].attackshakeintervaltime, cur_attackstatus.attackjudgmentinfo[0].attackshakeamplitude);
				}
				Vector3 vector3 = default(Vector3);
				vector3 = curEnemyObj.transform.position - base.transform.position;
				vector3.Normalize();
				cur_attackstatus.attackjudgmentinfo[0].hitdata.beatDir = vector3;
				if (crazy_EnemyControl.Hurt(cur_attackstatus.attackjudgmentinfo[0].attackdamage * (weapondamage + (float)Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage) * class_damage_rate * GetComboRate(), cur_attackstatus.attackjudgmentinfo[0].hitdata, cur_weapon.type, usingskill))
				{
					num++;
				}
				isattackenemy = true;
				AddCombo();
				if (!IsSkill())
				{
					AddEnergy();
				}
				if (!cur_attackstatus.attackjudgmentinfo[0].attackreset)
				{
					attacklist.Add(curEnemyObj);
				}
			}
		}
		Crazy_GlobalData.max_single_kill_number = Mathf.Max(Crazy_GlobalData.max_single_kill_number, num);
		Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task01, 0, num);
		Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task02, 0, num);
		Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task03, 0, num);
		Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task04, 0, num);
		if (num >= 20)
		{
			Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task11, 0, 0f);
		}
		if (num >= 10)
		{
			Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task10, 0, 0f);
		}
		if (num >= 5)
		{
			Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task09, 0, 0f);
		}
	}

	protected override void SetSpeedRate(float rate)
	{
		speeduprate = rate;
	}

	protected override void AddAnimationEvent()
	{
	}
}
