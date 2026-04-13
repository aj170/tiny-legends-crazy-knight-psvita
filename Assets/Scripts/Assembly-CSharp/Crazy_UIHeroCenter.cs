using System;
using System.Collections.Generic;
using UnityEngine;

public class Crazy_UIHeroCenter : MonoBehaviour
{
    public List<GameObject> nodelist;

    public float radius;

    public Vector3 forward;

    protected float angle;

    private bool move;

    private float currentmoveangle;

    private float moveangle;

    public int innercount;

    protected int dividcount;

    public GameObject playercontrol;

    private void Awake()
    {
        Crazy_Data.CurData().SetUnlock(Crazy_PlayerClass.Paladin, true);
    }

    private void Start()
    {
        dividcount = nodelist.Count;
        angle = (float)Math.PI * 2f / (float)dividcount;
        Vector2 vector = new Vector2(base.gameObject.transform.localPosition.x, base.gameObject.transform.localPosition.z);
        Vector2 vector2 = new Vector2(forward.x, forward.z);
        for (int i = 0; i < dividcount; i++)
        {
            Vector2 vector3 = Crazy_Global.RotatebyAngle(vector, vector2, angle * (float)i * 57.29578f, radius) - vector;
            nodelist[i].transform.localPosition = new Vector3(vector3.x, 0f, vector3.y);
        }
        for (int j = 0; j < nodelist.Count; j++)
        {
            Crazy_UIHeroManager componentInChildren = nodelist[j].transform.GetComponentInChildren<Crazy_UIHeroManager>();
            if (componentInChildren.cpc == Crazy_Data.CurData().GetPlayerClass())
            {
                innercount = j;
            }
        }
        MoveDirectly(angle * (float)innercount);
        MoveEnd();
    }

    private void MoveDirectly(float moveangle)
    {
        base.transform.RotateAroundLocal(Vector3.up, moveangle);
        foreach (GameObject item in nodelist)
        {
            item.transform.forward = forward;
        }
    }

    private void updateState()
    {
        nodelist[innercount].transform.GetComponentInChildren<Crazy_UIHeroManager>().UpdateHero();
    }

    private void UpdateAngle()
    {
        float num = 0f;
        if (Mathf.Abs(currentmoveangle - moveangle) < (float)Math.PI / 18f)
        {
            num = moveangle - currentmoveangle;
            move = false;
            MoveEnd();
        }
        else
        {
            num = Mathf.Lerp(currentmoveangle, moveangle, 0.5f) - currentmoveangle;
        }
        base.transform.RotateAroundLocal(Vector3.up, num);
        currentmoveangle += num;
        foreach (GameObject item in nodelist)
        {
            item.transform.forward = forward;
        }
    }

    private void MoveEnd()
    {
        playercontrol.SendMessage("updateState", nodelist[innercount].transform.GetComponentInChildren<Crazy_UIHeroManager>().cpc);
    }

    public void ToNext()
    {
        if (!move)
        {
            move = true;
            moveangle = angle;
            currentmoveangle = 0f;
            playercontrol.SendMessage("HideAll", SendMessageOptions.DontRequireReceiver);
            innercount = ++innercount % dividcount;
        }
    }

    public void ToLast()
    {
        if (!move)
        {
            move = true;
            moveangle = 0f - angle;
            currentmoveangle = 0f;
            playercontrol.SendMessage("HideAll", SendMessageOptions.DontRequireReceiver);
            innercount = (--innercount + dividcount) % dividcount;
        }
    }

    private void Update()
    {
        if (move)
        {
            UpdateAngle();
        }
    }
}
