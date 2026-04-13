using UnityEngine;

public class UICrazyScene : MonoBehaviour, TUIHandler
{
	private TUI m_tui;

	protected Crazy_MyScene m_imp;

	protected UtilUIPause UIPause;

	protected UtilUIBeginnerHintControl UIBeginnerHint;

	protected TUIContainer UIBattle;

	protected UtilUIReviveControl UIRevive;

	private bool isMovie = true;

	protected GameObject countZero;

	protected GameObject waitTotal;

	public virtual void OnDestroy()
	{
		m_imp = null;
		Crazy_SceneManager.GetInstance().Uninitialized();
	}

	public void Awake()
	{
		GameObject gameObject = GameObject.Find("Scene");
		GameObject gameObject2 = null;
		gameObject2 = Object.Instantiate(Resources.Load("UI/CrazyScene/SceneTUIForIPhone5")) as GameObject;
		gameObject2.name = "SceneTUI";
		gameObject2.transform.parent = gameObject.transform;
		UIPause = gameObject2.transform.Find("TUI/TUIControl/Pause").GetComponent<UtilUIPause>();
		UIBeginnerHint = gameObject2.transform.Find("TUI/TUIControl/BeginnerHint").GetComponent<UtilUIBeginnerHintControl>();
		UIBattle = gameObject2.transform.Find("TUI/TUIControl/Battle").GetComponent<TUIContainer>();
		UIRevive = gameObject2.transform.Find("TUI/TUIControl/ReviveControl").GetComponent<UtilUIReviveControl>();
		countZero = gameObject2.transform.Find("TUI/TUIControl/CountZero").gameObject;
		waitTotal = gameObject2.transform.Find("TUI/TUIControl/Mask").gameObject;
		countZero.gameObject.SetActiveRecursively(false);
		waitTotal.gameObject.SetActiveRecursively(false);
		ImpAwake();
	}

	protected virtual void ImpAwake()
	{
		m_imp = new Crazy_MyScene();
		Crazy_SceneManager.GetInstance().Initialized(m_imp);
		m_imp.Awake(UIPause, UIBeginnerHint);
	}

	public void Start()
	{
		m_tui = TUI.Instance("Scene/SceneTUI/TUI");
		m_tui.SetHandler(this);
		m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
			.FadeIn();
		Movie();

#if UNITY_STANDALONE || UNITY_EDITOR
		PCInputStart();
#endif
    }

	public virtual void OnApplicationPause(bool pause)
	{
		if (pause)
		{
			m_imp.Save();
		}
		else if (!isMovie)
		{
			m_imp.OnPauseDown();
		}
	}

	public void Movie()
	{
		isMovie = true;
		m_tui.transform.Find("TUICamera").gameObject.active = false;
		Invoke("EndMovie", 3f);
	}

	public void EndMovie()
	{
		m_tui.transform.Find("TUICamera").gameObject.active = true;
		isMovie = false;
		m_imp.OnGameBegin();
	}

	public void ResetButton()
	{
		TUIControlImpl[] componentsInChildren = UIBattle.GetComponentsInChildren<TUIControlImpl>();
		TUIControlImpl[] array = componentsInChildren;
		foreach (TUIControlImpl tUIControlImpl in array)
		{
			tUIControlImpl.gameObject.SendMessage("Reset", SendMessageOptions.DontRequireReceiver);
		}
	}

	public void Update()
	{
		TUIInput[] input = TUIInputManager.GetInput();
		if (!isMovie)
		{
			for (int i = 0; i < input.Length; i++)
			{
				m_tui.HandleInput(input[i]);
            }
            if (Input.GetButtonDown("Pause"))
            {
                if (Time.timeScale == 0) m_imp.OnContinueDown();
                else m_imp.OnPauseDown();
            }

#if UNITY_STANDALONE || UNITY_EDITOR
            PCInput(); // DO NOT COMPILE ON NON TOUCHSCREEN, OVERRIDES TOUCH CONTROLS!!!
#endif
        }
        m_imp.Update();
	}
#if UNITY_STANDALONE || UNITY_EDITOR
    Vector2 movement, lookMouse, lookAxis; // yes im not creating new vector every frame
    bool isShoot = false;

	void PCInputStart()
	{
		switch (Crazy_SceneManager.GetInstance().GetScene().GetPlayerControl().UseWeaponType())
		{
			case Crazy_Weapon_Type.Bow: isShoot = true; break;
			case Crazy_Weapon_Type.Staff: isShoot = true; break;
		}
	}

    // DO NOT COMPILE ON NON TOUCHSCREEN, OVERRIDES TOUCH CONTROLS!!!
    void PCInput()
	{
		if (isShoot)
        {
			lookAxis.Set(Input.GetAxisRaw("HorizontalLook"), Input.GetAxisRaw("VerticalLook"));

            // if (Time.timeScale != 0) is a quick fix, didnt bother searching for an actual bool
            if (lookAxis != Vector2.zero)
            {
                if (Time.timeScale != 0) m_imp.OnForward(-lookAxis); // Yes its supposed to be inverted
            }
			else
            {
                lookMouse.Set(Calculate(Input.mousePosition.x, Screen.width),
                    Calculate(Input.mousePosition.y, Screen.height));

                if (Time.timeScale != 0) m_imp.OnForward(-lookMouse); // Yes its supposed to be inverted
            }

            if (Input.GetButtonDown("Attack")) m_imp.OnShotDown();
            else if (Input.GetButtonUp("Attack")) m_imp.OnShotUp();
        }
		else
        {
            if (Input.GetButtonDown("Attack")) m_imp.OnAttackDown();
        }

		// Yes thats the check from UtilUISkillButton.cs
		if (Input.GetButtonDown("Skill")
			&& Crazy_SceneManager.GetInstance().GetScene().GetPlayerControl().GetSkill())
			m_imp.OnSkillDown();

        if (Input.GetButtonDown("Pause")) 
		{
            if (Time.timeScale == 0) m_imp.OnContinueDown();
            else m_imp.OnPauseDown();
        }

        movement.Set(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
		m_imp.OnMove(-movement); // Yes its supposed to be inverted

        if (Input.GetButtonDown("Roll")) m_imp.OnRollDown();
        if (Input.GetButtonDown("Revive")) m_imp.OnReviveDown(); // multiplayer?
    }

	float Calculate(float current, float max)
	{
		return (current / max) * 2f - 1f;
    }
#endif

	public void HandleEvent(TUIControl control, int eventType, float wparam, float lparam, object data)
	{
		if (control.name == "FightButton" && eventType == 3)
		{
			m_imp.OnAttackDown();
		}
		else if (control.name == "SkillButton" && eventType == 3)
		{
			m_imp.OnSkillDown();
		}
		else if (control.name == "PauseButton" && eventType == 3)
		{
			m_imp.OnPauseDown();
		}
		else if (control.name == "MoveButton")
		{
			Vector2 dir = new Vector2(0f - wparam, 0f - lparam);
			m_imp.OnMove(dir);
		}
		else if (control.name == "BackButton" && eventType == 3)
		{
			m_imp.OnBackDown();
		}
		else if (control.name == "ContinueButton" && eventType == 3)
		{
			m_imp.OnContinueDown();
			ResetButton();
		}
		else if (control.name == "RollButton" && eventType == 3)
		{
			m_imp.OnRollDown();
		}
		else if (control.name == "ShotButton")
		{
			switch (eventType)
			{
			case 1:
				m_imp.OnShotDown();
				break;
			case 3:
				m_imp.OnShotUp();
				break;
			}
			Vector2 dir2 = new Vector2(0f - wparam, 0f - lparam);
			m_imp.OnForward(dir2);
		}
		else if (control.name == "ReviveButton" && eventType == 3)
		{
			m_imp.OnReviveDown();
		}
	}

	public void OnGameEnd()
	{
		m_imp.OnComplete();
	}

	public void OnGameFailed()
	{
		m_imp.OnDeath();
	}
}
