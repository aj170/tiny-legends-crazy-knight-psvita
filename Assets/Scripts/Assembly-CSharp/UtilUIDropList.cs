using System.Collections.Generic;
using UnityEngine;

public class UtilUIDropList : MonoBehaviour
{
	private int m_pageCount;

	private int m_pageIndex = -1;

	private TUIScroll m_scroll;

	private List<Crazy_Weapon> weapons = new List<Crazy_Weapon>();

	private int weapon_count;

	private Color namecolor = new Color(49f / 85f, 43f / 85f, 1f / 51f, 1f);

	private float deltay = 68f;

	private int stage_width_count = 1;

	private int stage_height_count = 3;

	private void InitWeaponList(List<Crazy_NetMission_Item> cnmilist)
	{
		weapons.Clear();
		List<Crazy_NetMission_Item> list = new List<Crazy_NetMission_Item>();
		foreach (Crazy_NetMission_Item item in cnmilist)
		{
			list.Add(item);
		}
		list.Sort((Crazy_NetMission_Item a, Crazy_NetMission_Item b) => a.itemseq.CompareTo(b.itemseq));
		List<Crazy_Weapon> list2 = Crazy_Weapon.ReadWeaponInfo();
		foreach (Crazy_NetMission_Item item2 in list)
		{
			weapons.Add(Crazy_Weapon.FindWeaponByID(list2, item2.itemid));
		}
	}

	public void Start()
	{
		GameObject gameObject = base.transform.Find("ScrollObject").Find("ItemPrefab").gameObject;
		Crazy_NetMission netMissionInfo = Crazy_NetMission.GetNetMissionInfo(Crazy_GlobalData_Net.Instance.netmissionID);
		InitWeaponList(netMissionInfo.item);
		weapon_count = weapons.ToArray().GetLength(0);
		for (int i = 0; i < weapon_count; i++)
		{
			Crazy_Weapon crazy_Weapon = weapons[i];
			bool flag = Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id];
			GameObject gameObject2 = Object.Instantiate(gameObject) as GameObject;
			gameObject2.name = "Weapon" + crazy_Weapon.id;
			gameObject2.transform.parent = gameObject.transform.parent;
			gameObject2.transform.localPosition = new Vector3(105f, 70f - (float)i * deltay, 0f);
			TUIMeshSprite component = gameObject2.transform.Find("Bk").GetComponent<TUIMeshSprite>();
			component.frameName = "weaponBk";
			component.UpdateMesh();
			TUIMeshSprite component2 = gameObject2.transform.Find("Mask").GetComponent<TUIMeshSprite>();
			component2.frameName = string.Empty;
			component2.UpdateMesh();
			TUIMeshSprite component3 = gameObject2.transform.Find("Status").GetComponent<TUIMeshSprite>();
			component3.frameName = ((!flag) ? string.Empty : "WeaponOwned");
			component3.UpdateMesh();
			TUIMeshText component4 = gameObject2.transform.Find("TextName").GetComponent<TUIMeshText>();
			component4.text = crazy_Weapon.name.ToUpper();
			component4.color = namecolor;
			component4.UpdateMesh();
			TUIMeshSprite component5 = gameObject2.transform.Find("Icon").GetComponent<TUIMeshSprite>();
			component5.frameName = crazy_Weapon.iconname;
			component5.UpdateMesh();
			TUIMeshText component6 = gameObject2.transform.Find("Level").Find("TextLevelData").GetComponent<TUIMeshText>();
			component6.text = crazy_Weapon.need.ToString();
			component6.UpdateMesh();
			TUIMeshText component7 = gameObject2.transform.Find("Damage").Find("TextDamageData").GetComponent<TUIMeshText>();
			component7.text = crazy_Weapon.damage.ToString();
			component7.UpdateMesh();
			TUIMeshText component8 = gameObject2.transform.Find("Speed").Find("TextSpeedData").GetComponent<TUIMeshText>();
			component8.text = ((int)(crazy_Weapon.move * 10f)).ToString();
			component8.UpdateMesh();
			UtilUISmallSkillBoard component9 = gameObject2.transform.Find("SmallSkillBoard").GetComponent<UtilUISmallSkillBoard>();
			component9.UpdateSkill(crazy_Weapon.skill);
		}
		m_pageCount = (weapon_count - 1) / (stage_width_count * stage_height_count) + 1;
		m_scroll = base.transform.Find("Scroll").gameObject.GetComponent<TUIScroll>();
		m_scroll.rangeYMin = 0f;
		m_scroll.borderYMin = m_scroll.rangeYMin - deltay * (float)stage_height_count / 2f;
		m_scroll.rangeYMax = (float)(m_pageCount - 1) * deltay * (float)stage_height_count;
		m_scroll.borderYMax = m_scroll.rangeYMax + deltay * (float)stage_height_count / 2f;
		m_scroll.pageY = new float[m_pageCount];
		for (int j = 0; j < m_pageCount; j++)
		{
			m_scroll.pageY[j] = (float)((m_pageCount - 1 - j) * stage_height_count) * deltay;
		}
		GameObject gameObject3 = base.transform.Find("Page").Find("PageDot01").gameObject;
		for (int k = 0; k < m_pageCount; k++)
		{
			GameObject gameObject4 = gameObject3;
			if (k != 0)
			{
				gameObject4 = Object.Instantiate(gameObject3) as GameObject;
				gameObject4.name = string.Format("PageDot{0:D02}", k + 1);
				gameObject4.transform.parent = gameObject3.transform.parent;
			}
			int num = 10;
			gameObject4.transform.localPosition = new Vector3(230f, (m_pageCount - 1) * num / 2 - k * num, 0f);
		}
	}

	public void Update()
	{
		int num = 0;
		int num2 = (int)m_scroll.position.y;
		for (int i = 0; i < m_pageCount; i++)
		{
			if ((float)num2 < (float)stage_height_count * deltay * ((float)i + 0.5f) + 1f)
			{
				num = i;
				break;
			}
		}
		if (m_pageIndex != num)
		{
			UpdatePage(num);
		}
	}

	private void UpdatePage(int pageIndex)
	{
		m_pageIndex = pageIndex;
		for (int i = 0; i < m_pageCount; i++)
		{
			TUIMeshSprite component = base.transform.Find("Page").Find(string.Format("PageDot{0:D02}", i + 1)).Find("Active")
				.gameObject.GetComponent<TUIMeshSprite>();
			TUIMeshSprite component2 = base.transform.Find("Page").Find(string.Format("PageDot{0:D02}", i + 1)).Find("Inactive")
				.gameObject.GetComponent<TUIMeshSprite>();
			if (i != m_pageIndex)
			{
				component.active = false;
				component2.active = true;
			}
			else
			{
				component.active = true;
				component2.active = false;
			}
			component.UpdateMesh();
			component2.UpdateMesh();
		}
	}
}
