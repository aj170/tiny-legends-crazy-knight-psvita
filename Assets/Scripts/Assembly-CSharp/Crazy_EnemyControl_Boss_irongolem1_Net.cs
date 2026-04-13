using System.Collections.Generic;
using TNetSdk;
using UnityEngine;

public class Crazy_EnemyControl_Boss_irongolem1_Net : Crazy_EnemyControl_Boss_Net
{
	protected float objectsamplerate = 1f / 30f;

	public Crazy_FlyingLine cyclone;

	public Crazy_Fallen fallstore;

	protected GameObject cyclonebig;

	protected GameObject fallstoretrigger;

	protected GameObject shakewave;

	protected GameObject appear;

	private bool isappearend;

	private bool shakerotate;

	private float shakeangle = 38f;

	private float shaketime = 1f;

	private float lastshaketime;

	private List<float> falllist = new List<float>();

	private int fallnumber;

	private bool begincyclone;

	private int cyclonenumber;

	private List<float> seedlist;

	private float lastcycloneinterval;

	private float cycloneinterval = 0.5f;

	private float cycloneskilltime = 10f;

	private float cycloneskilllasttime;

	private void Start()
	{
		preStart();
		ReadStatus("irongolem1_netskill", "irongolem1_netstatus");
		base.GetComponent<Animation>().wrapMode = WrapMode.Once;
		base.GetComponent<Animation>()["Idle01_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Attack03_01_merge"].wrapMode = WrapMode.ClampForever;
		base.GetComponent<Animation>()["Attack03_02_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Attack03_03_merge"].wrapMode = WrapMode.ClampForever;
		base.GetComponent<Animation>()["Forward01_merge"].wrapMode = WrapMode.Loop;
		base.GetComponent<Animation>()["Death01_merge"].wrapMode = WrapMode.ClampForever;
		cyclonebig = Object.Instantiate(Resources.Load("Prefabs/BossSkillNew/Cyclone/CycloneBig_pfb")) as GameObject;
		cyclonebig.transform.parent = base.gameObject.transform;
		cyclonebig.transform.localPosition = Vector3.zero;
		cyclonebig.transform.localEulerAngles = Vector3.zero;
		fallstoretrigger = Object.Instantiate(Resources.Load("Prefabs/BossSkillNew/FallStore/FallStoreTrigger_pfb")) as GameObject;
		fallstoretrigger.transform.parent = base.gameObject.transform;
		fallstoretrigger.transform.localPosition = Vector3.zero;
		fallstoretrigger.transform.localEulerAngles = Vector3.zero;
		shakewave = Object.Instantiate(Resources.Load("Prefabs/BossSkillNew/ShakeWave/ShakeWave_pfb")) as GameObject;
		shakewave.transform.parent = base.gameObject.transform;
		shakewave.transform.localPosition = Vector3.zero;
		shakewave.transform.localEulerAngles = Vector3.zero;
		appear = Object.Instantiate(Resources.Load("Prefabs/BossSkillNew/Appear/Appear_pfb")) as GameObject;
		appear.transform.parent = base.gameObject.transform;
		appear.transform.localPosition = Vector3.zero;
		appear.transform.localEulerAngles = Vector3.zero;
		bindobject.Add(cyclonebig);
		bindobject.Add(fallstoretrigger);
		bindobject.Add(shakewave);
		bindobject.Add(appear);
		AddAnimationEvent();
		Appear();
	}

	protected void EventAnimation(AnimationClip ani, int frame, string functionname, int intP = 0, float floatP = 0f, string stringP = "", Object objectP = null)
	{
		Crazy_Global.EventAnimation(ani, (float)frame * objectsamplerate, functionname, intP, floatP, stringP, objectP);
	}

	protected void AddAnimationEvent()
	{
		EventAnimation(base.GetComponent<Animation>()["Attack03_02_merge"].clip, 1, "CycloneEffect", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_merge"].clip, 74, "FallStoreTrigger", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 1, "ShakeWave", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 131, "OffAttack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 10, "FlyAway", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 90, "OnShakeWaveRotate", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 95, "OnAttackJudgment", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 105, "OnAttackJudgment", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill_merge"].clip, 115, "OnAttackJudgment", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Show_merge"].clip, 123, "AppearEnd", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Show_merge"].clip, 7, "AppearEffect", 0, 0f, string.Empty);
	}

	public void AppearEnd()
	{
		isappearend = true;
		base.GetComponent<Animation>().Play("Idle01_merge");
	}

	public void AppearEffect()
	{
		appear.GetComponent<Crazy_ParticleSystemSequenceScript>().Trigger();
	}

	protected void Appear()
	{
		isappearend = false;
		Crazy_PlayTAudio crazy_PlayTAudio = base.gameObject.GetComponent("Crazy_PlayTAudio") as Crazy_PlayTAudio;
		crazy_PlayTAudio.Play();
		base.GetComponent<Animation>().Play("Show_merge");
		Invoke("AppearEnd", 4.1f);
	}

	protected override void PlayHurtEffect(Crazy_Weapon_Type type)
	{
		if (!useeffect)
		{
			return;
		}
		GameObject attackEffect = target.GetComponent<Crazy_EffectManagement>().GetAttackEffect();
		if (attackEffect != null)
		{
			attackEffect.transform.localPosition = base.transform.localPosition + new Vector3(0f, hurteffectposy, 0f);
			Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = attackEffect.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
			if (crazy_ParticleSequenceScript != null)
			{
				crazy_ParticleSequenceScript.EmitParticle();
			}
			else if (type == Crazy_Weapon_Type.Staff)
			{
				attackEffect.GetComponentInChildren<ParticleSystem>().Play();
			}
			else
			{
				Crazy_PlayAnimation crazy_PlayAnimation = attackEffect.GetComponent("Crazy_PlayAnimation") as Crazy_PlayAnimation;
				crazy_PlayAnimation.Play();
			}
			Crazy_PlayTAudio crazy_PlayTAudio = attackEffect.GetComponent("Crazy_PlayTAudio") as Crazy_PlayTAudio;
			switch (type)
			{
			case Crazy_Weapon_Type.Sword:
				crazy_PlayTAudio.audioname = "Multi_SwordHitMetal01";
				break;
			case Crazy_Weapon_Type.Hammer:
				crazy_PlayTAudio.audioname = "Fx_HammerHitMetal";
				break;
			case Crazy_Weapon_Type.Axe:
				crazy_PlayTAudio.audioname = "Multi_AxeHitMetal01";
				break;
			case Crazy_Weapon_Type.Bow:
				crazy_PlayTAudio.audioname = "Ani_BowHit_Metal01";
				break;
			case Crazy_Weapon_Type.Staff:
				crazy_PlayTAudio.audioname = "MobaoHit01";
				break;
			}
			crazy_PlayTAudio.Play();
		}
		PlayEnchantEffect();
		PlayHurtEffectEx();
	}

	protected override void updateMove(float deltatime)
	{
		if ((curStatus != Crazy_MonsterStatus.Move && curStatus != Crazy_MonsterStatus.Run) || (!(Mathf.Abs(curMoveDir.x) > 0.001f) && !(Mathf.Abs(curMoveDir.z) > 0.001f)))
		{
			return;
		}
		if (cur_use_skill == null)
		{
			if (outalertmove)
			{
				outalertmove = false;
				outalertMoveDir = new Vector3(Random.Range(-100, 100), 0f, Random.Range(-100, 100));
				outalertMoveDir.Normalize();
			}
			curMoveDir = outalertMoveDir;
			Move(new Vector3(curMoveDir.x * deltatime * speedWalk * (1f - skillmoverate) * moverate, 0f, curMoveDir.z * deltatime * speedWalk * (1f - skillmoverate) * moverate));
		}
		else
		{
			curMoveDir.Normalize();
			Move(new Vector3(curMoveDir.x * deltatime * speedRun * (1f - skillmoverate) * moverate, 0f, curMoveDir.z * deltatime * speedRun * (1f - skillmoverate) * moverate));
		}
	}

	protected void UpdateCyclone()
	{
		if (cur_use_skill != null && (cur_use_skill.cur_data.id == 1 || cur_use_skill.cur_data.id == 2 || cur_use_skill.cur_data.id == 3) && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			cycloneskilllasttime += Time.deltaTime;
			if (cycloneskilllasttime >= cycloneskilltime)
			{
				cycloneskilllasttime = 0f;
				HideCycloneEffect();
				begincyclone = false;
				cyclonenumber = 0;
				seedlist = null;
				OffAttack();
			}
			lastcycloneinterval -= Time.deltaTime;
			if (lastcycloneinterval <= 0f)
			{
				Cyclone();
				lastcycloneinterval += cycloneinterval;
			}
		}
		else
		{
			cycloneskilllasttime = 0f;
			HideCycloneEffect();
			begincyclone = false;
			cyclonenumber = 0;
			seedlist = null;
		}
	}

	public void UpdateShakeWave()
	{
		if (cur_use_skill != null && (cur_use_skill.cur_data.id == 8 || cur_use_skill.cur_data.id == 7) && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use && shakerotate)
		{
			float num = Time.deltaTime * shakeangle;
			lastshaketime += Time.deltaTime;
			if (lastshaketime >= shaketime)
			{
				shakerotate = false;
				lastshaketime = 0f;
			}
			base.transform.localEulerAngles = new Vector3(base.transform.localEulerAngles.x, base.transform.localEulerAngles.y + num, base.transform.localEulerAngles.z);
		}
	}

	public void OnShakeWaveRotate()
	{
		shakerotate = true;
		if (cur_use_skill != null && cur_use_skill.cur_data.id == 7 && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			if (cur_use_skill.cur_data.seed >= 50f)
			{
				shakeangle = 38f;
			}
			else
			{
				shakeangle = -38f;
			}
		}
		else if (cur_use_skill != null && cur_use_skill.cur_data.id == 8 && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			if (cur_use_skill.cur_data.seed >= 50f)
			{
				shakeangle = 45f;
			}
			else
			{
				shakeangle = -45f;
			}
		}
	}

	public void ShakeWave()
	{
		shakewave.GetComponent<Crazy_ParticleSystemSequenceScript>().Trigger();
	}

	public void FlyAway()
	{
		Crazy_HitData crazy_HitData = default(Crazy_HitData);
		crazy_HitData.beatDir = target.transform.position - base.transform.position;
		crazy_HitData.beatDir.Normalize();
		crazy_HitData.beatSpeed = 10f;
		crazy_HitData.beatTime = 1.6f;
		crazy_HitData.hitrecovertime = 1.6f;
		target.SendMessage("OnFlyAway", crazy_HitData, SendMessageOptions.DontRequireReceiver);
	}

	protected void FallStoreOnce(Vector3 position)
	{
		GameObject gameObject = Object.Instantiate(fallstore.gameObject) as GameObject;
		gameObject.transform.position = position;
		gameObject.GetComponent<Crazy_Fallen>().SetTarget(target);
		gameObject.SendMessage("Trigger", SendMessageOptions.DontRequireReceiver);
		gameObject.SendMessage("OnFly", SendMessageOptions.DontRequireReceiver);
	}

	protected void FallStoreRandom(Vector3 position)
	{
		Vector3 vector = new Vector3(falllist[fallnumber], 0f, falllist[fallnumber + 1]);
		vector.Normalize();
		fallnumber++;
		FallStoreOnce(position + vector * 6f);
	}

	public void FallStore()
	{
		falllist.Clear();
		falllist = Crazy_Global.RandomSeed(cur_use_skill.cur_data.seed, 30);
		fallnumber = 0;
		if (cur_use_skill.cur_data.id == 4)
		{
			FallStoreOnce(target.transform.position);
			{
				foreach (GameObject value in NetworkPlayerManager.Instance.GetPlayer().Values)
				{
					FallStoreOnce(value.transform.position);
				}
				return;
			}
		}
		if (cur_use_skill.cur_data.id == 5)
		{
			FallStoreOnce(target.transform.position);
			foreach (GameObject value2 in NetworkPlayerManager.Instance.GetPlayer().Values)
			{
				FallStoreOnce(value2.transform.position);
			}
			FallStoreRandom(reftarget.transform.position);
			FallStoreRandom(reftarget.transform.position);
		}
		else
		{
			if (cur_use_skill.cur_data.id != 6)
			{
				return;
			}
			FallStoreOnce(target.transform.position);
			foreach (GameObject value3 in NetworkPlayerManager.Instance.GetPlayer().Values)
			{
				FallStoreOnce(value3.transform.position);
			}
			List<TNetUser> list = new List<TNetUser>();
			foreach (TNetUser key in NetworkPlayerManager.Instance.GetPlayer().Keys)
			{
				list.Add(key);
			}
			list.Add(TNetManager.Connection.Myself);
			list.Sort((TNetUser a, TNetUser b) => a.Id.CompareTo(b.Id));
			foreach (TNetUser item in list)
			{
				if (item == TNetManager.Connection.Myself)
				{
					FallStoreRandom(target.transform.position);
					FallStoreRandom(target.transform.position);
				}
				else
				{
					FallStoreRandom(NetworkPlayerManager.Instance.GetPlayer()[item].transform.position);
					FallStoreRandom(NetworkPlayerManager.Instance.GetPlayer()[item].transform.position);
				}
			}
		}
	}

	public void FallStoreTrigger()
	{
		fallstoretrigger.GetComponent<Crazy_ParticleSystemSequenceScript>().Trigger();
		FallStore();
	}

	public void Cyclone()
	{
		if (cur_use_skill != null && (cur_use_skill.cur_data.id == 1 || cur_use_skill.cur_data.id == 2 || cur_use_skill.cur_data.id == 3) && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			cyclonenumber++;
			if (seedlist == null)
			{
				seedlist = Crazy_Global.RandomSeed(cur_use_skill.cur_data.seed, 120);
			}
			if (cyclonenumber < seedlist.Count - 1)
			{
				cyclone.moveDir = new Vector3(seedlist[cyclonenumber], 0f, seedlist[cyclonenumber + 1]);
				cyclone.moveDir.Normalize();
				cyclone.TargetList.Clear();
				cyclone.TargetList.Add(target);
				Object.Instantiate(cyclone.gameObject, base.transform.position, base.transform.rotation);
			}
		}
	}

	public void InitCyclone()
	{
		if (cur_use_skill != null && cur_use_skill.cur_data.id == 1 && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			cycloneskilltime = 6f;
			cycloneinterval = 1f;
			cyclone.Speed = 8f;
			cyclone.survive = 9f;
		}
		else if (cur_use_skill != null && cur_use_skill.cur_data.id == 2 && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			cycloneskilltime = 8f;
			cycloneinterval = 0.5f;
			cyclone.Speed = 12f;
			cyclone.survive = 6f;
		}
		else if (cur_use_skill != null && cur_use_skill.cur_data.id == 3 && cur_use_skill.cur_process == Crazy_Boss_Skill_Process.Use)
		{
			cycloneskilltime = 10f;
			cycloneinterval = 1f / 3f;
			cyclone.Speed = 18f;
			cyclone.survive = 4f;
		}
	}

	public void CycloneEffect()
	{
		if (!begincyclone)
		{
			cyclonebig.GetComponent<Crazy_ParticleSystemSequenceScript>().Trigger();
			cyclonebig.GetComponent<Crazy_PlayTAudio>().Play();
			InitCyclone();
			lastcycloneinterval = cycloneinterval;
		}
		begincyclone = true;
	}

	public void HideCycloneEffect()
	{
		cyclonebig.GetComponent<Crazy_ParticleSystemSequenceScript>().Stop();
		cyclonebig.GetComponent<Crazy_PlayTAudio>().Stop();
	}

	public override void OnAttackJudgment()
	{
		if (AttackJudgment())
		{
			Crazy_PlayerControl crazy_PlayerControl = target.GetComponent("Crazy_PlayerControl") as Crazy_PlayerControl;
			if (!crazy_PlayerControl.Invincible())
			{
				m_hitdata.beatDir = target.transform.position - base.transform.position;
				m_hitdata.beatDir.Normalize();
				m_hitdata.beatSpeed = powerbase * powerrate;
				crazy_PlayerControl.Injury(m_hitdata);
			}
		}
	}

	public void PlaySkill1Effect(string name)
	{
	}

	public void PlaySkill2Effect(int id)
	{
	}

	protected override void Die()
	{
		base.Die();
		foreach (GameObject item in bindobject)
		{
			item.SendMessage("Stop", SendMessageOptions.DontRequireReceiver);
		}
	}

	protected override void Update()
	{
		if (!isappearend)
		{
			updateDrop();
			updateinvincible();
			updateBloodSlot();
			return;
		}
		base.Update();
		if (curStatus != Crazy_MonsterStatus.Die)
		{
			UpdateCyclone();
			UpdateShakeWave();
		}
	}

	protected override void PlayAnimation(Crazy_MonsterStatus toStatus)
	{
		switch (toStatus)
		{
		case Crazy_MonsterStatus.Idle:
			base.GetComponent<Animation>().CrossFade("Idle01_merge", 0.01f);
			break;
		case Crazy_MonsterStatus.Move:
			base.GetComponent<Animation>()["Forward01_merge"].speed = speedWalk * (1f - skillmoverate) * moverate / 5f;
			base.GetComponent<Animation>().CrossFade("Forward01_merge", 0.01f);
			break;
		case Crazy_MonsterStatus.Run:
			base.GetComponent<Animation>()["Forward01_merge"].speed = speedRun * (1f - skillmoverate) * moverate / 5f;
			base.GetComponent<Animation>().CrossFade("Forward01_merge", 0.01f);
			break;
		case Crazy_MonsterStatus.Die:
			base.GetComponent<Animation>().CrossFade("Death01_merge", 0.01f);
			break;
		case Crazy_MonsterStatus.PreAttack:
			if (cur_use_skill != null && cur_use_skill.cur_data.preparetime > 0.01f && base.GetComponent<Animation>()[cur_use_skill.cur_data.preanimationname + "_merge"] != null)
			{
				base.GetComponent<Animation>().CrossFade(cur_use_skill.cur_data.preanimationname + "_merge", 0.01f);
			}
			break;
		case Crazy_MonsterStatus.Attack:
			if (cur_use_skill != null && base.GetComponent<Animation>()[cur_use_skill.cur_data.useanimationname + "_merge"] != null)
			{
				base.GetComponent<Animation>().CrossFade(cur_use_skill.cur_data.useanimationname + "_merge", 0.01f);
			}
			break;
		case Crazy_MonsterStatus.EndAttack:
			if (cur_use_skill != null && cur_use_skill.cur_data.endtime > 0.01f && base.GetComponent<Animation>()[cur_use_skill.cur_data.endanimationname + "_merge"] != null)
			{
				base.GetComponent<Animation>().CrossFade(cur_use_skill.cur_data.endanimationname + "_merge", 0.01f);
			}
			break;
		case Crazy_MonsterStatus.HitRecover:
			base.GetComponent<Animation>().CrossFade("Idle01_merge", 0.01f);
			break;
		case Crazy_MonsterStatus.Hurt:
			base.GetComponent<Animation>().Play("Idle01_merge");
			break;
		case Crazy_MonsterStatus.Remote:
			break;
		}
	}

	public override void SetHurtAnimationEffect(float effect)
	{
	}

	public override Renderer[] FindMeshRenderer()
	{
		return new Renderer[1] { base.gameObject.transform.Find("body").gameObject.GetComponent<Renderer>() };
	}
}
