using UnityEngine;

public class MyGUICheckBox : MyGUIWidget
{
	public TUIMeshSprite sprite;

	public bool Enabled = true;

	public string m_pushedSprite;

	public string m_disabledSprite;

	public string m_normalSprite;

	public bool m_bSelected;

	private bool IsSelected
	{
		get
		{
			return m_bSelected;
		}
		set
		{
			if (m_bSelected != value)
			{
				m_bSelected = value;
				updateButtonState();
			}
		}
	}

	private void Awake()
	{
		if (sprite == null)
		{
			Debug.Log("not set texture");
		}
	}

	private void Start()
	{
		MyGUIEventListener myGUIEventListener = MyGUIEventListener.Get(base.gameObject);
		myGUIEventListener.EventHandleOnPressed += onPressed;
	}

	private void setState(string state)
	{
		sprite.frameName = state;
		sprite.UpdateMesh();
	}

	private void updateButtonState()
	{
		if (!Enabled)
		{
			setState(m_disabledSprite);
		}
		else if (IsSelected)
		{
			setState(m_pushedSprite);
		}
		else
		{
			setState(m_normalSprite);
		}
	}

	protected override void onPressed(GameObject go, Vector2 pos)
	{
		IsSelected = !m_bSelected;
	}
}
