using System.Collections.Generic;
using UnityEngine;

public class UtilUIWeaponShop : MonoBehaviour
{
	public bool active
	{
		get { return gameObject.activeSelf; }
		set { gameObject.SetActive(value); }
	}

	private int m_pageCount;

	private int m_pageIndex = -1;

	private TUIScroll m_scroll;

	private List<Crazy_Weapon> weapons = new List<Crazy_Weapon>();

	public Crazy_Weapon_Type m_type;

	private int weapon_count;

	private int show_weapon_count;

	private List<Color> namecolor;

	public GameObject rootshop;

	public void Start()
	{
		namecolor = new List<Color>();
		Color item = new Color(49f / 85f, 43f / 85f, 1f / 51f, 1f);
		namecolor.Add(item);
		item = new Color(0.11764706f, 1f, 0f, 1f);
		namecolor.Add(item);
		item = new Color(0f, 0.44313726f, 74f / 85f, 1f);
		namecolor.Add(item);
		item = new Color(0.64705884f, 16f / 85f, 0.9372549f, 1f);
		namecolor.Add(item);
		GameObject gameObject = base.transform.Find("ScrollObject").Find("ItemPrefab").gameObject;
		int num = 2;
		int num2 = 2;
		weapons = Crazy_Weapon.ReadWeaponInfo(m_type);
		weapon_count = weapons.ToArray().GetLength(0);
		show_weapon_count = weapon_count;
		int order = 0;
		int num3 = 0;
		while (true)
		{
			Crazy_Weapon crazy_Weapon = Crazy_Weapon.FindWeaponByOrder(weapons, order);
			if (crazy_Weapon == null)
			{
				break;
			}
			order = crazy_Weapon.order;
			if (!crazy_Weapon.isshow && !Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
			{
				show_weapon_count--;
			}
			else
			{
				GameObject gameObject2 = Object.Instantiate(gameObject) as GameObject;
				gameObject2.name = "Weapon" + crazy_Weapon.id;
				gameObject2.transform.parent = gameObject.transform.parent;
				gameObject2.transform.localPosition = new Vector3(-72 + num3 % num * 145 + num3 / (num * num2) * 290, 50 - num3 % (num * num2) / num * 98, 0f);
				TUIMeshText component = gameObject2.transform.Find("TextName").GetComponent<TUIMeshText>();
				component.text = crazy_Weapon.name;
				component.color = namecolor[crazy_Weapon.level];
				component.UpdateMesh();
				TUIMeshSprite component2 = gameObject2.transform.Find("Icon").GetComponent<TUIMeshSprite>();
				component2.frameName = crazy_Weapon.iconname;
				component2.UpdateMesh();
				TUIMeshText component3 = gameObject2.transform.Find("Level").Find("TextLevelData").GetComponent<TUIMeshText>();
				component3.text = crazy_Weapon.need.ToString();
				component3.UpdateMesh();
				TUIMeshText component4 = gameObject2.transform.Find("Damage").Find("TextDamageData").GetComponent<TUIMeshText>();
				component4.text = crazy_Weapon.damage.ToString();
				component4.UpdateMesh();
				TUIMeshText component5 = gameObject2.transform.Find("Speed").Find("TextSpeedData").GetComponent<TUIMeshText>();
				component5.text = ((int)(crazy_Weapon.move * 10f)).ToString();
				component5.UpdateMesh();
				TUIMeshText component6 = gameObject2.transform.Find("Money").Find("MoneyData").GetComponent<TUIMeshText>();
				if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
				{
					component6.text = string.Empty;
				}
				else
				{
					component6.text = crazy_Weapon.price.ToString();
				}
				component6.UpdateMesh();
				TUIMeshSprite component7 = gameObject2.transform.Find("Money").Find("MoneyType").GetComponent<TUIMeshSprite>();
				if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
				{
					component7.frameName = string.Empty;
				}
				else if (crazy_Weapon.price_type == Crazy_Price_Type.Crystal)
				{
					component7.frameName = "CrystalSmall";
				}
				else
				{
					component7.frameName = "GoldSmall";
				}
				component7.UpdateMesh();
				UtilUISmallSkillBoard component8 = gameObject2.transform.Find("SmallSkillBoard").GetComponent<UtilUISmallSkillBoard>();
				component8.UpdateSkill(crazy_Weapon.skill);
				num3++;
			}
			order++;
		}
		UpdateWeaponInfo();
		m_pageCount = (show_weapon_count - 1) / (num * num2) + 1;
		m_scroll = base.transform.Find("Scroll").gameObject.GetComponent<TUIScroll>();
		m_scroll.rangeXMin = -(m_pageCount - 1) * 290;
		m_scroll.borderXMin = m_scroll.rangeXMin - 145f;
		m_scroll.rangeXMax = 0f;
		m_scroll.borderXMax = m_scroll.rangeXMax + 145f;
		m_scroll.pageX = new float[m_pageCount];
		for (int i = 0; i < m_pageCount; i++)
		{
			m_scroll.pageX[i] = -(m_pageCount - 1 - i) * 290;
		}
		if (Crazy_Data.CurData().GetFirstVersion() <= 1010 && !Crazy_Data.CurData().GetPresent())
		{
			Crazy_Data.CurData().TenCrystalPresent();
			Crazy_Data.SaveData();
			OtherPlugin.AlertView("Congrats", "You found the shop! Buy yourself something nice with these 10 free tCrystals!");
			MoveToWeapon(7, num, num2, -290);
		}
		else if (Crazy_GlobalData.iapweapon != -1)
		{
			MoveToWeapon(Crazy_GlobalData.iapweapon, num, num2, -290);
			Crazy_GlobalData.iapweapon = -1;
		}
		else if (Crazy_GlobalData.unlock_weaponid.Count != 0)
		{
			MoveToWeapon(Crazy_GlobalData.unlock_weaponid[0], num, num2, -290);
		}
		else
		{
			MoveToWeapon(Crazy_Data.CurData().GetWeaponId(), num, num2, -290);
		}
		GameObject gameObject3 = base.transform.Find("Page").Find("PageDot01").gameObject;
		for (int j = 0; j < m_pageCount; j++)
		{
			GameObject gameObject4 = gameObject3;
			if (j != 0)
			{
				gameObject4 = Object.Instantiate(gameObject3) as GameObject;
				gameObject4.name = string.Format("PageDot{0:D02}", j + 1);
				gameObject4.transform.parent = gameObject3.transform.parent;
			}
			int num4 = 10;
			gameObject4.transform.localPosition = new Vector3(-(m_pageCount - 1) * num4 / 2 + j * num4, -100f, 0f);
		}
	}

	protected bool GetWeaponPosition(int id, ref int position)
	{
		Crazy_Weapon crazy_Weapon = Crazy_Weapon.FindWeaponByID(weapons, id);
		if (crazy_Weapon == null)
		{
			position = 0;
			return false;
		}
		int num = -1;
		int num2;
		for (num2 = 0; num2 <= crazy_Weapon.order; num2++)
		{
			Crazy_Weapon crazy_Weapon2 = Crazy_Weapon.FindWeaponByOrder(weapons, num2);
			if (crazy_Weapon2 == null)
			{
				break;
			}
			num2 = crazy_Weapon2.order;
			if (crazy_Weapon2.isshow || Crazy_Data.CurData().GetWeapon()[crazy_Weapon2.id])
			{
				num++;
			}
		}
		position = num;
		return true;
	}

	protected void MoveToWeapon(int id, int width, int height, int step)
	{
		int position = 0;
		if (!GetWeaponPosition(id, ref position))
		{
			m_scroll.position.x = position / (width * height) * step;
			m_scroll.SendMessage("ScrollObjectMove", SendMessageOptions.DontRequireReceiver);
			return;
		}
		m_scroll.position.x = position / (width * height) * step;
		m_scroll.SendMessage("ScrollObjectMove", SendMessageOptions.DontRequireReceiver);
		if (rootshop != null)
		{
			rootshop.SendMessage("MoveToWeapon", m_type);
		}
	}

	protected void OnNewWeapon(TUIMeshSprite bk, Crazy_ParticleEmitter cpe)
	{
		bk.frameName = "WeaponGetBk";
		cpe.Emit();
		bk.UpdateMesh();
	}

	protected void OffNewWeapon(TUIMeshSprite bk, Crazy_ParticleEmitter cpe)
	{
		bk.frameName = "WeaponBk";
		cpe.Stop();
		bk.UpdateMesh();
	}

	public void UpdateWeaponInfo()
	{
		int order = 0;
		while (true)
		{
			Crazy_Weapon crazy_Weapon = Crazy_Weapon.FindWeaponByOrder(weapons, order);
			if (crazy_Weapon == null)
			{
				break;
			}
			order = crazy_Weapon.order;
			if (crazy_Weapon.isshow || Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
			{
				TUIMeshSprite component = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("State")
					.Find("Equipped")
					.GetComponent<TUIMeshSprite>();
				TUIMeshSprite component2 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("State")
					.Find("Locked")
					.GetComponent<TUIMeshSprite>();
				TUIMeshSprite component3 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("State")
					.Find("Owned")
					.GetComponent<TUIMeshSprite>();
				TUIButtonClick component4 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Button")
					.GetComponent<TUIButtonClick>();
				TUIMeshText component5 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Level/TextLevelData")
					.GetComponent<TUIMeshText>();
				TUIMeshText component6 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Level/TextLevel")
					.GetComponent<TUIMeshText>();
				TUIMeshSprite component7 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Bk")
					.GetComponent<TUIMeshSprite>();
				Crazy_ParticleEmitter component8 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Effect")
					.GetComponent<Crazy_ParticleEmitter>();
				bool flag = false;
				foreach (int item in Crazy_GlobalData.unlock_weaponid)
				{
					if (item == crazy_Weapon.id)
					{
						OnNewWeapon(component7, component8);
						flag = true;
					}
				}
				if (!flag)
				{
					OffNewWeapon(component7, component8);
				}
				TUIMeshText component9 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Money")
					.Find("MoneyData")
					.GetComponent<TUIMeshText>();
				if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
				{
					component9.text = string.Empty;
				}
				else
				{
					component9.text = crazy_Weapon.price.ToString();
				}
				component9.UpdateMesh();
				TUIMeshSprite component10 = base.transform.Find("ScrollObject").Find("Weapon" + crazy_Weapon.id).Find("Money")
					.Find("MoneyType")
					.GetComponent<TUIMeshSprite>();
				if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
				{
					component10.frameName = string.Empty;
				}
				else if (crazy_Weapon.price_type == Crazy_Price_Type.Crystal)
				{
					component10.frameName = "CrystalSmall";
				}
				else
				{
					component10.frameName = "GoldSmall";
				}
				component10.UpdateMesh();
				if (crazy_Weapon.need > Crazy_Data.CurData().GetLevel())
				{
					if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
					{
						component3.active = true;
						component2.active = false;
						component.active = false;
					}
					else
					{
						component2.active = true;
						component3.active = false;
						component.active = false;
					}
					component6.color = new Color(1f, 0f, 0f, 1f);
					component5.color = new Color(1f, 0f, 0f, 1f);
				}
				else
				{
					component2.active = false;
					component6.color = new Color(48f / 85f, 0.75686276f, 66f / 85f, 1f);
					component5.color = new Color(48f / 85f, 0.75686276f, 66f / 85f, 1f);
					if (Crazy_Data.CurData().GetWeapon()[crazy_Weapon.id])
					{
						if (Crazy_Data.CurData().GetWeaponId() == crazy_Weapon.id)
						{
							component.active = true;
							component3.active = false;
						}
						else
						{
							component.active = false;
							component3.active = true;
						}
					}
					else
					{
						component.active = false;
						component3.active = false;
					}
				}
				component2.UpdateMesh();
				component.UpdateMesh();
				component3.UpdateMesh();
			}
			order++;
		}
	}

	public void Update()
	{
		int num = 0;
		int num2 = (int)m_scroll.position.x;
		for (int i = 0; i < m_pageCount; i++)
		{
			if (num2 > -290 * i - 145 - 1)
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
