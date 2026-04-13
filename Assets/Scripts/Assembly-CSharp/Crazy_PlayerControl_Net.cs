using System;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(TAudioController))]
public class Crazy_PlayerControl_Net : Crazy_PlayerControl
{
	public void NetWorkHurt()
	{
		PlayShakeSceenEffect(0.1f, 0.03f, 1f);
		PlayBloodEffect();
		if (attacking)
		{
			StopAttack();
		}
		if (shotting)
		{
			PauseShot();
		}
		OnInvincible(3f);
		switchPlayerUpStatus(Crazy_PlayerStatus.Hurt);
		lasthurttime = 0f;
	}

	protected override void AttackEnemy(int index)
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

	protected override void Update()
	{
		try
		{
			base.Update();
		}
		catch (Exception message)
		{
			Debug.Log(message);
		}
	}

	private void SendAttackEnemy()
	{
	}

	public void Revive()
	{
		if (IsDie())
		{
			cur_health = GetMaxHealth();
			base.GetComponent<Animation>().Stop();
			base.GetComponent<Animation>().CrossFade("Idle01_" + cur_weapon.type_name + "01_merge", 0.2f);
			switchPlayerUpStatus(Crazy_PlayerStatus.Idle);
			OnInvincible2(5f);
		}
	}

	protected override void Die()
	{
		Crazy_MyScene_Net crazy_MyScene_Net = Crazy_SceneManager.GetInstance().GetScene() as Crazy_MyScene_Net;
		crazy_MyScene_Net.ShowRevive();
	}

	public void OnFlyAway(Crazy_HitData chd)
	{
		if (!Invincible() && !IsDie())
		{
			PlayShakeSceenEffect(0.1f, 0.03f, 1f);
			if (attacking)
			{
				StopAttack();
			}
			if (shotting)
			{
				PauseShot();
			}
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
	}
}
