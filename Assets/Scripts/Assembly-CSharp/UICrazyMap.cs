using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UICrazyMap : MonoBehaviour, TUIHandler
{
    private TUI m_tui;

    private int CurrectStage = -1;

    private Crazy_MapStage Stage;

    public UtilUIFightBoard fightboard;

    public GameObject optionboard;

    public GameObject reviewboard;

    protected GameObject fixAnimation;

    protected TUIButtonSelect selectcontrol;

    public GameObject availablehint;

    public Vector2[] mapposition;

    public GameObject storyprocess;

    public GameObject weaponbutton;

    public GameObject herobutton;

    public GameObject chatbutton;

    public GameObject netbutton;

    public GameObject land;

    protected Queue<StoryDo> storyseq = new Queue<StoryDo>();

    public GameObject m_propsPanel;

    public GameObject m_showHero;

    public GameObject m_fightBtn;

    private bool m_bBetBattle;

    public DailyReward dailyAward;

    public MageSellPanel mageSellPanel;

    public void Awake()
    {
        Hashtable hashtable = new Hashtable();
        hashtable.Add("Level", Crazy_Data.CurData().GetLevel());
        FlurryPlugin.logEvent("Enter_Map", hashtable);
        Time.timeScale = 1f;
        Crazy_Global.DoProcessAction();
        Crazy_GlobalData.cur_UI2Times++;
        Crazy_GlobalData.cur_ui = 2;
        MyGUIEventListener.Get(m_fightBtn).EventHandleOnClicked += OnFight;
        if (Crazy_Data.CurData().GetMageSellTime() == string.Empty && !Crazy_Data.CurData().GetUnlock(Crazy_PlayerClass.Mage) && Crazy_GlobalData.cur_fight_num == 2 && Crazy_Data.CurData().GetLevel() >= 5)
        {
            Crazy_Data.CurData().SetHeroIconDirectly(true);
            mageSellPanel.gameObject.SetActiveRecursively(true);
            mageSellPanel.SetShowTime();
        }
        if (Crazy_GlobalData.m_bShowDailyReward)
        {
            dailyAward.ShowDailyAward();
        }
    }

    public void ShowGoDelegate()
    {
        Invoke("ShowGo", 0.5f);
    }

    public void ShowViewDelegate()
    {
        Invoke("ShowView", 0.5f);
    }

    public void ShowGo()
    {
        if (storyprocess != null)
        {
            GameObject gameObject = storyprocess.transform.Find("GoButton").gameObject;
            gameObject.transform.localPosition = new Vector3(160f, -25f, gameObject.transform.localPosition.z);
        }
    }

    public void HideGo()
    {
        if (storyprocess != null)
        {
            GameObject gameObject = storyprocess.transform.Find("GoButton").gameObject;
            gameObject.transform.localPosition = new Vector3(1000f, 1000f, gameObject.transform.localPosition.z);
        }
    }

    public void ShowView()
    {
        if (storyprocess != null)
        {
            GameObject gameObject = storyprocess.transform.Find("ViewButton").gameObject;
            gameObject.transform.localPosition = new Vector3(160f, -25f, gameObject.transform.localPosition.z);
        }
    }

    public void HideView()
    {
        if (storyprocess != null)
        {
            GameObject gameObject = storyprocess.transform.Find("ViewButton").gameObject;
            gameObject.transform.localPosition = new Vector3(1000f, 1000f, gameObject.transform.localPosition.z);
        }
    }

    public void OnShowMapStory()
    {
        Crazy_Data.CurData().SetMapStory(true);
        Crazy_Data.SaveData();
    }

    private void OnHide(GameObject go)
    {
        m_showHero.SetActiveRecursively(false);
        m_propsPanel.SetActiveRecursively(false);
    }

    private void OnFight(GameObject go)
    {
        OnHide(go);
        if (m_bBetBattle)
        {
            OnNet();
            return;
        }
        OnGame(CurrectStage, Stage);
        if (Crazy_Beginner.instance.isMap)
        {
            OffHandHint();
            Crazy_Beginner.instance.isMap = false;
        }
    }

    public void Start()
    {
        m_tui = TUI.Instance("TUI");
        m_tui.SetHandler(this);
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeIn();
        Crazy_Global.PlayBGM("BGM_Menu01");
        fixAnimation = m_tui.transform.Find("TUIControl/FixAnimation").gameObject;
        if (CommunicationVersion.Instance.Comm)
        {
            if (!Crazy_Data.CurData().GetRecommendPresent() && Crazy_Global.IsCommunicationSuccess)
            {
                storyseq.Enqueue(new StoryDo(101, null, ShowViewDelegate, HideView));
                Crazy_Global.SetRecommendPresent();
            }
            else if (!Crazy_Data.CurData().GetRecommendPresent() && !Crazy_Global.IsCommunicationSuccess && Crazy_Global.IsFirstCommunication)
            {
                Crazy_Global.IsFirstCommunication = false;
                storyseq.Enqueue(new StoryDo(100, null, ShowGoDelegate, HideGo));
            }
        }
        if (Crazy_Data.CurData().GetNetName() == string.Empty)
        {
            EnterName();
        }
        Crazy_GlobalData.m_curlevel = Crazy_Data.CurData().GetLevel();
        if (Crazy_GlobalData.m_prelevel < Crazy_GlobalData.m_curlevel)
        {
            List<Crazy_Weapon> list = Crazy_Weapon.ReadWeaponInfo();
            foreach (Crazy_Weapon item in list)
            {
                if (item.need > Crazy_GlobalData.m_prelevel && item.need <= Crazy_GlobalData.m_curlevel && item.isshow)
                {
                    Crazy_GlobalData.unlock_weaponid.Add(item.id);
                    if (Crazy_GlobalData.maphinticon == null)
                    {
                        Crazy_GlobalData.maphinticon = item.iconname;
                        Crazy_GlobalData.mapiconpos = 1;
                    }
                }
            }
        }
        Crazy_GlobalData.m_prelevel = Crazy_GlobalData.m_curlevel;
        if (Crazy_GlobalData.maphinticon != null)
        {
            if (!Crazy_Data.CurData().GetWeaponIcon() && Crazy_GlobalData.mapiconpos == 1)
            {
                Crazy_GlobalData.maphinticon = null;
                Crazy_GlobalData.mapiconpos = -1;
                Crazy_GlobalData.unlock_weaponid.Clear();
            }
            else if (Crazy_Data.CurData().GetHeroIcon() || Crazy_GlobalData.mapiconpos != 0)
            {
                availablehint.transform.localPosition = new Vector3(mapposition[Crazy_GlobalData.mapiconpos].x, mapposition[Crazy_GlobalData.mapiconpos].y, availablehint.transform.localPosition.z);
                availablehint.transform.Find("Available").GetComponent<TUIMeshSprite>().frameName = Crazy_GlobalData.maphinticon;
                Crazy_GlobalData.maphinticon = null;
                Crazy_GlobalData.mapiconpos = -1;
            }
        }
        Crazy_Process activeProcess = Crazy_Global.GetActiveProcess();
        if (activeProcess != null && activeProcess.mapstory != -1 && !Crazy_Data.CurData().GetMapStory())
        {
            storyseq.Enqueue(new StoryDo(activeProcess.mapstory, null, OnShowMapStory, null));
        }
        if (!Crazy_Data.CurData().GetWeaponIcon())
        {
            //weaponbutton.transform.localPosition = new Vector3(1000f, 1000f, 0f);
        }
        if (!Crazy_Data.CurData().GetHeroIcon())
        {
            //herobutton.transform.localPosition = new Vector3(1000f, 1000f, 0f);
        }
        if (!Crazy_Data.CurData().GetNet())
        {
            netbutton.transform.localPosition = new Vector3(-105f, -14f, 0f);
            chatbutton.transform.localPosition = new Vector3(9.9f, 127.8f, 0f);
        }
        if (Crazy_Data.CurData().GetPlayTimes() == 3 && !Crazy_GlobalData.isreview)
        {
            Crazy_GlobalData.isreview = true;
            reviewboard.transform.localPosition = new Vector3(0f, 0f, reviewboard.transform.localPosition.z);
        }
        PlayStorySeq();
        if (Crazy_Beginner.instance.isCoop && Crazy_Data.CurData().GetNet())
        {
            GameObject gameObject = GameObject.Find("TUI/TUIControl/CoopHint");
            gameObject.transform.localPosition = new Vector3(-30f, 30f, gameObject.transform.localPosition.z);
        }
        Crazy_Data.CurData().TenCrystalPresent();
    }

    public void PlayStorySeq()
    {
        UtilUIStoryProcessControl component = storyprocess.GetComponent<UtilUIStoryProcessControl>();
        if (storyseq.Count != 0)
        {
            StoryDo storyDo = storyseq.Dequeue();
            component.ShowStory(storyDo.storyid, storyDo.replace, storyDo.sbd, storyDo.sed);
        }
    }

    public void Update()
    {
        TUIInput[] input = TUIInputManager.GetInput();
        for (int i = 0; i < input.Length; i++)
        {
            m_tui.HandleInput(input[i]);
        }
    }

    public void HandleEvent(TUIControl control, int eventType, float wparam, float lparam, object data)
    {
        if (control.name == "StageButton" && eventType == 1)
        {
            CurrectStage = int.Parse(control.transform.parent.parent.name.Replace("Stage", string.Empty));
            Stage = control.transform.parent.parent.gameObject.GetComponent("Crazy_MapStage") as Crazy_MapStage;
            Crazy_Modify modify = Crazy_LevelModify.GetModify(Stage.leveltype, Mathf.Max(Crazy_Data.CurData().GetLevel() + Stage.deltalevel, 1));
            UpdateFightBoard(Stage.leveltype, modify, Stage.icons);
            fixAnimation.transform.position = new Vector3(control.transform.position.x, control.transform.position.y, fixAnimation.transform.position.z);
            selectcontrol = (TUIButtonSelect)control;
            TUIMeshText component = control.transform.parent.Find("StageText/Text").GetComponent<TUIMeshText>();
            component.fontName = "MAPFONT";
            component.UpdateMesh();
            if (Crazy_Beginner.instance.isMap)
            {
                OnBeginner();
            }
            Crazy_Process activeProcess = Crazy_Global.GetActiveProcess();
            if (activeProcess != null && activeProcess.stagestory != -1)
            {
                UtilUIStoryProcessControl component2 = storyprocess.GetComponent<UtilUIStoryProcessControl>();
                component2.ShowStory(activeProcess.stagestory);
            }
        }
        else if (control.name == "WeaponButton" && eventType == 3)
        {
            OnWeapon();
        }
        else if (control.name == "HeroButton" && eventType == 3)
        {
            OnHero();
        }
        else if (control.name == "TaskButton" && eventType == 3)
        {
            OnTask();
        }
        else if (control.name == "ChatButton" && eventType == 3)
        {
            OnChat();
        }
        else if (control.name == "NetButton" && eventType == 3)
        {
            m_bBetBattle = true;
            m_propsPanel.SetActiveRecursively(true);
            m_showHero.SetActiveRecursively(true);
        }
        else if (control.name == "OptionsButton" && eventType == 3)
        {
            OnOptions();
        }
        else if (control.name == "FightButton" && eventType == 3)
        {
            if (Crazy_Data.CurData().IsShowPropPanel())
            {
                fightboard.Hide();
                m_propsPanel.SetActiveRecursively(true);
                m_showHero.SetActiveRecursively(true);
                control.transform.GetComponent<TAudioController>().PlayAudio("UI_Button_General");
                return;
            }
            OnGame(CurrectStage, Stage);
            if (Crazy_Beginner.instance.isMap)
            {
                OffHandHint();
                Crazy_Beginner.instance.isMap = false;
            }
            control.transform.GetComponent<TAudioController>().PlayAudio("UI_Button_Start");
        }
        else if (control.name == "CancelButton" && eventType == 3)
        {
            OffOptions();
        }
        else if (control.name == "YesButton" && eventType == 3)
        {
            ResetData();
        }
        else if (control.name == "AchievementButton" && eventType == 3)
        {
            OnAchievement();
        }
        else if (control.name == "LeaderboardButton" && eventType == 3)
        {
            OnLeaderboard();
        }
        else if (control.name == "FightBackButton" && eventType == 3)
        {
            HideFightBoard();
        }
        else if (control.name == "ReviewYesButton" && eventType == 3)
        {
            Crazy_Global.OpenReviewURL();
            HideReviewBoard();
        }
        else if (control.name == "ReviewNoButton" && eventType == 3)
        {
            HideReviewBoard();
        }
        else if (control.name == "NameButton" && eventType == 3)
        {
            EnterName();
        }
        else if (control.name == "CheatButton" && eventType == 3)
        {
            if (Crazy_Data.CurData().GetLevel() < 30)
            {
                Crazy_Data.CurData().SetLevel(Crazy_Data.CurData().GetLevel() + 1);
            }
            Crazy_Data.CurData().SetRanged(true);
            Crazy_Data.CurData().SetHeroIcon(true);
            Crazy_Data.CurData().SetNet(true);
            Crazy_Data.CurData().SetWeaponIcon(true);
            Crazy_Data.CurData().SetMoney(Crazy_Data.CurData().GetMoney() + 100000);
            Crazy_Data.CurData().SetCrystal(Crazy_Data.CurData().GetCrystal() + 10000);
        }
        else if (control.name == "StoryButton" && eventType == 3)
        {
            PlayStorySeq();
        }
        else if (control.name == "GoButton" && eventType == 3)
        {
            Crazy_Global.OnRecommend();
        }
        else if (control.name == "ViewButton" && eventType == 3)
        {
            OnHero();
        }
    }

    public void OnLeaderboard()
    {
        if (GameCenterPlugin.IsSupported() && GameCenterPlugin.IsLogin())
        {
            GameCenterPlugin.OpenLeaderboard();
        }
    }

    public void OnAchievement()
    {
        if (GameCenterPlugin.IsSupported() && GameCenterPlugin.IsLogin())
        {
            GameCenterPlugin.OpenAchievement();
        }
    }

    public void ResetData()
    {
        Crazy_Data.ResetData();
        Crazy_Beginner.instance.Reset();
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyStart");
    }

    public void OffOptions()
    {
        optionboard.transform.localPosition = new Vector3(1000f, 5000f, optionboard.transform.localPosition.z);
    }

    public void OnOptions()
    {
        optionboard.transform.localPosition = new Vector3(0f, 0f, optionboard.transform.localPosition.z);
    }

    public void OnWeapon()
    {
        Crazy_GlobalData.next_scene = "CrazyUI";
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyUILoading");
        Resources.UnloadUnusedAssets();
    }

    public void OnHero()
    {
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyHero");
        Resources.UnloadUnusedAssets();
    }

    public void OnChat()
    {
        Crazy_Global.ShowChatRoom(Crazy_Data.CurData().GetNetName());
    }

    public void OnNet()
    {
        if (Crazy_Beginner.instance.isCoop)
        {
            GameObject gameObject = GameObject.Find("TUI/TUIControl/CoopHint");
            Animation[] componentsInChildren = gameObject.GetComponentsInChildren<Animation>();
            Animation[] array = componentsInChildren;
            foreach (Animation animation in array)
            {
                animation.GetComponent<Animation>()["MeshFadeOut"].wrapMode = WrapMode.ClampForever;
                animation.Play("MeshFadeOut");
            }
            Crazy_Beginner.instance.isCoop = false;
        }
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyNetBattle");
        Resources.UnloadUnusedAssets();
    }

    public void OnTask()
    {
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyAchievement");
        Resources.UnloadUnusedAssets();
    }

    public void OnGame(int i, Crazy_MapStage s)
    {
        fightboard.Hide();
        Crazy_GlobalData.cur_leveltype = s.leveltype;
        Crazy_GlobalData.cur_stage = i;
        Crazy_GlobalData.cur_level = Mathf.Max(Crazy_Data.CurData().GetLevel() + s.deltalevel, 1);
        Crazy_GlobalData.cur_scene_id = Crazy_Land.GetLandinfo(i).scene[Random.Range(0, Crazy_Land.GetLandinfo(i).scene.Count)];
        Crazy_GlobalData.cur_land_id = s.landid;
        Crazy_GlobalData.next_scene = "CrazyScene" + Crazy_GlobalData.cur_scene_id.ToString("D02");
        Crazy_GlobalData.cur_wave = s.waveid;
        Crazy_GlobalData.cur_kill_number = 0;
        Crazy_GlobalData.cur_player_time = 0f;
        Crazy_GlobalData.cur_game_state = Crazy_GameState.PreGame;
        Crazy_GlobalData.cur_process = Crazy_Global.GetActiveProcess();
        selectcontrol.SetDisabled(true);
        fixAnimation.GetComponent<Animation>().Play("Fix");
        m_tui.transform.Find("TUIControl").Find("Block").gameObject.active = true;
        Crazy_ParticleSequenceScript crazy_ParticleSequenceScript = fixAnimation.transform.Find("FixEffect").GetComponent("Crazy_ParticleSequenceScript") as Crazy_ParticleSequenceScript;
        crazy_ParticleSequenceScript.EmitParticle();
        Invoke("OnLoading", 0.5f);
    }

    public void EnterName()
    {
        UtilUIEnterName.OpenKeyBoard(Crazy_Data.CurData().GetNetName());
    }

    protected void OnLoading()
    {
        m_tui.transform.Find("TUIControl").Find("Fade").GetComponent<TUIFade>()
            .FadeOut("CrazyLoading");
        Resources.UnloadUnusedAssets();
    }

    protected void UpdateFightBoard(Crazy_LevelType type, Crazy_Modify mod, List<string> icon)
    {
        if (Crazy_Beginner.instance.isMap)
        {
            OnHandHint();
        }
        switch (type)
        {
            case Crazy_LevelType.Normal1:
            case Crazy_LevelType.Boss:
                fightboard.SetMissionTitle("Kill All Monsters");
                fightboard.RemoveTimeIcon();
                break;
            case Crazy_LevelType.Normal2:
                fightboard.SetMissionTitle("Kill All Monsters");
                fightboard.SetTimeIcon(Crazy_Global.SecondToMinuteSecond(mod.time));
                break;
            case Crazy_LevelType.Normal3:
                fightboard.SetMissionTitle("Survival");
                fightboard.SetTimeIcon(Crazy_Global.SecondToMinuteSecond(mod.time));
                break;
        }
        fightboard.SeqIcon(icon);
        fightboard.Show();
    }

    protected void HideFightBoard()
    {
        OffHandHint();
        fightboard.Hide();
        land.SendMessage("ResetAllStage", SendMessageOptions.DontRequireReceiver);
    }

    protected void HideReviewBoard()
    {
        reviewboard.transform.localPosition = new Vector3(1000f, 1000f, reviewboard.transform.localPosition.z);
    }

    protected void OnBeginner()
    {
        GameObject gameObject = GameObject.Find("TUI/TUIControl/MapHint");
        Animation[] componentsInChildren = gameObject.GetComponentsInChildren<Animation>();
        Animation[] array = componentsInChildren;
        foreach (Animation animation in array)
        {
            animation.GetComponent<Animation>()["MeshFadeOut"].wrapMode = WrapMode.ClampForever;
            animation.Play("MeshFadeOut");
        }
    }

    protected void OnHandHint()
    {
        GameObject gameObject = GameObject.Find("TUI/TUIControl/HandHint");
        gameObject.transform.localPosition = new Vector3(140f, -90f, gameObject.transform.localPosition.z);
    }

    protected void OffHandHint()
    {
        GameObject gameObject = GameObject.Find("TUI/TUIControl/HandHint");
        gameObject.transform.localPosition = new Vector3(1000f, 1000f, gameObject.transform.localPosition.z);
    }

    private IEnumerator OnApplicationPause(bool pause)
    {
        if (!pause)
        {
            yield return new WaitForSeconds(1f);
            if (Crazy_GlobalData.m_bShowDailyReward)
            {
                dailyAward.ShowDailyAward();
            }
        }
    }
}
