using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(TAudioController))]
public class PlayerAnimationSynchronizer : AnimationSynchronizer
{
	public float animationspeedmodify0 = 0.7f;

	protected Crazy_Weapon weapon;

	protected Dictionary<string, Crazy_AttackStatus> attackstatus = new Dictionary<string, Crazy_AttackStatus>();

	protected Dictionary<string, GameObject> attackeffectdic = new Dictionary<string, GameObject>();

	protected Crazy_PlayerStatus type;

	protected Crazy_PlayerStatus up_type;

	protected Crazy_AttackStatus cur_status;

	protected bool attacking;

	protected float lastattackingtime = 10000f;

	protected float lastadvattackeffecttime;

	protected GameObject RootNode;

	protected GameObject[] attack_effect_Obj;

	protected Crazy_ParticleSequenceScript hammerskilleffect;

	protected Crazy_PlayAnimation hammerskillhand;

	protected Crazy_PlayAnimation hammerskillmodel;

	protected Crazy_PlayAnimation axeskillmodel;

	protected GameObject[] swordskilleffectmodel;

	protected Crazy_ParticleSequenceScript swordchargeeffect;

	protected Crazy_ParticleSystemSequenceScript bowchargeeffect;

	protected Crazy_PlayAnimation bowarrow;

	protected Crazy_ParticleSystemSequenceScript rainarroweffect;

	protected Crazy_ParticleSystemSequenceScript rainarrowintroeffect;

	protected Crazy_ParticleSystemSequenceScript rainarrowhiteffect;

	protected GameObject m_arrow;

	protected float playersamplerate = 1f / 30f;

	protected bool reducemove;

	protected float reducemoverate;

	protected bool reducespeed;

	protected float reducespeedrate;

	protected float skillinterval = 3f;

	protected float lastskillinterval;

	private bool invincible;

	private float invincibletime;

	private float lastinvincibletime;

	protected List<float> lastattackjudgmenttime = new List<float>();

	private Dictionary<Material, Color> player_color = new Dictionary<Material, Color>();

	public void Awake()
	{
		InitAnimations();
		attackstatus = Crazy_AttackStatus.ReadAttackStatusInfo();
		type = Crazy_PlayerStatus.None;
		RootNode = GameObject.Find("Scene");
	}

	public void SetWeapon(Crazy_Weapon wea)
	{
		weapon = wea;
		weapon.AddWeaponSkillImage(this);
		CalculateAnimation(Crazy_PlayerStatus.Stand);
	}

	protected virtual bool CheckAnimation()
	{
		return Mathf.Abs(base.GetComponent<Animation>()["Attack01_Sword01_merge"].speed - 1f * animationspeedmodify0) <= 0.01f;
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
			base.GetComponent<Animation>()["Attack01_Sword01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack02_Sword01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack03_Sword01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack04_Sword01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Skill01_Sword01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack01_Hammer01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack02_Hammer01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack03_Hammer01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack04_Hammer01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Skill01_Hammer01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack01_Axe01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack02_Axe01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack03_Axe01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Attack04_Axe01_merge"].speed = 1f * animationspeedmodify0;
			base.GetComponent<Animation>()["Skill01_Axe01_merge"].speed = 1f * animationspeedmodify0;
			AddAnimationEvent();
		}
	}

	protected void AddAnimationEvent()
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

	private void InitAnimations()
	{
		ModifyAnimation();
	}

	private void Start()
	{
		InitWeaponEffect();
		Transform transform = base.transform.Find("zhujue");
		SkinnedMeshRenderer skinnedMeshRenderer = transform.gameObject.GetComponent("SkinnedMeshRenderer") as SkinnedMeshRenderer;
		Material[] materials = skinnedMeshRenderer.materials;
		for (int i = 0; i < materials.Length; i++)
		{
			player_color.Add(materials[i], materials[i].color);
		}
	}

	protected virtual void InitWeaponEffect()
	{
		attackeffectdic.Clear();
		attackeffectdic = new Dictionary<string, GameObject>();
		switch (weapon.type)
		{
		case Crazy_Weapon_Type.Sword:
		{
			swordskilleffectmodel = new GameObject[3];
			for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
			{
				swordskilleffectmodel[i] = Crazy_Global.LoadAssetsPrefab("Prefabs/swordskilleffect/swordskilleffect_pfb_image");
				swordskilleffectmodel[i].layer = LayerMask.NameToLayer("Player");
				swordskilleffectmodel[i].name = "swordskillmodel_effect" + (i + 1).ToString("D2");
				swordskilleffectmodel[i].transform.parent = RootNode.transform;
			}
			GameObject gameObject10 = Crazy_Global.LoadAssetsPrefab("Prefabs/charge/charge_pfb");
			swordchargeeffect = gameObject10.GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
			swordchargeeffect.gameObject.layer = LayerMask.NameToLayer("Player");
			swordchargeeffect.gameObject.name = "SwordChargeEffect";
			swordchargeeffect.gameObject.transform.parent = FindWeaponBone(weapon.type, base.gameObject).transform.Find("Weapon").transform;
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
			GameObject gameObject4 = Crazy_Global.LoadAssetsPrefab("Prefabs/rainarrow/rainarrowhit_pfb_image");
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

	public void ExtraAttackEffect()
	{
		if (cur_status.attackname == "Skill01_Hammer01")
		{
			hammerskillmodel.Play();
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

	public GameObject GetRootNode()
	{
		return RootNode;
	}

	protected void InitWeaponLight()
	{
		attack_effect_Obj = new GameObject[4];
		switch (weapon.type)
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

	private void AttackEnemy(int index)
	{
		ExtraAttackMaker(index);
		ExtraAttackEffect();
	}

	private void ExtraAttackMakerPretreatment()
	{
		for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
		{
			Crazy_Attacker_Image crazy_Attacker_Image = swordskilleffectmodel[i].GetComponent("Crazy_Attacker_Image") as Crazy_Attacker_Image;
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

	protected void ExtraAttackMaker(int index)
	{
		if (cur_status.attackname == "Skill01_Sword01")
		{
			for (int i = 0; i < swordskilleffectmodel.GetLength(0); i++)
			{
				Crazy_Attacker_Image crazy_Attacker_Image = swordskilleffectmodel[i].GetComponent("Crazy_Attacker_Image") as Crazy_Attacker_Image;
				Vector3 forward = base.transform.forward;
				Vector2 forward2 = new Vector2(forward.x, forward.z);
				forward2 = Crazy_Global.Rotate(forward2, 45 * (i - 1));
				forward = new Vector3(forward2.x, forward.y, forward2.y);
				swordskilleffectmodel[i].transform.position = base.transform.position + forward;
				swordskilleffectmodel[i].transform.forward = forward;
				forward.Normalize();
				crazy_Attacker_Image.Attack(forward, 25f, 0f, 0f, 0.1f, 0f, cur_status.attackjudgmentinfo[index].hitdata, weapon.type, 1.5f, false);
				swordskilleffectmodel[i].GetComponent<Animation>().Play("sword skill_effect");
			}
		}
		else if (cur_status.attackname == "Skill01_Bow01")
		{
			Crazy_Attacker_Image crazy_Attacker_Image2 = rainarrowhiteffect.gameObject.GetComponent("Crazy_Attacker_Image") as Crazy_Attacker_Image;
			Vector3 zero = Vector3.zero;
			crazy_Attacker_Image2.Attack(zero, 0f, 0f, 0f, 0.8f, 0f, cur_status.attackjudgmentinfo[index].hitdata, weapon.type, 5f, true, true, false);
		}
	}

	protected void updateAttack(float deltatime)
	{
		lastattackingtime += deltatime;
		updateAttackJudgment(deltatime);
		updateAdvAttackEffect(deltatime);
	}

	protected Vector3 GetAttackPoint(int index)
	{
		Vector2 original = new Vector2(base.transform.position.x, base.transform.position.z);
		Vector2 forward = new Vector2(base.transform.forward.x, base.transform.forward.z);
		Vector2 vector = Crazy_Global.RotatebyAngle(original, forward, cur_status.attackjudgmentinfo[index].attackpoint.angle, cur_status.attackjudgmentinfo[index].attackpoint.length);
		Vector3 result = new Vector3(vector.x, base.transform.position.y, vector.y);
		return result;
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
		if (attackeffectdic.TryGetValue(cur_status.attackadveffectdata.effectname, out value))
		{
			value.transform.parent = RootNode.transform;
			value.transform.localEulerAngles = Vector3.zero;
			value.transform.position = GetAttackPoint(0) + cur_status.attackadveffectdata.delta;
			if (cur_status.attackadveffectdata.isfollow)
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
	}

	private void updateAttackJudgment(float deltatime)
	{
		if (!attacking)
		{
			return;
		}
		for (int i = 0; i < lastattackjudgmenttime.ToArray().GetLength(0); i++)
		{
			if (!cur_status.attackjudgmentinfo[i].usecallback && lastattackjudgmenttime[i] != 0f)
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

	protected void EventAnimation(AnimationClip ani, int frame, string functionname, int intP = 0, float floatP = 0f, string stringP = "", Object objectP = null)
	{
		Crazy_Global.EventAnimation(ani, (float)frame * playersamplerate, functionname, intP, floatP, stringP, objectP);
	}

	public GameObject GetArrow(Transform position)
	{
		return Object.Instantiate(Resources.Load("Prefabs/bowarrow/bowarrow_pfb_image"), position.position, position.rotation) as GameObject;
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
		Crazy_Attacker_Image crazy_Attacker_Image = m_arrow.GetComponent("Crazy_Attacker_Image") as Crazy_Attacker_Image;
		Vector3 forward = base.transform.forward;
		forward.Normalize();
		crazy_Attacker_Image.Attack(forward, 50f, 0f, 0f, 0.1f, 0f, default(Crazy_HitData), weapon.type, 1.5f, false);
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

	public virtual void ReceiverStatus(Crazy_PlayerStatus status, string attackname)
	{
		switch (status)
		{
		case Crazy_PlayerStatus.Idle:
			base.GetComponent<Animation>().Stop();
			base.GetComponent<Animation>().CrossFade("Idle01_" + weapon.type_name + "01_merge", 0.2f);
			attacking = false;
			break;
		case Crazy_PlayerStatus.Die:
			base.GetComponent<Animation>().Play("Death01_" + weapon.type_name + "01_merge");
			attacking = false;
			break;
		case Crazy_PlayerStatus.Hurt:
			attacking = false;
			OnInvincible(3f);
			base.GetComponent<Animation>().Play("Damage01_" + weapon.type_name + "01_merge");
			break;
		case Crazy_PlayerStatus.Injury:
			attacking = false;
			OnInvincible(3f);
			base.GetComponent<Animation>().Play("Knockdown_" + weapon.type_name + "01_merge");
			break;
		case Crazy_PlayerStatus.Deject:
			attacking = false;
			base.GetComponent<Animation>().Play(weapon.type_name + "01_lose_merge");
			break;
		case Crazy_PlayerStatus.Celebrate:
			attacking = false;
			base.GetComponent<Animation>().Play("Idle_" + weapon.type_name + "01_celebrate01_merge");
			break;
		case Crazy_PlayerStatus.Roll:
			attacking = false;
			base.GetComponent<Animation>().CrossFade("Roll01_" + weapon.type_name + "01_merge", 0.1f);
			break;
		case Crazy_PlayerStatus.Shot:
			attacking = false;
			cur_status = attackstatus[attackname];
			AnimationCrossFade(cur_status.attackanimname, 0.1f);
			break;
		case Crazy_PlayerStatus.Attack:
			attacking = true;
			cur_status = attackstatus[attackname];
			AnimationCrossFade(cur_status.attackanimname, 0.1f);
			lastattackingtime = 0f;
			lastattackjudgmenttime.Clear();
			foreach (Crazy_AttackJudgmentInfo item in cur_status.attackjudgmentinfo)
			{
				lastattackjudgmenttime.Add(item.attackjudgmenttime);
			}
			lastadvattackeffecttime = cur_status.attackadveffectdata.begintime;
			break;
		case Crazy_PlayerStatus.Skill:
			attacking = true;
			cur_status = attackstatus[attackname];
			AnimationCrossFade(cur_status.attackanimname, 0.1f);
			lastattackingtime = 0f;
			lastattackjudgmenttime.Clear();
			foreach (Crazy_AttackJudgmentInfo item2 in cur_status.attackjudgmentinfo)
			{
				lastattackjudgmenttime.Add(item2.attackjudgmenttime);
			}
			lastadvattackeffecttime = cur_status.attackadveffectdata.begintime;
			if (weapon.type == Crazy_Weapon_Type.Hammer)
			{
				hammerskilleffect.EmitParticle();
				hammerskillhand.Play();
			}
			else if (weapon.type == Crazy_Weapon_Type.Sword)
			{
				swordchargeeffect.EmitParticle();
			}
			else if (weapon.type == Crazy_Weapon_Type.Axe)
			{
				axeskillmodel.Play();
			}
			else if (weapon.type == Crazy_Weapon_Type.Bow)
			{
				rainarroweffect.EmitParticle();
			}
			break;
		default:
			attacking = false;
			break;
		}
	}

	protected void OnInvincible(float time)
	{
		invincible = true;
		lastinvincibletime = 0f;
		invincibletime = time;
	}

	public override void CalculateAnimation(float delta)
	{
		if (delta < 0.1f)
		{
			CalculateAnimation(Crazy_PlayerStatus.Stand);
		}
		else
		{
			CalculateAnimation(Crazy_PlayerStatus.Move);
		}
	}

	public void CalculateAnimation(Crazy_PlayerStatus status)
	{
		if (type != status)
		{
			type = status;
		}
		switch (type)
		{
		case Crazy_PlayerStatus.Stand:
			base.GetComponent<Animation>().CrossFade("Idle01_" + weapon.type_name + "01_merge", 0.2f);
			break;
		case Crazy_PlayerStatus.Move:
			base.GetComponent<Animation>().CrossFade("Forward01_" + weapon.type_name + "01_merge", 0.2f);
			break;
		}
	}

	public void OnPlayUVAnimationCallBack()
	{
		if (cur_status != null && cur_status.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_status.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			MergeUVAnimation(crazy_UVAnimation);
			crazy_UVAnimation.SetTimeFactor(base.GetComponent<Animation>()[cur_status.attackanimname].speed);
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
		if (cur_status != null && cur_status.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_status.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			crazy_UVAnimation.Pause();
		}
	}

	public void ContinueUVAnimation()
	{
		if (cur_status != null && cur_status.attackeffectid != -1)
		{
			Crazy_UVAnimation crazy_UVAnimation = attack_effect_Obj[cur_status.attackeffectid].GetComponent("Crazy_UVAnimation") as Crazy_UVAnimation;
			crazy_UVAnimation.Continue();
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
		if (Time.deltaTime != 0f && invincible)
		{
			lastinvincibletime += Time.deltaTime;
			if (lastinvincibletime >= invincibletime)
			{
				invincible = false;
				SetModelColorOriginal();
			}
			else
			{
				float rate_r = Random.Range(0, 2);
				SetModelColorRate(rate_r, 0f, 0f);
			}
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

	private void Update()
	{
		updateInvincible();
		updateWeaponSkill();
		if (attacking)
		{
			updateAttack(base.GetComponent<Animation>()[cur_status.attackanimname].speed * Time.deltaTime);
		}
		else
		{
			lastattackingtime += Time.deltaTime;
		}
	}
}
