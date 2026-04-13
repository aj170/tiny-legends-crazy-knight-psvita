using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(TAudioController))]
public class Crazy_PlayerControl : Crazy_ObjectControl, IColliderMessage
{
	public static GameObject player;

	private GameObject mainCameraParentObj;

	private GameObject mainCameraObj;

	private GameObject weaponObj;

	private GameObject shadowObject;

	private GameObject screenblood;

	private GameObject invincibleObj;

	private GameObject speedupObj;

	private GameObject increaseblood;

	private GameObject hurteffectObj;

	protected Crazy_Weapon cur_weapon;

	protected List<GameObject> attacklist = new List<GameObject>();

	protected Dictionary<string, Crazy_AttackStatus> attackstatus = new Dictionary<string, Crazy_AttackStatus>();

	protected Crazy_AttackStatus cur_attackstatus = new Crazy_AttackStatus();

	protected Crazy_AttackStatus pre_attackstatus = new Crazy_AttackStatus();

	protected GameObject[] attack_effect_Obj;

	protected Dictionary<string, GameObject> attackeffectdic = new Dictionary<string, GameObject>();

	private Crazy_PlayerStatus cur_up_Status = Crazy_PlayerStatus.Idle;

	private Crazy_PlayerStatus cur_down_Status = Crazy_PlayerStatus.Stand;

	protected int maxhealth = 3;

	protected int cur_health = -1;

	public bool IsHurtted;

	protected Vector3 curMoveDir = Vector3.zero;

	protected Vector3 curAttackDir = Vector3.zero;

	protected Vector3 curForwardDir = Vector3.zero;

	private float speed = 1f;

	private float weaponspeed = 1f;

	protected float speeduprate = 1f;

	private float speeduptime = 15f;

	private float lastspeeduptime;

	private bool speedup;

	protected bool attacking;

	protected bool attackrecovering;

	protected float lastattackrecoveringtime;

	protected bool isattackenemy;

	protected float lastattackingtime = 10000f;

	private bool attackmove;

	protected float lastattackmovetime = -10000f;

	private float curattackmovespeed;

	private float halfplayerheight = 1.75f;

	private float halfplayerwidth = 1f;

	protected bool btouchground;

	private int combocount;

	private float combotime = 1.5f;

	private float lastcombotime;

	private int maxcombo;

	private float comborate = 0.1f;

	private float shakescreen_effect_time = 0.1f;

	private float shakescreen_effect_interval_time = 0.03f;

	private float lastshakescreen_effect_time;

	private float lastshakescreen_effect_interval_time;

	protected bool is_shakescreen_effect;

	private float shakescreenamplitude = 1f;

	private Vector3 back_camera_pos;

	protected bool is_attack_pause;

	private float attack_pause_time = 0.01f;

	private float last_attack_pause_time;

	private float attack_pause_interval_time = 2f;

	private float last_attack_pause_interval_time;

	protected bool is_attack_pause_on = true;

	protected List<float> lastattackjudgmenttime = new List<float>();

	protected float lastadvattackeffecttime;

	private float blood_time = 2f;

	private float last_blood_time;

	private Color blood_color;

	private bool invincible;

	private float invincibletime;

	private float lastinvincibletime;

	private bool invincible2;

	private float invincible2time;

	private float lastinvincible2time;

	private Dictionary<Material, Color> player_color = new Dictionary<Material, Color>();

	private bool invincible3;

	private float invincible3time;

	private float lastinvincible3time;

	protected int energy;

	private int max_attack_count = 4;

	protected float rollspeed = 15f;

	protected float rolltime = 0.5f;

	protected float lastrolltime;

	protected bool roll;

	protected float rollcooldowntime = 1.2f;

	protected float lastrollcooldowntime;

	protected bool rollcooldown;

	protected float rollrecovertime = 0.3f;

	protected float lastrollrecovertime;

	protected bool rollrecover;

	protected Vector3 rolldir = Vector3.zero;

	protected float animationspeedmodify = 0.7f;

	private TAudioController m_audiocontroller;

	protected GameObject RootNode;

	protected Vector3 explodepos;

	protected Crazy_ParticleSequenceScript hammerskilleffect;

	protected Crazy_PlayAnimation hammerskillhand;

	protected Crazy_PlayAnimation hammerskillmodel;

	protected Crazy_PlayAnimation axeskillmodel;

	protected GameObject[] swordskilleffectmodel;

	protected Crazy_ParticleSequenceScript swordchargeeffect;

	protected Crazy_ParticleSystemSequenceScript bowchargeeffect;

	protected Crazy_PlayAnimation bowarrow;

	protected Crazy_PlayAnimation levelupmodel;

	protected Crazy_ParticleSystemSequenceScript rainarroweffect;

	protected Crazy_ParticleSystemSequenceScript rainarrowintroeffect;

	protected Crazy_ParticleSystemSequenceScript rainarrowhiteffect;

	protected Crazy_ParticleSequenceScript levelupeffect;

	[NonSerialized]
	public float weapondamage;

	protected int goldscore;

	private float speedrate = 1f;

	protected bool useeffect = true;

	protected float class_damage_rate = 1f;

	protected float class_speed_rate;

	protected bool reducemove;

	protected float reducemoverate;

	protected bool reducespeed;

	protected float reducespeedrate;

	protected float skillinterval = 3f;

	protected float lastskillinterval;

	protected Crazy_HitRecover m_hitrecover;

	protected float lasthitrecovertime;

	protected float beatspeed;

	protected Vector3 hurt_vec3;

	protected float lasthurttime;

	protected float hurttime = 0.3f;

	protected bool isskill;

	protected float playersamplerate = 1f / 30f;

	protected bool usingskill;

	protected float movereduceparam = 0.1f;

	protected bool shotting;

	protected GameObject m_arrow;

	public bool bForbidRoll;

	public int GetMaxHealth()
	{
		return maxhealth;
	}

	public int GetCurHealth()
	{
		return cur_health;
	}

	private void Awake()
	{
		RootNode = GameObject.Find("Scene");
	}

	private void Start()
	{
		player = base.gameObject;
		mainCameraParentObj = GameObject.Find("MainCameraParentNode");
		mainCameraObj = mainCameraParentObj.transform.Find("Main Camera").gameObject;
		m_audiocontroller = base.gameObject.GetComponent("TAudioController") as TAudioController;
		cur_health = maxhealth;
		ModifyAnimation();
		Transform transform = base.transform.Find("zhujue");
		SkinnedMeshRenderer skinnedMeshRenderer = transform.gameObject.GetComponent("SkinnedMeshRenderer") as SkinnedMeshRenderer;
		Material[] materials = skinnedMeshRenderer.materials;
		for (int i = 0; i < materials.Length; i++)
		{
			player_color.Add(materials[i], materials[i].color);
		}
		GameObject gameObject = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/level up/level up_model_pfb")) as GameObject;
		gameObject.transform.parent = base.transform;
		gameObject.transform.localPosition = new Vector3(0f, 0.2f, 0f);
		levelupmodel = gameObject.GetComponent("Crazy_PlayAnimation") as Crazy_PlayAnimation;
		levelupmodel.Hide();
		gameObject = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/level up/level up_pfb")) as GameObject;
		gameObject.transform.parent = base.transform;
		gameObject.transform.localPosition = new Vector3(0f, 0.2f, 0f);
		levelupeffect = gameObject.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
		screenblood = GameObject.Find("Blood_pfb");
		MeshRenderer meshRenderer = screenblood.GetComponent("MeshRenderer") as MeshRenderer;
		blood_color = meshRenderer.material.color;
		CloseBloodEffect();
		invincibleObj = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/invincible/invincible_pfb")) as GameObject;
		invincibleObj.transform.parent = RootNode.transform;
		speedupObj = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/speed up/speedup_pfb")) as GameObject;
		speedupObj.transform.parent = base.transform;
		speedupObj.transform.localPosition = new Vector3(0f, 0.2f, 0f);
		increaseblood = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/increase blood/increase blood_pfb")) as GameObject;
		increaseblood.transform.parent = base.transform;
		increaseblood.transform.localPosition = Vector3.zero;
		hurteffectObj = UnityEngine.Object.Instantiate(Resources.Load("Prefabs/attack/attack_player/attack_player")) as GameObject;
		hurteffectObj.transform.parent = base.transform;
		hurteffectObj.transform.localPosition = new Vector3(0f, 1f, 0f);
		back_camera_pos = mainCameraObj.transform.localPosition;
		attackstatus = Crazy_AttackStatus.ReadAttackStatusInfo();
		m_hitrecover = new Crazy_HitRecover();
		m_hitrecover.InitializeEff(0f, 0f, 1f, 1f, 0f);
		InitShadow(2f);
		InitClass();
		InitRoll();
		if (Crazy_Beginner.instance.isSkill)
		{
			AddEnergy(100);
		}
	}

	public virtual string GetAttackStatusName()
	{
		if (cur_attackstatus != null && cur_attackstatus.attackname != null)
		{
			return cur_attackstatus.attackname;
		}
		return string.Empty;
	}

	public Crazy_PlayerStatus GetUpStatus()
	{
		return cur_up_Status;
	}

	protected virtual bool CheckAnimation()
	{
		return Mathf.Abs(base.GetComponent<Animation>()["Attack01_Sword01_merge"].speed - 1f * animationspeedmodify) <= 0.01f;
	}

	protected virtual void ModifyAnimation()
	{
		if (!CheckAnimation())
		{
			base.GetComponent<Animation>().wrapMode = WrapMode.Once;
			base.GetComponent<Animation>()["Forward01_Sword01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Forward01_Hammer01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Forward01_Axe01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Forward01_Bow01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle01_Sword01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle01_Hammer01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle01_Axe01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle01_Bow01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Death01_Sword01_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Death01_Hammer01_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Death01_Axe01_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Death01_Bow01_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Idle_Axe01_celebrate01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle_Hammer01_celebrate01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle_Sword01_celebrate01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Idle_Bow01_celebrate01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Sword01_lose_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Hammer01_lose_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Axe01_lose_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Bow01_lose_merge"].wrapMode = WrapMode.ClampForever;
			base.GetComponent<Animation>()["Attack01_Bow01_merge"].wrapMode = WrapMode.Loop;
			base.GetComponent<Animation>()["Forward01_Sword01_merge"].layer = 0;
			base.GetComponent<Animation>()["Forward01_Hammer01_merge"].layer = 0;
			base.GetComponent<Animation>()["Forward01_Axe01_merge"].layer = 0;
			base.GetComponent<Animation>()["Forward01_Bow01_merge"].layer = 0;
			base.GetComponent<Animation>()["Idle01_Sword01_merge"].layer = 0;
			base.GetComponent<Animation>()["Attack01_Sword01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack02_Sword01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack03_Sword01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack04_Sword01_merge"].layer = 2;
			base.GetComponent<Animation>()["Skill01_Sword01_merge"].layer = 2;
			base.GetComponent<Animation>()["Idle01_Hammer01_merge"].layer = 0;
			base.GetComponent<Animation>()["Attack01_Hammer01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack02_Hammer01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack03_Hammer01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack04_Hammer01_merge"].layer = 2;
			base.GetComponent<Animation>()["Skill01_Hammer01_merge"].layer = 2;
			base.GetComponent<Animation>()["Idle01_Axe01_merge"].layer = 0;
			base.GetComponent<Animation>()["Attack01_Axe01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack02_Axe01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack03_Axe01_merge"].layer = 2;
			base.GetComponent<Animation>()["Attack04_Axe01_merge"].layer = 2;
			base.GetComponent<Animation>()["Skill01_Axe01_merge"].layer = 2;
			base.GetComponent<Animation>()["Idle01_Bow01_merge"].layer = 0;
			base.GetComponent<Animation>()["Attack01_Bow01_merge"].layer = 2;
			base.GetComponent<Animation>()["Skill01_Bow01_merge"].layer = 2;
			base.GetComponent<Animation>()["Roll01_Sword01_merge"].layer = 3;
			base.GetComponent<Animation>()["Roll01_Axe01_merge"].layer = 3;
			base.GetComponent<Animation>()["Roll01_Hammer01_merge"].layer = 3;
			base.GetComponent<Animation>()["Roll01_Bow01_merge"].layer = 3;
			base.GetComponent<Animation>()["Damage01_Sword01_merge"].layer = 3;
			base.GetComponent<Animation>()["Damage01_Hammer01_merge"].layer = 3;
			base.GetComponent<Animation>()["Damage01_Axe01_merge"].layer = 3;
			base.GetComponent<Animation>()["Damage01_Bow01_merge"].layer = 3;
			base.GetComponent<Animation>()["Knockdown_Sword01_merge"].layer = 3;
			base.GetComponent<Animation>()["Knockdown_Hammer01_merge"].layer = 3;
			base.GetComponent<Animation>()["Knockdown_Axe01_merge"].layer = 3;
			base.GetComponent<Animation>()["Knockdown_Bow01_merge"].layer = 3;
			base.GetComponent<Animation>()["Death01_Sword01_merge"].layer = 4;
			base.GetComponent<Animation>()["Death01_Hammer01_merge"].layer = 4;
			base.GetComponent<Animation>()["Death01_Axe01_merge"].layer = 4;
			base.GetComponent<Animation>()["Death01_Bow01_merge"].layer = 4;
			base.GetComponent<Animation>()["Sword01_lose_merge"].layer = 4;
			base.GetComponent<Animation>()["Hammer01_lose_merge"].layer = 4;
			base.GetComponent<Animation>()["Axe01_lose_merge"].layer = 4;
			base.GetComponent<Animation>()["Bow01_lose_merge"].layer = 4;
			base.GetComponent<Animation>()["Idle_Axe01_celebrate01_merge"].layer = 5;
			base.GetComponent<Animation>()["Idle_Hammer01_celebrate01_merge"].layer = 5;
			base.GetComponent<Animation>()["Idle_Sword01_celebrate01_merge"].layer = 5;
			base.GetComponent<Animation>()["Idle_Bow01_celebrate01_merge"].layer = 5;
			base.GetComponent<Animation>()["Attack01_Sword01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack02_Sword01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack03_Sword01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack04_Sword01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Skill01_Sword01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack01_Hammer01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack02_Hammer01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack03_Hammer01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack04_Hammer01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Skill01_Hammer01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack01_Axe01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack02_Axe01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack03_Axe01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Attack04_Axe01_merge"].speed = 1f * animationspeedmodify;
			base.GetComponent<Animation>()["Skill01_Axe01_merge"].speed = 1f * animationspeedmodify;
			AddAnimationEvent();
		}
	}

	protected void EventAnimation(AnimationClip ani, int frame, string functionname, int intP = 0, float floatP = 0f, string stringP = "", UnityEngine.Object objectP = null)
	{
		Crazy_Global.EventAnimation(ani, (float)frame * playersamplerate, functionname, intP, floatP, stringP, objectP);
	}

	protected virtual void AddAnimationEvent()
	{
		EventAnimation(base.GetComponent<Animation>()["Attack01_Sword01_merge"].clip, 3, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Sword01_merge"].clip, 5, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Sword01_merge"].clip, 3, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Sword01_merge"].clip, 5, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Sword01_merge"].clip, 4, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Sword01_merge"].clip, 6, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Sword01_merge"].clip, 5, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Sword01_merge"].clip, 7, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Sword01_merge"].clip, 24, "ExtraAttackMakerPretreatment", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Sword01_merge"].clip, 29, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Hammer01_merge"].clip, 8, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Hammer01_merge"].clip, 10, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Hammer01_merge"].clip, 7, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Hammer01_merge"].clip, 9, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Hammer01_merge"].clip, 8, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Hammer01_merge"].clip, 10, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Hammer01_merge"].clip, 5, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Hammer01_merge"].clip, 10, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Hammer01_merge"].clip, 32, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Axe01_merge"].clip, 7, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Axe01_merge"].clip, 9, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Axe01_merge"].clip, 5, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack02_Axe01_merge"].clip, 7, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Axe01_merge"].clip, 6, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack03_Axe01_merge"].clip, 8, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Axe01_merge"].clip, 7, "OnPlayUVAnimationCallBack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack04_Axe01_merge"].clip, 10, "AttackEnemy", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Bow01_merge"].clip, 5, "PlayArrowEffect", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Bow01_merge"].clip, 7, "PlayShotIntroEffect", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Attack01_Bow01_merge"].clip, 7, "BowAttack", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Bow01_merge"].clip, 43, "PlayRainArrowIntroEffect", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Bow01_merge"].clip, 60, "PlayRainArrowHitEffect", 0, 0f, string.Empty);
		EventAnimation(base.GetComponent<Animation>()["Skill01_Bow01_merge"].clip, 68, "AttackEnemy", 0, 0f, string.Empty);
	}

	protected virtual void InitRoll()
	{
		Crazy_Roll rollInfo = Crazy_Roll.GetRollInfo(cur_weapon.type);
		if (rollInfo != null)
		{
			rolltime = rollInfo.rolltime;
			rollspeed = rollInfo.rollspeed;
			rollrecovertime = rollInfo.rollrecovertime;
			rollcooldowntime = rollInfo.rollcd;
			Debug.Log("--------------" + rollrecovertime + "---" + rollcooldowntime);
		}
	}

	protected void InitClass()
	{
		switch (Crazy_Data.CurData().GetPlayerClass())
		{
		case Crazy_PlayerClass.Fighter:
			switch (cur_weapon.type)
			{
			case Crazy_Weapon_Type.Sword:
				class_damage_rate = 1.1f;
				class_speed_rate = 0.5f;
				break;
			case Crazy_Weapon_Type.Hammer:
			case Crazy_Weapon_Type.Axe:
				class_damage_rate = 1f;
				class_speed_rate = -0.5f;
				break;
			}
			break;
		case Crazy_PlayerClass.Knight:
			switch (cur_weapon.type)
			{
			case Crazy_Weapon_Type.Sword:
				class_damage_rate = 0.9f;
				class_speed_rate = 0f;
				break;
			case Crazy_Weapon_Type.Axe:
				class_damage_rate = 1.1f;
				class_speed_rate = 0f;
				break;
			case Crazy_Weapon_Type.Hammer:
				class_damage_rate = 1f;
				class_speed_rate = 0f;
				break;
			}
			break;
		case Crazy_PlayerClass.Warrior:
			switch (cur_weapon.type)
			{
			case Crazy_Weapon_Type.Sword:
				class_damage_rate = 0.8f;
				class_speed_rate = 0f;
				break;
			case Crazy_Weapon_Type.Axe:
				class_damage_rate = 1f;
				class_speed_rate = 0f;
				break;
			case Crazy_Weapon_Type.Hammer:
				class_damage_rate = 1.1f;
				class_speed_rate = 0.5f;
				break;
			}
			break;
		case Crazy_PlayerClass.Rogue:
			switch (cur_weapon.type)
			{
			case Crazy_Weapon_Type.Sword:
			case Crazy_Weapon_Type.Hammer:
			case Crazy_Weapon_Type.Axe:
				class_damage_rate = 0.95f;
				break;
			case Crazy_Weapon_Type.Bow:
				class_damage_rate = 1.1f;
				break;
			}
			break;
		case Crazy_PlayerClass.Paladin:
			class_damage_rate = 1.1f;
			class_speed_rate = 0f;
			break;
		case Crazy_PlayerClass.Mage:
			class_damage_rate = 1f;
			class_speed_rate = 0f;
			break;
		default:
			Debug.LogError("ClassError");
			break;
		}
	}

	private GameObject FindWeaponBone(Crazy_Weapon_Type cwt, GameObject person)
	{
		switch (cwt)
		{
		case Crazy_Weapon_Type.Sword:
		case Crazy_Weapon_Type.Hammer:
		case Crazy_Weapon_Type.Axe:
		case Crazy_Weapon_Type.Staff:
			return person.transform.Find("Bone/Pelvis/Spine/Right_Shoulder/Right_Hand/Weapon").gameObject;
		case Crazy_Weapon_Type.Bow:
			return person.transform.Find("Bone/Pelvis/Spine/Left_Shoulder/Left_Hand/L_Weapon").gameObject;
		default:
			return null;
		}
	}

	public GameObject GetWeaponBone()
	{
		return FindWeaponBone(cur_weapon.type, base.gameObject);
	}

	public void SetEffect(bool effect)
	{
		useeffect = effect;
	}

	public bool GetSkill()
	{
		return isskill;
	}

	public void SetSkill(bool setparam)
	{
		isskill = setparam;
	}

	public void SetMaxHealth(int health)
	{
		maxhealth += health;
		if (health >= 0)
		{
			cur_health += health;
		}
		else if (cur_health > maxhealth)
		{
			cur_health = maxhealth;
		}
	}

	public void SetReduceMove(bool onoff, float rate)
	{
		reducemove = onoff;
		reducemoverate = rate;
	}

	public void SetReduceSpeed(bool onoff, float rate)
	{
		reducespeed = onoff;
		reducespeedrate = rate;
	}

	protected void PlayIncreaseBloodEffect()
	{
		Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = increaseblood.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
		crazy_ParticleSequenceScript.EmitParticle();
	}

	public void SetCurWeapon(Crazy_Weapon weapon, GameObject _weaponObj)
	{
		cur_weapon = weapon;
		base.GetComponent<Animation>().Play("Idle01_" + cur_weapon.type_name + "01_merge");
		weaponObj = _weaponObj;
		cur_weapon.AddWeaponSkill(this);
		InitWeaponEffect();
		InitWeaponData();
	}

	public void DeleteCurWeapon()
	{
		if (cur_weapon != null)
		{
			cur_weapon.RemoveWeaponSkill();
		}
	}

	protected void InitWeaponData()
	{
		weapondamage = cur_weapon.damage;
		weaponspeed = cur_weapon.move;
		SetSpeedRate(1f);
	}

	protected virtual void InitWeaponEffect()
	{
		attackeffectdic.Clear();
		attackeffectdic = new Dictionary<string, GameObject>();
		switch (cur_weapon.type)
		{
		case Crazy_Weapon_Type.Sword:
		{
			swordskilleffectmodel = new GameObject[3];
			for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
			{
				swordskilleffectmodel[i] = Crazy_Global.LoadAssetsPrefab("Prefabs/swordskilleffect/swordskilleffect_pfb");
				swordskilleffectmodel[i].layer = LayerMask.NameToLayer("Player");
				swordskilleffectmodel[i].name = "swordskillmodel_effect" + (i + 1).ToString("D2");
				swordskilleffectmodel[i].transform.parent = RootNode.transform;
			}
			GameObject gameObject10 = Crazy_Global.LoadAssetsPrefab("Prefabs/charge/charge_pfb");
			swordchargeeffect = gameObject10.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
			swordchargeeffect.gameObject.layer = LayerMask.NameToLayer("Player");
			swordchargeeffect.gameObject.name = "SwordChargeEffect";
			swordchargeeffect.gameObject.transform.parent = weaponObj.transform;
			swordchargeeffect.gameObject.transform.localPosition = new Vector3(0f, 0f, 1.7f);
			break;
		}
		case Crazy_Weapon_Type.Hammer:
		{
			GameObject gameObject5 = Crazy_Global.LoadAssetsPrefab("Prefabs/fracturing/fracturing_pfb");
			gameObject5.layer = LayerMask.NameToLayer("Player");
			gameObject5.name = "fracturing_effect";
			gameObject5.transform.parent = RootNode.transform;
			attackeffectdic.Add("Fracturing", gameObject5);
			gameObject5 = Crazy_Global.LoadAssetsPrefab("Prefabs/crack/crack_pfb");
			gameObject5.layer = LayerMask.NameToLayer("Player");
			gameObject5.name = "crack_effect";
			gameObject5.transform.parent = RootNode.transform;
			attackeffectdic.Add("Crack", gameObject5);
			GameObject gameObject7 = Crazy_Global.LoadAssetsPrefab("Prefabs/hammerskillmodel/hammerskillmodel_pfb");
			gameObject7.layer = LayerMask.NameToLayer("Player");
			gameObject7.name = "hammerskill_model";
			gameObject7.transform.parent = gameObject5.transform;
			gameObject7.transform.localPosition = Vector3.zero;
			hammerskillmodel = gameObject7.GetComponent("Crazy_PlayAnimation") as Crazy_PlayAnimation;
			hammerskillmodel.Hide();
			GameObject gameObject8 = Crazy_Global.LoadAssetsPrefab("Prefabs/hammerskilleffect/hammerskilleffect_pfb");
			gameObject8.layer = LayerMask.NameToLayer("Player");
			gameObject8.name = "hammerskill_effect";
			gameObject8.transform.parent = base.transform;
			gameObject8.transform.localPosition = Vector3.zero;
			hammerskilleffect = gameObject8.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
			GameObject gameObject9 = Crazy_Global.LoadAssetsPrefab("Prefabs/hammerskilleffect/hammerskillhand_pfb");
			gameObject9.layer = LayerMask.NameToLayer("Player");
			gameObject9.name = "hammerskill_hand";
			gameObject9.transform.parent = base.transform;
			gameObject9.transform.localPosition = Vector3.zero;
			hammerskillhand = gameObject9.GetComponent("Crazy_PlayAnimation") as Crazy_PlayAnimation;
			hammerskillhand.Hide();
			break;
		}
		case Crazy_Weapon_Type.Axe:
		{
			GameObject gameObject5 = Crazy_Global.LoadAssetsPrefab("Prefabs/fissure/fissure_pfb");
			gameObject5.layer = LayerMask.NameToLayer("Player");
			gameObject5.name = "fissure_effect";
			gameObject5.transform.parent = RootNode.transform;
			attackeffectdic.Add("Fissure", gameObject5);
			gameObject5 = Crazy_Global.LoadAssetsPrefab("Prefabs/axeskilleffect/axeskilleffect_pfb");
			gameObject5.layer = LayerMask.NameToLayer("Player");
			gameObject5.name = "axeskill_effect";
			gameObject5.transform.parent = RootNode.transform;
			attackeffectdic.Add("AxeSkill", gameObject5);
			GameObject gameObject6 = Crazy_Global.LoadAssetsPrefab("Prefabs/axeskillmodel/axeskillmodel_pfb");
			gameObject6.layer = LayerMask.NameToLayer("Player");
			gameObject6.name = "axeskill_model";
			gameObject6.transform.parent = gameObject5.transform;
			gameObject6.transform.localPosition = Vector3.zero;
			axeskillmodel = gameObject6.GetComponent("Crazy_PlayAnimation") as Crazy_PlayAnimation;
			axeskillmodel.Hide();
			break;
		}
		case Crazy_Weapon_Type.Bow:
		{
			GameObject gameObject = Crazy_Global.LoadAssetsPrefab("Prefabs/bowintro/bowintro_pfb");
			gameObject.layer = LayerMask.NameToLayer("Player");
			gameObject.name = "bowintro_effect";
			gameObject.transform.parent = base.gameObject.transform;
			gameObject.transform.localPosition = Vector3.zero;
			bowchargeeffect = gameObject.GetComponent("Crazy_ParticleSystemSequenceScript") as Crazy_ParticleSystemSequenceScript;
			GameObject gameObject2 = Crazy_Global.LoadAssetsPrefab("Prefabs/rainarrow/rainarrow_pfb");
			gameObject2.layer = LayerMask.NameToLayer("Player");
			gameObject2.name = "rainarrow_effect";
			gameObject2.transform.parent = base.gameObject.transform;
			gameObject2.transform.localPosition = Vector3.zero;
			rainarroweffect = gameObject2.GetComponent("Crazy_ParticleSystemSequenceScript") as Crazy_ParticleSystemSequenceScript;
			GameObject gameObject3 = Crazy_Global.LoadAssetsPrefab("Prefabs/rainarrow/rainarrowintro_pfb");
			gameObject3.layer = LayerMask.NameToLayer("Player");
			gameObject3.name = "rainarrowintro_effect";
			gameObject3.transform.parent = base.gameObject.transform;
			gameObject3.transform.localPosition = Vector3.zero;
			rainarrowintroeffect = gameObject3.GetComponent("Crazy_ParticleSystemSequenceScript") as Crazy_ParticleSystemSequenceScript;
			GameObject gameObject4 = Crazy_Global.LoadAssetsPrefab("Prefabs/rainarrow/rainarrowhit_pfb");
			gameObject4.layer = LayerMask.NameToLayer("Player");
			gameObject4.name = "rainarrowhit_effect";
			gameObject4.transform.parent = RootNode.transform;
			gameObject4.transform.localPosition = Vector3.zero;
			rainarrowhiteffect = gameObject4.GetComponent("Crazy_ParticleSystemSequenceScript") as Crazy_ParticleSystemSequenceScript;
			break;
		}
		}
		InitWeaponLight();
	}

	public GameObject GetRootNode()
	{
		return RootNode;
	}

	protected void InitWeaponLight()
	{
		attack_effect_Obj = new GameObject[4];
		switch (cur_weapon.type)
		{
		case Crazy_Weapon_Type.Sword:
		{
			for (int j = 0; j < 4; j++)
			{
				attack_effect_Obj[j] = Crazy_Global.LoadAssetsPrefab("Prefabs/swordlighting/swordlighting_m_" + (j + 1).ToString("D2") + "_pfb");
				attack_effect_Obj[j].layer = LayerMask.NameToLayer("Player");
				attack_effect_Obj[j].name = "sword_attack" + j + "effect";
				attack_effect_Obj[j].transform.localPosition = Vector3.zero;
				attack_effect_Obj[j].transform.parent = RootNode.transform;
				List<Component> list = new List<Component>(attack_effect_Obj[j].GetComponentsInChildren(typeof(Renderer)));
				List<Renderer> list2 = list.ConvertAll((Component c) => (Renderer)c);
				foreach (Renderer item in list2)
				{
					Color color2 = item.material.GetColor("_TintColor");
					color2.a = 0f;
					item.material.SetColor("_TintColor", color2);
				}
			}
			break;
		}
		case Crazy_Weapon_Type.Hammer:
		{
			for (int k = 0; k < 4; k++)
			{
				attack_effect_Obj[k] = Crazy_Global.LoadAssetsPrefab("Prefabs/hammerlighting/hammerlighting_m_" + (k + 1).ToString("D2") + "_pfb");
				attack_effect_Obj[k].layer = LayerMask.NameToLayer("Player");
				attack_effect_Obj[k].name = "hammer_attack" + k + "effect";
				attack_effect_Obj[k].transform.localPosition = Vector3.zero;
				attack_effect_Obj[k].transform.parent = RootNode.transform;
				List<Component> list = new List<Component>(attack_effect_Obj[k].GetComponentsInChildren(typeof(Renderer)));
				List<Renderer> list2 = list.ConvertAll((Component c) => (Renderer)c);
				foreach (Renderer item2 in list2)
				{
					Color color3 = item2.material.GetColor("_TintColor");
					color3.a = 0f;
					item2.material.SetColor("_TintColor", color3);
				}
			}
			break;
		}
		case Crazy_Weapon_Type.Axe:
		{
			for (int i = 0; i < 4; i++)
			{
				attack_effect_Obj[i] = Crazy_Global.LoadAssetsPrefab("Prefabs/axelighting/axelighting_m_" + (i + 1).ToString("D2") + "_pfb");
				attack_effect_Obj[i].layer = LayerMask.NameToLayer("Player");
				attack_effect_Obj[i].name = "axe_attack" + i + "effect";
				attack_effect_Obj[i].transform.localPosition = Vector3.zero;
				attack_effect_Obj[i].transform.parent = RootNode.transform;
				List<Component> list = new List<Component>(attack_effect_Obj[i].GetComponentsInChildren(typeof(Renderer)));
				List<Renderer> list2 = list.ConvertAll((Component c) => (Renderer)c);
				foreach (Renderer item3 in list2)
				{
					Color color = item3.material.GetColor("_TintColor");
					color.a = 0f;
					item3.material.SetColor("_TintColor", color);
				}
			}
			break;
		}
		}
	}

	protected void InitShadow(float size)
	{
		shadowObject = new GameObject("shadow", typeof(MeshFilter), typeof(MeshRenderer));
		shadowObject.GetComponent<Renderer>().material = Resources.Load("Textures/character_shadow_M") as Material;
		MeshFilter meshFilter = shadowObject.GetComponent("MeshFilter") as MeshFilter;
		Vector3[] array = new Vector3[4];
		Vector2[] array2 = new Vector2[4];
		int[] array3 = new int[6];
		array[0] = new Vector3(0.5f * size, 0.1f, -0.3f * size);
		array[1] = new Vector3(0.5f * size, 0.1f, 0.3f * size);
		array[2] = new Vector3(-0.5f * size, 0.1f, -0.3f * size);
		array[3] = new Vector3(-0.5f * size, 0.1f, 0.3f * size);
		array2[0] = new Vector2(0f, 1f);
		array2[1] = new Vector2(0f, 0f);
		array2[2] = new Vector2(1f, 1f);
		array2[3] = new Vector2(1f, 0f);
		array3[0] = 0;
		array3[1] = 2;
		array3[2] = 1;
		array3[3] = 1;
		array3[4] = 2;
		array3[5] = 3;
		meshFilter.mesh.vertices = array;
		meshFilter.mesh.uv = array2;
		meshFilter.mesh.triangles = array3;
		shadowObject.transform.parent = base.transform;
		shadowObject.transform.localPosition = Vector3.zero;
		shadowObject.layer = base.gameObject.layer;
	}

	public int GetMaxCombo()
	{
		return maxcombo;
	}

	public void AddCombo()
	{
		combocount++;
		maxcombo = Mathf.Max(maxcombo, combocount);
		lastcombotime = 0f;
	}

	public void AddEnergy()
	{
		AddEnergy(1);
	}

	protected void ResetCombo()
	{
		combocount = 0;
		lastcombotime = 0f;
	}

	protected void updateCombo()
	{
		lastcombotime += Time.deltaTime;
		if (lastcombotime >= combotime)
		{
			ResetCombo();
		}
	}

	protected void SetRandomCameraPosition()
	{
		mainCameraObj.transform.localPosition = back_camera_pos + UnityEngine.Random.Range(-0.15f * shakescreenamplitude, 0.15f * shakescreenamplitude) * base.transform.up + UnityEngine.Random.Range(-0.15f * shakescreenamplitude, 0.15f * shakescreenamplitude) * base.transform.right;
	}

	protected void SetBackCameraPosition()
	{
		mainCameraObj.GetComponent<Animation>()["camera1"].enabled = false;
		mainCameraObj.transform.localPosition = back_camera_pos;
	}

	protected void SetCameraAnimationPara(float speed, float weight)
	{
		mainCameraObj.GetComponent<Animation>()["camera1"].weight = weight;
		mainCameraObj.GetComponent<Animation>()["camera1"].speed = speed;
		mainCameraObj.GetComponent<Animation>()["camera1"].enabled = true;
	}

	protected void updateShakeScreenEffect()
	{
		if (is_shakescreen_effect)
		{
			lastshakescreen_effect_time += Time.deltaTime;
			lastshakescreen_effect_interval_time += Time.deltaTime;
			if (lastshakescreen_effect_time >= shakescreen_effect_time)
			{
				lastshakescreen_effect_time = 0f;
				is_shakescreen_effect = false;
				SetBackCameraPosition();
			}
		}
	}

	protected void OffAttackPause()
	{
		last_attack_pause_time = 0f;
		base.GetComponent<Animation>()[cur_attackstatus.attackanimname].speed = 1f * animationspeedmodify;
		base.GetComponent<Animation>()["Forward01_" + cur_weapon.type_name + "01_merge"].speed = speedrate * (weaponspeed + class_speed_rate) / 8f;
		base.GetComponent<Animation>()["Idle01_" + cur_weapon.type_name + "01_merge"].speed = 1f;
		ContinueUVAnimation();
		is_attack_pause = false;
	}

	protected void updateAttackPause()
	{
		last_attack_pause_time += Time.deltaTime;
		if (last_attack_pause_time >= attack_pause_time)
		{
			OffAttackPause();
		}
	}

	protected void PlayAttackPauseEffect(float time, float interval_time)
	{
		last_attack_pause_time = 0f;
		last_attack_pause_interval_time = 0f;
		is_attack_pause_on = false;
		is_attack_pause = true;
		attack_pause_time = time;
		attack_pause_interval_time = interval_time;
		base.GetComponent<Animation>()[cur_attackstatus.attackanimname].speed = 0f;
		base.GetComponent<Animation>()["Idle01_" + cur_weapon.type_name + "01_merge"].speed = 0f;
		base.GetComponent<Animation>()["Forward01_" + cur_weapon.type_name + "01_merge"].speed = 0f;
		PauseUVAnimation();
	}

	protected void PlayShakeSceenEffect(float lasttime, float intervaltime, float amplitude)
	{
		shakescreen_effect_interval_time = intervaltime;
		shakescreen_effect_time = lasttime;
		shakescreenamplitude = amplitude;
		if (intervaltime != 0f)
		{
			SetCameraAnimationPara(0.01f / intervaltime, amplitude / 5f);
		}
		lastshakescreen_effect_time = 0f;
		lastshakescreen_effect_interval_time = 0f;
		is_shakescreen_effect = true;
	}

	protected void PlayBloodEffect()
	{
		last_blood_time = 0f;
		screenblood.active = true;
		MeshRenderer meshRenderer = screenblood.GetComponent("MeshRenderer") as MeshRenderer;
		meshRenderer.material.color = blood_color;
	}

	protected void CloseBloodEffect()
	{
		last_blood_time = blood_time + 1f;
		screenblood.active = false;
	}

	public bool Invincible()
	{
		return invincible || invincible2 || invincible3;
	}

	public void OnInvincible(float time)
	{
		invincible = true;
		lastinvincibletime = 0f;
		invincibletime = time;
	}

	public void OnInvincible2(float time)
	{
		invincible2 = true;
		lastinvincible2time = 0f;
		invincible2time = time;
		PlayAdvInvincible2Effect();
	}

	protected void OnInvincible3(float time)
	{
		invincible3 = true;
		lastinvincible3time = 0f;
		invincible3time = time;
	}

	protected void SetModelColor(Color color)
	{
		if (player_color == null)
		{
			return;
		}
		Dictionary<Material, Color>.KeyCollection keys = player_color.Keys;
		foreach (Material item in keys)
		{
			item.color = color;
		}
	}

	protected void SetModelColorAlpha(float a)
	{
		if (player_color == null)
		{
			return;
		}
		Dictionary<Material, Color>.KeyCollection keys = player_color.Keys;
		foreach (Material item in keys)
		{
			Color color = new Color(item.color.r, item.color.g, item.color.b, a);
			item.color = color;
		}
	}

	protected void SetModelColorRate(float rate_r, float rate_g, float rate_b)
	{
		if (player_color == null)
		{
			return;
		}
		Dictionary<Material, Color>.KeyCollection keys = player_color.Keys;
		foreach (Material item in keys)
		{
			Color value;
			if (player_color.TryGetValue(item, out value))
			{
				value = (item.color = new Color(value.r + 1f * rate_r, value.g + 1f * rate_g, value.b + 1f * rate_b, value.a));
			}
		}
	}

	protected void SetModelColorOriginal()
	{
		if (player_color == null)
		{
			return;
		}
		Dictionary<Material, Color>.KeyCollection keys = player_color.Keys;
		foreach (Material item in keys)
		{
			Color value;
			if (player_color.TryGetValue(item, out value))
			{
				item.color = value;
			}
		}
	}

	protected void updateInvincible()
	{
		if (Time.deltaTime == 0f)
		{
			return;
		}
		if (invincible)
		{
			lastinvincibletime += Time.deltaTime;
			if (lastinvincibletime >= invincibletime)
			{
				invincible = false;
				SetModelColorOriginal();
			}
			else
			{
				float rate_r = UnityEngine.Random.Range(0, 2);
				SetModelColorRate(rate_r, 0f, 0f);
			}
		}
		invincibleObj.transform.position = base.transform.position + new Vector3(0f, 2.5f, 1.8f);
		if (invincible2)
		{
			lastinvincible2time += Time.deltaTime;
			if (lastinvincible2time >= invincible2time)
			{
				invincible2 = false;
				SetModelColorOriginal();
			}
			else
			{
				float num = UnityEngine.Random.Range(0f, 0.4f);
				SetModelColorRate(num, num, 0f);
			}
		}
		if (invincible3)
		{
			lastinvincible3time += Time.deltaTime;
			if (lastinvincible3time >= invincible3time)
			{
				invincible3 = false;
			}
		}
	}

	private void PlayInjuryEffect()
	{
		Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = hurteffectObj.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
		crazy_ParticleSequenceScript.EmitParticle();
		Crazy_PlayTAudio crazy_PlayTAudio = hurteffectObj.GetComponent("Crazy_PlayTAudio") as Crazy_PlayTAudio;
		crazy_PlayTAudio.Play();
	}

	public void Injury(Crazy_HitData chd)
	{
		if (IsDie())
		{
			return;
		}
		PlayShakeSceenEffect(0.1f, 0.03f, 1f);
		PlayBloodEffect();
		PlayInjuryEffect();
		IsHurtted = true;
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		if (cur_health <= 0)
		{
			return;
		}
		cur_health--;
		if (cur_health == 0)
		{
			OnInvincible3(10f);
			Die();
			switchPlayerUpStatus(Crazy_PlayerStatus.Die);
			return;
		}
		OnInvincible(3f);
		Hitted(chd);
		if (m_hitrecover.IsHitRecover())
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Injury);
			hurt_vec3 = base.transform.position + m_hitrecover.getBeatMoveDistance();
			beatspeed = m_hitrecover.getBeatSpeed();
			movereduceparam = 0.1f;
			base.transform.forward = -m_hitrecover.getBeatMove();
		}
	}

	protected void updateHurt(float deltatime)
	{
		lasthurttime += deltatime;
		if (lasthurttime >= hurttime)
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
		}
	}

	protected void updateInjury(float deltatime)
	{
		lasthitrecovertime += deltatime;
		if (lasthitrecovertime <= m_hitrecover.getBeatTime())
		{
			MoveReduce(hurt_vec3);
		}
		else
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.HitRecover);
		}
	}

	protected virtual void MoveReduce(Vector3 dis)
	{
		dis = Vector3.Lerp(base.transform.position, dis, movereduceparam) - base.transform.position;
		movereduceparam *= 0.8f;
		Move(dis);
	}

	protected void updateHitRecover(float deltatime)
	{
		lasthitrecovertime += deltatime;
		if (lasthitrecovertime >= m_hitrecover.getHitRecoverTime())
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
		}
	}

	protected void Hitted(Crazy_HitData chd)
	{
		m_hitrecover.ApplyBeat(chd);
		m_hitrecover.ApplyEff(-base.transform.forward, 0f);
		lasthitrecovertime = 0f;
	}

	protected virtual void Die()
	{
	}

	public void Hurt()
	{
		if (IsDie())
		{
			return;
		}
		PlayShakeSceenEffect(0.1f, 0.03f, 1f);
		PlayBloodEffect();
		IsHurtted = true;
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		if (cur_health > 0)
		{
			cur_health--;
			if (cur_health == 0)
			{
				OnInvincible3(5f);
				Die();
				switchPlayerUpStatus(Crazy_PlayerStatus.Die);
			}
			else
			{
				OnInvincible(3f);
				switchPlayerUpStatus(Crazy_PlayerStatus.Hurt);
				lasthurttime = 0f;
			}
		}
	}

	public void StartContinousMove(Vector2 dir)
	{
		curMoveDir = new Vector3(dir.x, 0f, dir.y);
		curMoveDir.Normalize();
		if (curMoveDir.sqrMagnitude < 0.0001f)
		{
			switchPlayerDownStatus(Crazy_PlayerStatus.Stand);
		}
		else
		{
			switchPlayerDownStatus(Crazy_PlayerStatus.Move);
		}
	}

	public void OnFaceTo(Vector2 dir)
	{
		curForwardDir = new Vector3(dir.x, 0f, dir.y);
		curForwardDir.Normalize();
	}

	public void OnShot()
	{
		shotting = true;
		if (!IsDie() && !IsHitRecover() && !IsHurt() && !IsInjury() && !IsCelebrate() && !IsDeject() && !IsRoll() && !IsSkill())
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Shot);
		}
	}

	public void OffShot()
	{
		shotting = false;
		if (!IsSkill())
		{
			base.GetComponent<Animation>().Stop(cur_attackstatus.attackanimname);
			if (!IsDie() && !IsHitRecover() && !IsHurt() && !IsInjury() && !IsCelebrate() && !IsDeject() && !IsRoll())
			{
				switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
			}
		}
	}

	public GameObject GetArrow(Transform position)
	{
		return UnityEngine.Object.Instantiate(Resources.Load("Prefabs/bowarrow/bowarrow_pfb"), position.position, position.rotation) as GameObject;
	}

	public void PlayArrowEffect()
	{
		m_arrow = GetArrow(base.transform);
		m_arrow.transform.parent = base.transform;
		m_arrow.transform.localPosition = Vector3.zero;
		m_arrow.transform.localEulerAngles = Vector3.zero;
		Crazy_ParticleSystemSequenceScript crazy_ParticleSystemSequenceScript = m_arrow.GetComponent("Crazy_ParticleSystemSequenceScript") as Crazy_ParticleSystemSequenceScript;
		crazy_ParticleSystemSequenceScript.EmitParticle();
	}

	public void BowAttack(int index)
	{
		m_arrow.transform.parent = RootNode.transform;
		Crazy_Attacker crazy_Attacker = m_arrow.GetComponent("Crazy_Attacker") as Crazy_Attacker;
		Vector3 forward = base.transform.forward;
		forward.Normalize();
		crazy_Attacker.Attack(forward, 50f, cur_attackstatus.attackjudgmentinfo[index].attackrange, cur_attackstatus.attackjudgmentinfo[index].attackangle, 0.1f, cur_attackstatus.attackjudgmentinfo[index].attackdamage * (weapondamage + (float)Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage) * class_damage_rate * GetComboRate(), cur_attackstatus.attackjudgmentinfo[index].hitdata, cur_weapon.type, 1.5f, true, usingskill);
	}

	public void PlayRainArrowIntroEffect()
	{
		rainarrowintroeffect.EmitParticle();
	}

	public void PlayShotIntroEffect()
	{
		bowchargeeffect.EmitParticle();
	}

	public void PlayRainArrowHitEffect()
	{
		rainarrowhiteffect.gameObject.transform.parent = base.transform;
		rainarrowhiteffect.gameObject.transform.localPosition = Vector3.zero;
		rainarrowhiteffect.EmitParticle();
		rainarrowhiteffect.gameObject.transform.parent = RootNode.transform;
	}

	public void PauseShot()
	{
		base.GetComponent<Animation>().Stop(cur_attackstatus.attackanimname);
	}

	public void updateShot()
	{
		if (shotting && IsIdle())
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Shot);
		}
	}

	private void updateScreenBlood()
	{
		last_blood_time += Time.deltaTime;
		if (last_blood_time >= blood_time)
		{
			CloseBloodEffect();
			return;
		}
		MeshRenderer meshRenderer = screenblood.GetComponent("MeshRenderer") as MeshRenderer;
		meshRenderer.material.color = new Color(blood_color.r, blood_color.g, blood_color.b, blood_color.a - last_blood_time / blood_time * blood_color.a);
	}

	protected virtual void Update()
	{
		updateWeaponSkill();
		updateSpeedUp();
		updateInvincible();
		updateScreenBlood();
		updateShakeScreenEffect();
		if (is_attack_pause)
		{
			updateAttackPause();
			return;
		}
		relive();
		updateCombo();
		updateTurnRound();
		updateRoll();
		updateMove();
		if (shotting)
		{
			updateShot();
		}
		if (attacking)
		{
			if (cur_attackstatus.attackname == "Skill01_Staff01")
			{
				updateAttack(base.GetComponent<Animation>()["Skill01_Start_Staff_merge"].speed * Time.deltaTime);
				updateAttack(base.GetComponent<Animation>()["Skill01_Loop_Staff_merge"].speed * Time.deltaTime);
				updateAttack(base.GetComponent<Animation>()["Skill01_End_Staff_merge"].speed * Time.deltaTime);
			}
			else
			{
				updateAttack(base.GetComponent<Animation>()[cur_attackstatus.attackanimname].speed * Time.deltaTime);
			}
		}
		else
		{
			lastattackingtime += Time.deltaTime;
		}
		updateAttackPauseInterval();
		switch (cur_up_Status)
		{
		case Crazy_PlayerStatus.Hurt:
			updateHurt(Time.deltaTime);
			break;
		case Crazy_PlayerStatus.Injury:
			updateInjury(Time.deltaTime);
			break;
		case Crazy_PlayerStatus.HitRecover:
			updateHitRecover(Time.deltaTime);
			break;
		}
	}

	public bool IsIdle()
	{
		return cur_up_Status == Crazy_PlayerStatus.Idle;
	}

	public bool IsHurt()
	{
		return cur_up_Status == Crazy_PlayerStatus.Hurt;
	}

	public bool IsInjury()
	{
		return cur_up_Status == Crazy_PlayerStatus.Injury;
	}

	public bool IsDie()
	{
		return cur_up_Status == Crazy_PlayerStatus.Die;
	}

	public bool IsDeject()
	{
		return cur_up_Status == Crazy_PlayerStatus.Deject;
	}

	public bool IsCelebrate()
	{
		return cur_up_Status == Crazy_PlayerStatus.Celebrate;
	}

	public bool IsHitRecover()
	{
		return cur_up_Status == Crazy_PlayerStatus.HitRecover;
	}

	public bool IsRoll()
	{
		return cur_up_Status == Crazy_PlayerStatus.Roll;
	}

	public bool IsShot()
	{
		return cur_up_Status == Crazy_PlayerStatus.Shot;
	}

	public bool IsSkill()
	{
		return cur_up_Status == Crazy_PlayerStatus.Skill;
	}

	private void updateAttack(float deltatime)
	{
		lastattackingtime += deltatime;
		updateAttackMove(deltatime);
		updateAttackRecover(deltatime);
		updateAttackJudgment(deltatime);
		updateAdvAttackEffect(deltatime);
		updateAttackEnd(deltatime);
	}

	protected virtual void updateWeaponSkill()
	{
		lastskillinterval += Time.deltaTime;
		if (!(lastskillinterval >= skillinterval))
		{
			return;
		}
		if ((reducemove || reducespeed) && Crazy_GlobalData.enemyList != null)
		{
			foreach (GameObject value in Crazy_GlobalData.enemyList.Values)
			{
				Crazy_EnemyControl crazy_EnemyControl = value.GetComponent("Crazy_EnemyControl") as Crazy_EnemyControl;
				crazy_EnemyControl.SetWeaponSkillEffect((!reducemove) ? 0f : reducemoverate, (!reducespeed) ? 0f : reducespeedrate);
			}
		}
		lastskillinterval = 0f;
	}

	private void updateAttackPauseInterval()
	{
		last_attack_pause_interval_time += Time.deltaTime;
		if (last_attack_pause_interval_time >= attack_pause_interval_time)
		{
			is_attack_pause_on = true;
		}
	}

	public int GetCombo()
	{
		return combocount;
	}

	public int GetEnergy()
	{
		return energy;
	}

	public bool GetAttackRecover()
	{
		return attackrecovering;
	}

	private void updateAttackRecover(float deltatime)
	{
		if (attackrecovering)
		{
			lastattackrecoveringtime -= deltatime;
			if (lastattackrecoveringtime <= 0f)
			{
				AttackRecover();
			}
		}
	}

	private void updateAttackEnd(float deltatime)
	{
		if (attacking && lastattackingtime >= cur_attackstatus.attacktime)
		{
			OnEndAttack();
		}
	}

	private void updateAdvAttackEffect(float deltatime)
	{
		if (!attacking || lastadvattackeffecttime == 0f)
		{
			return;
		}
		lastadvattackeffecttime -= deltatime;
		if (!(lastadvattackeffecttime <= 0f))
		{
			return;
		}
		lastadvattackeffecttime = 0f;
		GameObject value;
		if (attackeffectdic.TryGetValue(cur_attackstatus.attackadveffectdata.effectname, out value))
		{
			if (useeffect)
			{
				value.transform.parent = RootNode.transform;
				value.transform.localEulerAngles = Vector3.zero;
				value.transform.position = GetAttackPoint(0) + cur_attackstatus.attackadveffectdata.delta;
				if (cur_attackstatus.attackadveffectdata.isfollow)
				{
					value.transform.parent = base.transform;
				}
				else
				{
					value.transform.parent = RootNode.transform;
				}
				Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = value.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
				if (crazy_ParticleSequenceScript != null)
				{
					crazy_ParticleSequenceScript.EmitParticle();
				}
				Crazy_ParticleEmitterLast crazy_ParticleEmitterLast = value.GetComponent("Crazy_ParticleEmitterLast") as Crazy_ParticleEmitterLast;
				if (crazy_ParticleEmitterLast != null)
				{
					crazy_ParticleEmitterLast.Emit();
				}
			}
			PlayShakeSceenEffect(cur_attackstatus.attackadveffectdata.shaketime, cur_attackstatus.attackadveffectdata.shakeintervaltime, cur_attackstatus.attackadveffectdata.shakeamplitude);
		}
		else if ("ScreenShake" == cur_attackstatus.attackadveffectdata.effectname)
		{
			PlayShakeSceenEffect(cur_attackstatus.attackadveffectdata.shaketime, cur_attackstatus.attackadveffectdata.shakeintervaltime, cur_attackstatus.attackadveffectdata.shakeamplitude);
		}
	}

	private void updateAttackJudgment(float deltatime)
	{
		if (!attacking)
		{
			return;
		}
		for (int i = 0; i < lastattackjudgmenttime.ToArray().GetLength(0); i++)
		{
			if (!cur_attackstatus.attackjudgmentinfo[i].usecallback && lastattackjudgmenttime[i] != 0f)
			{
				List<float> list;
				List<float> list2 = (list = lastattackjudgmenttime);
				int index;
				int index2 = (index = i);
				float num = list[index];
				list2[index2] = num - deltatime;
				if (lastattackjudgmenttime[i] <= 0f)
				{
					lastattackjudgmenttime[i] = 0f;
					AttackEnemy(i);
				}
			}
		}
	}

	protected bool checkCollideToGround(Vector3 distance)
	{
		Vector3 vector = distance;
		vector.Normalize();
		Vector3 origin = base.transform.position + Vector3.up * halfplayerheight + distance;
		Ray ray = new Ray(origin, Vector3.down);
		int layerMask = 1 << LayerMask.NameToLayer("Ground");
		RaycastHit hitInfo;
		if (Physics.Raycast(ray, out hitInfo, halfplayerheight * 10f, layerMask) && hitInfo.collider.gameObject.layer == LayerMask.NameToLayer("Ground"))
		{
			return true;
		}
		return false;
	}

	protected bool checkCollideToWall(Vector3 distance, ref Vector3 modifydistance, ref int iteration)
	{
		iteration--;
		Ray ray = new Ray(base.transform.position + Vector3.up, distance);
		int layerMask = 1 << LayerMask.NameToLayer("Wall");
		RaycastHit hitInfo;
		if (Physics.Raycast(ray, out hitInfo, halfplayerwidth * 10f, layerMask) && iteration >= 0)
		{
			Vector3 vector = new Vector3(hitInfo.normal.z, 0f, 0f - hitInfo.normal.x);
			modifydistance = vector * Vector3.Dot(ray.direction, vector) * distance.magnitude;
			Vector3 modifydistance2 = Vector3.zero;
			if (modifydistance.magnitude > 0.01f)
			{
				checkCollideToWall(modifydistance, ref modifydistance2, ref iteration);
			}
			Vector3 vector2 = new Vector3(0f - hitInfo.normal.x, 0f, 0f - hitInfo.normal.z);
			float a = hitInfo.distance * Vector3.Dot(ray.direction, vector2) - halfplayerwidth;
			float b = distance.magnitude * Vector3.Dot(ray.direction, vector2);
			Vector3 vector3 = Mathf.Min(Mathf.Max(a, 0f), b) * -vector2;
			modifydistance = modifydistance2 - vector3;
			return true;
		}
		if (iteration < 0)
		{
			modifydistance = Vector3.zero;
			return false;
		}
		modifydistance = distance;
		return false;
	}

	protected bool checkCollideToOther(Vector3 distance, ref Vector3 modifydistance, ref int iteration)
	{
		iteration--;
		Ray ray = new Ray(base.transform.position + Vector3.up, distance);
		int layerMask = (1 << LayerMask.NameToLayer("Wall")) | (1 << LayerMask.NameToLayer("Enemy"));
		RaycastHit hitInfo;
		if (Physics.Raycast(ray, out hitInfo, halfplayerwidth * 10f, layerMask) && iteration >= 0)
		{
			Vector3 vector = new Vector3(hitInfo.normal.z, 0f, 0f - hitInfo.normal.x);
			modifydistance = vector * Vector3.Dot(ray.direction, vector) * distance.magnitude;
			Vector3 modifydistance2 = Vector3.zero;
			if (modifydistance.magnitude > 0.01f)
			{
				checkCollideToOther(modifydistance, ref modifydistance2, ref iteration);
			}
			Vector3 vector2 = new Vector3(0f - hitInfo.normal.x, 0f, 0f - hitInfo.normal.z);
			float a = hitInfo.distance * Vector3.Dot(ray.direction, vector2) - halfplayerwidth;
			float b = distance.magnitude * Vector3.Dot(ray.direction, vector2);
			Vector3 vector3 = Mathf.Min(Mathf.Max(a, 0f), b) * -vector2;
			modifydistance = modifydistance2 - vector3;
			return true;
		}
		if (iteration < 0)
		{
			modifydistance = Vector3.zero;
			return false;
		}
		modifydistance = distance;
		return false;
	}

	private void PlayAttackMove(float time)
	{
		curAttackDir.Normalize();
		float num = curattackmovespeed + cur_attackstatus.attackmoveacc * time;
		if (num < 0f)
		{
			num = 0f;
		}
		float movedistance = (curattackmovespeed + num) * time * 0.5f;
		curattackmovespeed = num;
		Move(curAttackDir, movedistance);
	}

	private void updateAttackMove(float deltatime)
	{
		if (!attacking)
		{
			return;
		}
		lastattackmovetime += deltatime;
		if (attackmove)
		{
			if (lastattackmovetime >= cur_attackstatus.attackmoveendtime)
			{
				PlayAttackMove(cur_attackstatus.attackmoveendtime - lastattackmovetime + deltatime);
				OffAttackMove();
			}
			else
			{
				PlayAttackMove(deltatime);
			}
		}
		else if (lastattackmovetime >= cur_attackstatus.attackmovebegintime)
		{
			OnAttackMove();
			PlayAttackMove(lastattackmovetime - cur_attackstatus.attackmovebegintime);
		}
	}

	private void OnAttackMove()
	{
		if (cur_attackstatus.attackmove)
		{
			curattackmovespeed = cur_attackstatus.attackmovespeed;
			attackmove = true;
		}
	}

	protected void OffAttackMove()
	{
		attackmove = false;
		lastattackmovetime = -10000f;
		curattackmovespeed = 0f;
	}

	protected virtual void updateRoll()
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
		if (roll)
		{
			lastrolltime += Time.deltaTime;
			if (lastrolltime >= rolltime)
			{
				rollrecover = true;
				lastrollrecovertime = lastrolltime - rolltime;
				roll = false;
				Move(rolldir, rollspeed * (lastrolltime - rolltime));
			}
			else
			{
				Move(rolldir, rollspeed * Time.deltaTime);
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

	protected virtual void ResetRoll()
	{
		rollrecover = false;
		roll = false;
		rollcooldown = false;
		lastrollcooldowntime = 0f;
		lastrolltime = 0f;
		lastrollrecovertime = 0f;
		rolldir = Vector3.zero;
		base.GetComponent<Animation>().Stop("Roll01_" + cur_weapon.type_name + "01_merge");
	}

	protected virtual void Roll()
	{
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		rollrecover = false;
		roll = true;
		rollcooldown = true;
		lastrollcooldowntime = 0f;
		lastrollrecovertime = 0f;
		lastrolltime = 0f;
		rolldir = curMoveDir;
		base.GetComponent<Animation>().CrossFade("Roll01_" + cur_weapon.type_name + "01_merge", 0.1f);
	}

	private void updateMove()
	{
		if ((!attacking || !cur_attackstatus.attackmove) && !IsInjury() && !IsHurt() && !IsDie() && !IsHitRecover() && !IsDeject() && !IsCelebrate() && !IsRoll())
		{
			float num = 1f;
			if (IsShot() && Vector3.Angle(curMoveDir, curForwardDir) >= 90f)
			{
				num = 0.8f;
			}
			Move(curMoveDir, speed * speeduprate * (weaponspeed + class_speed_rate) * Time.deltaTime * num);
		}
	}

	protected void Move(Vector3 distance)
	{
		Vector3 movedir = distance;
		movedir.Normalize();
		Move(movedir, distance.magnitude);
	}

	protected void Move(Vector3 movedir, float movedistance)
	{
		Vector3 modifydistance = default(Vector3);
		int iteration = 3;
		bool flag = checkCollideToOther(movedir * movedistance, ref modifydistance, ref iteration);
		btouchground = checkCollideToGround(movedir * movedistance);
		if (flag)
		{
			base.transform.position += modifydistance;
		}
		else if (btouchground)
		{
			base.transform.position += movedir * movedistance;
		}
	}

	protected virtual void SetSpeedRate(float rate)
	{
		speeduprate = rate;
		base.GetComponent<Animation>()["Forward01_Sword01_merge"].speed = rate * (weaponspeed + class_speed_rate) / 8f;
		base.GetComponent<Animation>()["Forward01_Hammer01_merge"].speed = rate * (weaponspeed + class_speed_rate) / 8f;
		base.GetComponent<Animation>()["Forward01_Axe01_merge"].speed = rate * (weaponspeed + class_speed_rate) / 8f;
	}

	protected Vector3 GetAttackPoint(int index)
	{
		Vector2 original = new Vector2(base.transform.position.x, base.transform.position.z);
		Vector2 forward = new Vector2(base.transform.forward.x, base.transform.forward.z);
		Vector2 vector = Crazy_Global.RotatebyAngle(original, forward, cur_attackstatus.attackjudgmentinfo[index].attackpoint.angle, cur_attackstatus.attackjudgmentinfo[index].attackpoint.length);
		Vector3 result = new Vector3(vector.x, base.transform.position.y, vector.y);
		return result;
	}

	protected virtual void updateTurnRound()
	{
		if ((attacking && cur_attackstatus.attackrotate) || IsInjury() || IsHurt() || IsDie() || IsHitRecover() || IsDeject() || IsCelebrate() || IsRoll())
		{
			return;
		}
		if (!IsShot())
		{
			curForwardDir = curMoveDir;
		}
		if (!(curForwardDir.sqrMagnitude > 0.0001f))
		{
			return;
		}
		Vector3 vector = new Vector2(base.transform.forward.x, base.transform.forward.z);
		Vector3 vector2 = new Vector2(curForwardDir.x, curForwardDir.z);
		float num = Vector2.Angle(vector, vector2);
		if (!(num < 5f))
		{
			if (num > 120f)
			{
				Vector3 lhs = new Vector3(vector.x, 0f, vector.y);
				Vector3 rhs = new Vector3(vector2.x, 0f, vector2.y);
				vector2 = ((!(Vector3.Cross(lhs, rhs).y > 0f)) ? ((Vector3)new Vector2(0f - vector.y, vector.x)) : ((Vector3)new Vector2(vector.y, 0f - vector.x)));
			}
			float t = 0.4f;
			Vector2 vector3 = Vector2.Lerp(vector, vector2, t);
			base.transform.forward = new Vector3(vector3.x, base.transform.forward.y, vector3.y);
		}
	}

	protected virtual void StopAttack()
	{
		if (is_attack_pause)
		{
			OffAttackPause();
		}
		base.GetComponent<Animation>().Stop(cur_attackstatus.attackanimname);
		AttackRecover();
		OnEndAttack();
	}

	protected void switchPlayerUpStatus(Crazy_PlayerStatus toStatus)
	{
		if (toStatus >= cur_up_Status || toStatus == Crazy_PlayerStatus.Idle)
		{
			switch (toStatus)
			{
			case Crazy_PlayerStatus.Idle:
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Die:
				base.GetComponent<Animation>().Play("Death01_" + cur_weapon.type_name + "01_merge");
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Hurt:
				base.GetComponent<Animation>().Play("Damage01_" + cur_weapon.type_name + "01_merge");
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Injury:
				base.GetComponent<Animation>().Play("Knockdown_" + cur_weapon.type_name + "01_merge");
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.HitRecover:
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Deject:
				base.GetComponent<Animation>().Play(cur_weapon.type_name + "01_lose_merge");
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Celebrate:
				base.GetComponent<Animation>().Play("Idle_" + cur_weapon.type_name + "01_celebrate01_merge");
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Shot:
				Shot();
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Skill:
				Skill();
				curAttackDir = base.transform.forward;
				attacking = true;
				cur_up_Status = toStatus;
				return;
			case Crazy_PlayerStatus.Roll:
				if (!rollcooldown)
				{
					Roll();
					cur_up_Status = toStatus;
				}
				return;
			}
		}
		if (!attacking)
		{
			Crazy_PlayerStatus crazy_PlayerStatus = toStatus;
			if (crazy_PlayerStatus == Crazy_PlayerStatus.Attack)
			{
				Attack();
				curAttackDir = base.transform.forward;
				attacking = true;
			}
			cur_up_Status = toStatus;
		}
		else if (!attackrecovering && toStatus >= cur_up_Status)
		{
			Crazy_PlayerStatus crazy_PlayerStatus = toStatus;
			if (crazy_PlayerStatus == Crazy_PlayerStatus.Attack)
			{
				Attack();
				curAttackDir = base.transform.forward;
				attacking = true;
				cur_up_Status = toStatus;
			}
		}
	}

	private void switchPlayerDownStatus(Crazy_PlayerStatus toStatus)
	{
		if (!IsDie() && !IsDeject() && !IsCelebrate())
		{
			switch (toStatus)
			{
			case Crazy_PlayerStatus.Stand:
				base.GetComponent<Animation>().CrossFade("Idle01_" + cur_weapon.type_name + "01_merge", 0.2f);
				break;
			case Crazy_PlayerStatus.Move:
				base.GetComponent<Animation>().CrossFade("Forward01_" + cur_weapon.type_name + "01_merge", 0.2f);
				break;
			}
			cur_down_Status = toStatus;
		}
	}

	private void updateSpeedUp()
	{
		if (speedup)
		{
			lastspeeduptime -= Time.deltaTime;
			if (lastspeeduptime <= 0f)
			{
				speedup = false;
				SetSpeedRate(1f);
			}
		}
	}

	private void OnSpeedup(float rate, float time)
	{
		speedup = true;
		speeduptime = time;
		lastspeeduptime = speeduptime;
		SetSpeedRate(rate);
		PlayAdvSpeedupEffect();
	}

	private void OnSpeedDown(float rate, float time)
	{
		SetSpeedRate(rate);
	}

	private void OnHealup(int up)
	{
		if (cur_health + up >= maxhealth)
		{
			cur_health = maxhealth;
		}
		else
		{
			cur_health += up;
		}
		PlayIncreaseBloodEffect();
	}

	private void PlayAdvInvincible2Effect()
	{
		Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = invincibleObj.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
		crazy_ParticleSequenceScript.EmitParticle();
	}

	private void PlayAdvSpeedupEffect()
	{
		Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = speedupObj.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
		crazy_ParticleSequenceScript.EmitParticle();
	}

	private void LevelUp()
	{
		Hashtable hashtable = new Hashtable();
		hashtable.Add("Level", Crazy_Data.CurData().GetLevel());
		FlurryPlugin.logEvent("Level_Up", hashtable);
		levelupeffect.EmitParticle();
		levelupmodel.Play();
		PlayTAudio("Fx_LevelUp");
	}

	private void PlayAdvComboEffect(int rank)
	{
		if (useeffect)
		{
			if (rank == 1)
			{
				levelupeffect.EmitParticle();
				levelupmodel.Play();
			}
		}
	}

	public void Shot()
	{
		usingskill = false;
		cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
		AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
	}

	public virtual void Skill()
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
		base.GetComponent<Animation>().Stop("Skill01_" + cur_weapon.type_name + "01_merge");
		cur_attackstatus = attackstatus["Skill01_" + cur_weapon.type_name + "01"];
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
		OnInvincible3(cur_attackstatus.attacktime / animationspeedmodify + 1f);
		if (useeffect)
		{
			if (cur_weapon.type == Crazy_Weapon_Type.Hammer)
			{
				hammerskilleffect.EmitParticle();
				hammerskillhand.Play();
			}
			else if (cur_weapon.type == Crazy_Weapon_Type.Sword)
			{
				swordchargeeffect.EmitParticle();
			}
			else if (cur_weapon.type == Crazy_Weapon_Type.Axe)
			{
				axeskillmodel.Play();
			}
			else if (cur_weapon.type == Crazy_Weapon_Type.Bow)
			{
				rainarroweffect.EmitParticle();
			}
		}
	}

	public void PlayInvincible()
	{
		OnInvincible2(15f);
	}

	public void PlaySpeedUp()
	{
		OnSpeedup(1.5f, 15f);
	}

	public void PlayHealUp()
	{
		OnHealup(1);
	}

	public void PlayHealUp(int hp)
	{
		OnHealup(hp);
	}

	public void PlaySpeedUp(float rate, float time)
	{
		OnSpeedup(rate, time);
	}

	public void PlaySpeedDown(float rate, float time)
	{
		OnSpeedDown(rate, time);
	}

	public virtual void Attack()
	{
		usingskill = false;
		if (is_attack_pause)
		{
			return;
		}
		attacklist.Clear();
		OffAttackMove();
		attackrecovering = true;
		if (lastattackingtime > pre_attackstatus.nextattacktime)
		{
			lastattackingtime = 0f;
			base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
			cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
			AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
		}
		else
		{
			lastattackingtime = 0f;
			switch (pre_attackstatus.attacktype)
			{
			case Crazy_AttackType.Attack01:
				if (max_attack_count >= 2)
				{
					cur_attackstatus = attackstatus["Attack02_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				else
				{
					base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
					cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				break;
			case Crazy_AttackType.Attack02:
				if (max_attack_count >= 3)
				{
					cur_attackstatus = attackstatus["Attack03_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				else
				{
					base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
					cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				break;
			case Crazy_AttackType.Attack03:
				if (max_attack_count >= 4)
				{
					cur_attackstatus = attackstatus["Attack04_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				else
				{
					base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
					cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
					AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				}
				break;
			case Crazy_AttackType.Attack04:
				base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
				cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
				AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				break;
			default:
				base.GetComponent<Animation>().Stop("Attack01_" + cur_weapon.type_name + "01_merge");
				cur_attackstatus = attackstatus["Attack01_" + cur_weapon.type_name + "01"];
				AnimationCrossFade(cur_attackstatus.attackanimname, 0.1f);
				break;
			}
		}
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

	public void PlayerAttack()
	{
		if (!IsDie() && !IsHitRecover() && !IsHurt() && !IsInjury() && !IsCelebrate() && !IsDeject() && !IsRoll() && cur_weapon.type != Crazy_Weapon_Type.Bow)
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Attack);
		}
	}

	public void PlayerSkill()
	{
		if (!IsDie() && !IsHitRecover() && !IsHurt() && !IsInjury() && !IsCelebrate() && !IsDeject() && energy == 100)
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Skill);
		}
	}

	public void PlayerRoll()
	{
		if (!bForbidRoll && !IsDie() && !IsHitRecover() && !IsHurt() && !IsInjury() && !IsCelebrate() && !IsDeject())
		{
			switchPlayerUpStatus(Crazy_PlayerStatus.Roll);
		}
	}

	public void OnPlayUVAnimationCallBack()
	{
		if (cur_attackstatus != null && cur_attackstatus.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_attackstatus.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			MergeUVAnimation(crazy_UVAnimation);
			crazy_UVAnimation.SetTimeFactor(base.GetComponent<Animation>()[cur_attackstatus.attackanimname].speed);
			crazy_UVAnimation.OnUVAnimation();
		}
	}

	private void MergeUVAnimation(Crazy_UVAnimation uva)
	{
		uva.transform.parent = base.transform;
		uva.transform.localPosition = Vector3.zero;
		uva.transform.localEulerAngles = new Vector3(270f, 0f, 0f);
	}

	private void ApartUVAnimation(Crazy_UVAnimation uva)
	{
		uva.transform.parent = RootNode.transform;
	}

	public void PauseUVAnimation()
	{
		if (cur_attackstatus != null && cur_attackstatus.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_attackstatus.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			crazy_UVAnimation.Pause();
		}
	}

	public void ContinueUVAnimation()
	{
		if (cur_attackstatus != null && cur_attackstatus.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_attackstatus.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			crazy_UVAnimation.Continue();
		}
	}

	protected virtual void OnEndAttack()
	{
		attacking = false;
		switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
	}

	private void ExtraAttackMakerPretreatment()
	{
		for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
		{
			Crazy_Attacker crazy_Attacker = swordskilleffectmodel[i].GetComponent("Crazy_Attacker") as Crazy_Attacker;
			Vector3 forward = base.transform.forward;
			Vector2 forward2 = new Vector2(forward.x, forward.z);
			forward2 = Crazy_Global.Rotate(forward2, 45 * (i - 1));
			forward = new Vector3(forward2.x, forward.y, forward2.y);
			swordskilleffectmodel[i].transform.position = base.transform.position + forward;
			swordskilleffectmodel[i].transform.forward = forward;
			Crazy_ParticleEmitterLast crazy_ParticleEmitterLast = swordskilleffectmodel[i].GetComponent("Crazy_ParticleEmitterLast") as Crazy_ParticleEmitterLast;
			crazy_ParticleEmitterLast.Emit();
		}
	}

	public virtual void ExtraAttackMaker(int index)
	{
		if (cur_attackstatus.attackname == "Skill01_Sword01")
		{
			for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
			{
				Crazy_Attacker crazy_Attacker = swordskilleffectmodel[i].GetComponent("Crazy_Attacker") as Crazy_Attacker;
				Vector3 forward = base.transform.forward;
				Vector2 forward2 = new Vector2(forward.x, forward.z);
				forward2 = Crazy_Global.Rotate(forward2, 45 * (i - 1));
				forward = new Vector3(forward2.x, forward.y, forward2.y);
				swordskilleffectmodel[i].transform.position = base.transform.position + forward;
				swordskilleffectmodel[i].transform.forward = forward;
				forward.Normalize();
				crazy_Attacker.Attack(forward, 25f, cur_attackstatus.attackjudgmentinfo[index].attackrange, cur_attackstatus.attackjudgmentinfo[index].attackangle, 0.1f, cur_attackstatus.attackjudgmentinfo[index].attackdamage * (weapondamage + (float)Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage) * class_damage_rate * GetComboRate(), cur_attackstatus.attackjudgmentinfo[index].hitdata, cur_weapon.type, 1.5f, usingskill);
				swordskilleffectmodel[i].GetComponent<Animation>().Play("sword skill_effect");
			}
		}
		else if (cur_attackstatus.attackname == "Skill01_Bow01")
		{
			Crazy_Attacker crazy_Attacker2 = rainarrowhiteffect.gameObject.GetComponent("Crazy_Attacker") as Crazy_Attacker;
			Vector3 zero = Vector3.zero;
			crazy_Attacker2.Attack(zero, 0f, cur_attackstatus.attackjudgmentinfo[index].attackrange, cur_attackstatus.attackjudgmentinfo[index].attackangle, 0.8f, cur_attackstatus.attackjudgmentinfo[index].attackdamage * (weapondamage + (float)Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage) * class_damage_rate * GetComboRate(), cur_attackstatus.attackjudgmentinfo[index].hitdata, cur_weapon.type, 5f, true, true, usingskill);
		}
	}

	protected float GetComboRate()
	{
		return (float)Crazy_ComboLevel.FindComboLevel(GetCombo()) * comborate + 1f;
	}

	public void ExtraAttackEffect()
	{
		if (cur_attackstatus.attackname == "Skill01_Hammer01")
		{
			hammerskillmodel.Play();
		}
	}

	protected virtual void AttackEnemy(int index)
	{
		int num = 0;
		ExtraAttackMaker(index);
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
			Vector3 attackPoint = GetAttackPoint(index);
			Vector3 vector = new Vector3(crazy_EnemyControl.transform.position.x, 0f, crazy_EnemyControl.transform.position.z);
			Vector3 vector2 = attackPoint - vector;
			explodepos = attackPoint;
			float sqrMagnitude = vector2.sqrMagnitude;
			if (!(sqrMagnitude < (cur_attackstatus.attackjudgmentinfo[index].attackrange + crazy_EnemyControl.GetHitBox()) * (cur_attackstatus.attackjudgmentinfo[index].attackrange + crazy_EnemyControl.GetHitBox())))
			{
				continue;
			}
			float num2 = Vector3.Angle(-vector2, base.transform.forward);
			if (num2 < cur_attackstatus.attackjudgmentinfo[index].attackangle)
			{
				if (!is_attack_pause && is_attack_pause_on && cur_attackstatus.attackjudgmentinfo[index].attackpause)
				{
					PlayAttackPauseEffect(cur_attackstatus.attackjudgmentinfo[index].attackpausetime, 0.1f);
					crazy_EnemyControl.Pause(cur_attackstatus.attackjudgmentinfo[index].attackpausetime);
				}
				else if (is_attack_pause)
				{
					crazy_EnemyControl.Pause(cur_attackstatus.attackjudgmentinfo[index].attackpausetime);
				}
				if (!is_shakescreen_effect && cur_attackstatus.attackjudgmentinfo[index].attackshake)
				{
					PlayShakeSceenEffect(cur_attackstatus.attackjudgmentinfo[index].attackshaketime, cur_attackstatus.attackjudgmentinfo[index].attackshakeintervaltime, cur_attackstatus.attackjudgmentinfo[index].attackshakeamplitude);
				}
				Vector3 vector3 = default(Vector3);
				vector3 = curEnemyObj.transform.position - base.transform.position;
				vector3.Normalize();
				cur_attackstatus.attackjudgmentinfo[index].hitdata.beatDir = vector3;
				if (crazy_EnemyControl.Hurt(cur_attackstatus.attackjudgmentinfo[index].attackdamage * (weapondamage + (float)Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel()).damage) * class_damage_rate * GetComboRate(), cur_attackstatus.attackjudgmentinfo[index].hitdata, cur_weapon.type, usingskill))
				{
					num++;
				}
				isattackenemy = true;
				AddCombo();
				if (!IsSkill())
				{
					AddEnergy();
				}
				if (!cur_attackstatus.attackjudgmentinfo[index].attackreset)
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

	private void AddEnergy(int e)
	{
		energy += e;
		if (energy >= 100)
		{
			energy = 100;
		}
		else if (energy <= 0)
		{
			energy = 0;
		}
	}

	protected void AttackRecover()
	{
		if (cur_attackstatus != null && cur_attackstatus.attackeffectid != -1)
		{
			Crazy_UVAnimation uva = attack_effect_Obj[cur_attackstatus.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			ApartUVAnimation(uva);
		}
		pre_attackstatus = cur_attackstatus;
		attackrecovering = false;
	}

	public void relive()
	{
		if (base.gameObject.transform.position.y < -1f)
		{
			base.gameObject.transform.position = Vector3.zero;
		}
	}

	protected void AnimationCrossFade(string animename, float fadelength)
	{
		base.GetComponent<Animation>()[animename].weight = 1f;
		base.GetComponent<Animation>().CrossFade(animename, fadelength);
	}

	private void AnimationCrossFade(string animename)
	{
		base.GetComponent<Animation>()[animename].weight = 1f;
		base.GetComponent<Animation>().CrossFade(animename);
	}

	public void IColliderSendMessage(GameObject colliderobj, ColliderMessage message)
	{
		switch (message)
		{
		case ColliderMessage.Invincible:
			PlayInvincible();
			PlayTAudio("Fx_DefenseUp");
			SendHintMessage("#INVINCIBLE$");
			Crazy_ItemManager.DeleteItem(colliderobj, message);
			break;
		case ColliderMessage.SpeedUp:
			PlaySpeedUp();
			PlayTAudio("Fx_SpeedUp");
			SendHintMessage("#SPEED BOOST$");
			Crazy_ItemManager.DeleteItem(colliderobj, message);
			break;
		case ColliderMessage.HealUp:
			PlayHealUp();
			PlayTAudio("Fx_HpUp");
			Crazy_ItemManager.DeleteItem(colliderobj, message);
			Crazy_TaskManager.GetInstance().updateTask(Crazy_TaskId.Task30, 0, 0f);
			break;
		}
	}

	public void OnCelebrate()
	{
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		switchPlayerUpStatus(Crazy_PlayerStatus.Celebrate);
		OnInvincible3(30f);
	}

	public void OnDeject()
	{
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		switchPlayerUpStatus(Crazy_PlayerStatus.Deject);
		OnInvincible3(30f);
	}

	public void PlayTAudio(string name)
	{
		m_audiocontroller.PlayAudio(name);
	}

	public Crazy_Weapon_Type UseWeaponType()
	{
		return cur_weapon.type;
	}

	public Crazy_Weapon_Enchant UseWeaponEnchant()
	{
		return cur_weapon.enchant;
	}

	public Crazy_AttackType UseAttackType()
	{
		return cur_attackstatus.attacktype;
	}

	public Vector3 UseExplodePosition()
	{
		return explodepos;
	}

	protected void SendHintMessage(string text)
	{
		Crazy_HintMessage crazy_HintMessage = new Crazy_HintMessage();
		crazy_HintMessage.text = text;
		Crazy_SceneManager.GetInstance().GetScene().SendHintMessage(crazy_HintMessage);
	}

	public int GetGold()
	{
		return goldscore;
	}

	public void AddGold(int gold)
	{
		goldscore += gold;
	}

	public void AddExp(int exp)
	{
		int num = Crazy_Data.CurData().GetExp() + exp;
		Crazy_Player_Level playerLevelinfo = Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel());
		Crazy_Player_Level playerLevelinfo2 = Crazy_PlayerClass_Level.GetPlayerLevelinfo(Crazy_Data.CurData().GetLevel() + 1);
		if (playerLevelinfo == null)
		{
			return;
		}
		if (num >= playerLevelinfo.exp)
		{
			if (playerLevelinfo2 != null)
			{
				Crazy_Data.CurData().SetLevel(Crazy_Data.CurData().GetLevel() + 1);
				if (playerLevelinfo2.exp < 0)
				{
					Crazy_Data.CurData().SetExp(0);
				}
				else
				{
					Crazy_Data.CurData().SetExp(0);
				}
				LevelUp();
			}
		}
		else if (playerLevelinfo2 != null)
		{
			Crazy_Data.CurData().SetExp(num);
		}
	}
}
