using System.Runtime.CompilerServices;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class MyGUIEventListener : MonoBehaviour
{
	public delegate void EventHandlerVector2(GameObject sender, Vector2 vec2);

	public delegate void EventHandlerVoid(GameObject sender);

	public delegate void EventHandlerGameObject(GameObject sender, GameObject go);

	[method: MethodImpl(32)]
	public event EventHandlerVector2 EventHandleOnPressed;

	[method: MethodImpl(32)]
	public event EventHandlerVector2 EventHandleOnReleased;

	[method: MethodImpl(32)]
	public event EventHandlerVector2 EventHandleOnMoved;

	[method: MethodImpl(32)]
	public event EventHandlerVoid EventHandleOnFocus;

	[method: MethodImpl(32)]
	public event EventHandlerGameObject EventHandleOnLostFocus;

	[method: MethodImpl(32)]
	public event EventHandlerVoid EventHandleOnClicked;

	[method: MethodImpl(32)]
	public event EventHandlerVector2 EventHandleOnDragged;

	[method: MethodImpl(32)]
	public event EventHandlerGameObject EventHandleOnDropped;

	public static MyGUIEventListener Get(GameObject go)
	{
		MyGUIEventListener myGUIEventListener = go.GetComponent<MyGUIEventListener>();
		if (myGUIEventListener == null)
		{
			myGUIEventListener = go.AddComponent<MyGUIEventListener>();
		}
		return myGUIEventListener;
	}

	public void riseOnPressed(Vector2 pos)
	{
		if (this.EventHandleOnPressed != null)
		{
			this.EventHandleOnPressed(base.gameObject, pos);
		}
	}

	public void riseOnMoved(Vector2 delta)
	{
		if (this.EventHandleOnMoved != null)
		{
			this.EventHandleOnMoved(base.gameObject, delta);
		}
	}

	public void riseOnClicked()
	{
		if (this.EventHandleOnClicked != null)
		{
			this.EventHandleOnClicked(base.gameObject);
		}
	}

	public void riseOnFocus()
	{
		if (this.EventHandleOnFocus != null)
		{
			this.EventHandleOnFocus(base.gameObject);
		}
	}

	public void riseOnLostFocus(GameObject go)
	{
		if (this.EventHandleOnLostFocus != null)
		{
			this.EventHandleOnLostFocus(base.gameObject, go);
		}
	}

	public void riseOnReleased(Vector2 pos)
	{
		if (this.EventHandleOnReleased != null)
		{
			this.EventHandleOnReleased(base.gameObject, pos);
		}
	}

	public void riseOnDragged(Vector2 pos)
	{
		if (this.EventHandleOnDragged != null)
		{
			this.EventHandleOnDragged(base.gameObject, pos);
		}
	}

	public void riseOnDropped(GameObject go)
	{
		if (this.EventHandleOnDropped != null)
		{
			this.EventHandleOnDropped(base.gameObject, go);
		}
	}
}
