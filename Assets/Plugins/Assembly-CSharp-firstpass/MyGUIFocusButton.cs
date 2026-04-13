using UnityEngine;

public class MyGUIFocusButton : MonoBehaviour
{
	public bool m_focused;

	public TUIMeshSprite sprite;

	public string normalSprite;

	public string focusedSprite;

	private void Awake()
	{
		if (sprite == null)
		{
			sprite = GetComponentInChildren<TUIMeshSprite>();
		}
	}

	private void Start()
	{
		MyGUIEventListener myGUIEventListener = MyGUIEventListener.Get(base.gameObject);
		myGUIEventListener.EventHandleOnFocus += OnFocus;
		myGUIEventListener.EventHandleOnLostFocus += OnLostFocus;
	}

	protected virtual void OnFocus(GameObject go)
	{
		m_focused = true;
		sprite.frameName = focusedSprite;
		sprite.UpdateMesh();
	}

	protected virtual void OnLostFocus(GameObject sender, GameObject go)
	{
		m_focused = false;
		sprite.frameName = normalSprite;
		sprite.UpdateMesh();
	}
}
