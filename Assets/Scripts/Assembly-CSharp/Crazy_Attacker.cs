using System.Collections.Generic;
using UnityEngine;

public class Crazy_Attacker : MonoBehaviour
{
	public GameObject child;

	protected Crazy_PlayerControl parent;

	protected Vector3 moveDir;

	protected float moveSpeed;

	protected float attackrange;

	protected float attackangle;

	protected float attackrate;

	protected float attackdamage;

	protected Crazy_HitData hitdata;

	protected Crazy_Weapon_Type weapontype;

	protected bool isattack;

	protected float lasttime;

	protected float cur_time;

	protected List<GameObject> attacklist = new List<GameObject>();

	protected bool repeatedly;

	protected bool isskill = true;

	private void Start()
	{
		parent = GameObject.Find("Player").GetComponent("Crazy_PlayerControl") as Crazy_PlayerControl;
		child.active = false;
	}

	private void Update()
	{
		if (!isattack)
		{
			return;
		}
		cur_time += Time.deltaTime;
		if (cur_time >= attackrate)
		{
			AttackJudgment();
			cur_time = 0f;
			lasttime -= attackrate;
			if (lasttime <= 0f)
			{
				isattack = false;
				child.active = false;
			}
		}
		base.transform.position += moveDir * moveSpeed * Time.deltaTime;
		if (lasttime > 0f)
		{
			moveSpeed -= Time.deltaTime / lasttime * moveSpeed;
		}
	}

	protected virtual void AttackJudgment()
	{
		if (repeatedly)
		{
			attacklist.Clear();
		}
		int num = 0;
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
			Vector3 vector = base.gameObject.transform.position - new Vector3(0f, base.gameObject.transform.position.y, 0f) + base.gameObject.transform.forward * 2f;
			Vector3 vector2 = vector - crazy_EnemyControl.transform.position;
			float sqrMagnitude = vector2.sqrMagnitude;
			if (!(sqrMagnitude < (attackrange + crazy_EnemyControl.GetHitBox()) * (attackrange + crazy_EnemyControl.GetHitBox())))
			{
				continue;
			}
			float num2 = Vector3.Angle(-vector2, base.transform.forward);
			if (num2 < attackangle)
			{
				Vector3 vector3 = default(Vector3);
				vector3 = moveDir;
				vector3.Normalize();
				hitdata.beatDir = vector3;
				if (crazy_EnemyControl.Hurt(attackdamage, hitdata, weapontype, isskill))
				{
					num++;
				}
				parent.AddCombo();
				if (!isskill)
				{
					parent.AddEnergy();
				}
				attacklist.Add(curEnemyObj);
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

	public void Attack(Vector3 _dir, float _speed, float _range, float _angle, float _rate, float _damage, Crazy_HitData _hitdata, Crazy_Weapon_Type _weapon, float _lasttime, bool _isskill)
	{
		moveDir = _dir;
		moveSpeed = _speed;
		attackrange = _range;
		attackangle = _angle;
		attackrate = _rate;
		attackdamage = _damage;
		hitdata = _hitdata;
		weapontype = _weapon;
		lasttime = _lasttime;
		isattack = true;
		cur_time = 0f;
		child.active = true;
		attacklist.Clear();
		isskill = _isskill;
	}

	public void Attack(Vector3 _dir, float _speed, float _range, float _angle, float _rate, float _damage, Crazy_HitData _hitdata, Crazy_Weapon_Type _weapon, float _lasttime, bool instantly, bool _isskill)
	{
		moveDir = _dir;
		moveSpeed = _speed;
		attackrange = _range;
		attackangle = _angle;
		attackrate = _rate;
		attackdamage = _damage;
		hitdata = _hitdata;
		weapontype = _weapon;
		lasttime = _lasttime;
		isattack = true;
		cur_time = 0f;
		child.active = true;
		attacklist.Clear();
		if (instantly)
		{
			cur_time = attackrate;
			lasttime += attackrate;
		}
		isskill = _isskill;
	}

	public void Attack(Vector3 _dir, float _speed, float _range, float _angle, float _rate, float _damage, Crazy_HitData _hitdata, Crazy_Weapon_Type _weapon, float _lasttime, bool instantly, bool _repeatedly, bool _isskill)
	{
		moveDir = _dir;
		moveSpeed = _speed;
		attackrange = _range;
		attackangle = _angle;
		attackrate = _rate;
		attackdamage = _damage;
		hitdata = _hitdata;
		weapontype = _weapon;
		lasttime = _lasttime;
		isattack = true;
		cur_time = 0f;
		child.active = true;
		attacklist.Clear();
		if (instantly)
		{
			cur_time = attackrate;
			lasttime += attackrate;
		}
		repeatedly = _repeatedly;
		isskill = _isskill;
	}
}
