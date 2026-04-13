using UnityEngine;

public class UIControl
{
	protected UIContainer m_Parent;

	protected int m_Id;

	protected Rect m_Rect;

	protected bool m_Visible;

	protected bool m_Enable;

	protected bool m_Clip;

	protected Rect m_ClipRect;

	protected Rect m_PaddingRect;

	public int Id
	{
		get
		{
			return m_Id;
		}
		set
		{
			m_Id = value;
		}
	}

	public virtual Rect Rect
	{
		get
		{
			return m_Rect;
		}
		set
		{
			m_Rect = value;
		}
	}

	public virtual bool Visible
	{
		get
		{
			return m_Visible;
		}
		set
		{
			m_Visible = value;
		}
	}

	public virtual bool Enable
	{
		get
		{
			return m_Enable;
		}
		set
		{
			m_Enable = value;
		}
	}

	public UIControl()
	{
		m_Parent = null;
		m_Id = 0;
		m_Rect = new Rect(0f, 0f, 0f, 0f);
		m_Visible = true;
		m_Enable = true;
		m_PaddingRect = new Rect(0f, 0f, 0f, 0f);
	}

	public void SetParent(UIContainer parent)
	{
		m_Parent = parent;
	}

	public virtual void SetClip(Rect clip_rect)
	{
		m_Clip = true;
		m_ClipRect = clip_rect;
	}

	public void ClearClip()
	{
		m_Clip = false;
	}

	public virtual bool PtInRect(Vector2 pt)
	{
		if (pt.x >= m_Rect.xMin - m_PaddingRect.x && pt.x < m_Rect.xMax + m_PaddingRect.y && pt.y >= m_Rect.yMin - m_PaddingRect.height && pt.y < m_Rect.yMax + m_PaddingRect.width)
		{
			if (m_Clip)
			{
				return pt.x >= m_ClipRect.xMin - m_PaddingRect.x && pt.x < m_ClipRect.xMax + m_PaddingRect.y && pt.y >= m_ClipRect.yMin - m_PaddingRect.height && pt.y < m_ClipRect.yMax + m_PaddingRect.width;
			}
			return true;
		}
		return false;
	}

	public virtual void SetPadding(float left, float right, float up, float down)
	{
		m_PaddingRect = new Rect(left, right, up, down);
	}

	public virtual void Draw()
	{
	}

	public virtual void Update()
	{
	}

	public virtual bool HandleInput(UITouchInner touch)
	{
		return false;
	}
}
