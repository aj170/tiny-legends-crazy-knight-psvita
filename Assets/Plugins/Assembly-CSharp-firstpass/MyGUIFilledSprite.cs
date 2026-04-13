using System;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class MyGUIFilledSprite : MonoBehaviour
{
	public enum FillDirection
	{
		Horizontal = 0,
		Vertical = 1,
		Radial90 = 2,
		Radial180 = 3,
		Radial360 = 4
	}

	public bool Static = true;

	public Material material;

	public string frameName;

	public Color color = Color.white;

	public bool flipX;

	public bool flipY;

	protected Material materialClone;

	protected MeshFilter meshFilter;

	protected MeshRenderer meshRender;

	private List<Color> cols = new List<Color>();

	private List<Vector2> uvs = new List<Vector2>();

	private List<Vector3> verts = new List<Vector3>();

	private int[] mIndices;

	public FillDirection mFillDirection = FillDirection.Radial360;

	public float mFillAmount;

	public bool mInvert;

	public float mCDTime = 2f;

	public float mDelta;

	public FillDirection fillDirection
	{
		get
		{
			return mFillDirection;
		}
		set
		{
			if (mFillDirection != value)
			{
				mFillDirection = value;
			}
		}
	}

	public float fillAmount
	{
		get
		{
			return mFillAmount;
		}
		set
		{
			float num = Mathf.Clamp01(value);
			if (mFillAmount != num)
			{
				mFillAmount = num;
			}
		}
	}

	public bool invert
	{
		get
		{
			return mInvert;
		}
		set
		{
			if (mInvert != value)
			{
				mInvert = value;
			}
		}
	}

	private bool AdjustRadial(Vector2[] xy, Vector2[] uv, float fill, bool invert)
	{
		if (fill < 0.001f)
		{
			return false;
		}
		if (!invert && fill > 0.999f)
		{
			return true;
		}
		float num = Mathf.Clamp01(fill);
		if (!invert)
		{
			num = 1f - num;
		}
		num *= (float)Math.PI / 2f;
		float num2 = Mathf.Sin(num);
		float num3 = Mathf.Cos(num);
		if (num2 > num3)
		{
			num3 *= 1f / num2;
			num2 = 1f;
			if (!invert)
			{
				xy[0].y = Mathf.Lerp(xy[2].y, xy[0].y, num3);
				xy[3].y = xy[0].y;
				uv[0].y = Mathf.Lerp(uv[2].y, uv[0].y, num3);
				uv[3].y = uv[0].y;
			}
		}
		else if (num3 > num2)
		{
			num2 *= 1f / num3;
			num3 = 1f;
			if (invert)
			{
				xy[0].x = Mathf.Lerp(xy[2].x, xy[0].x, num2);
				xy[1].x = xy[0].x;
				uv[0].x = Mathf.Lerp(uv[2].x, uv[0].x, num2);
				uv[1].x = uv[0].x;
			}
		}
		else
		{
			num2 = 1f;
			num3 = 1f;
		}
		if (invert)
		{
			xy[1].y = Mathf.Lerp(xy[2].y, xy[0].y, num3);
			uv[1].y = Mathf.Lerp(uv[2].y, uv[0].y, num3);
		}
		else
		{
			xy[3].x = Mathf.Lerp(xy[2].x, xy[0].x, num2);
			uv[3].x = Mathf.Lerp(uv[2].x, uv[0].x, num2);
		}
		return true;
	}

	private void Rotate(Vector2[] v, int offset)
	{
		for (int i = 0; i < offset; i++)
		{
			Vector2 vector = new Vector2(v[3].x, v[3].y);
			v[3].x = v[2].y;
			v[3].y = v[2].x;
			v[2].x = v[1].y;
			v[2].y = v[1].x;
			v[1].x = v[0].y;
			v[1].y = v[0].x;
			v[0].x = vector.y;
			v[0].y = vector.x;
		}
	}

	private void Awake()
	{
		if ((bool)material)
		{
			materialClone = UnityEngine.Object.Instantiate(material) as Material;
			materialClone.hideFlags = HideFlags.DontSave;
		}
		else
		{
			materialClone = null;
		}
		meshFilter = base.gameObject.GetComponent<MeshFilter>();
		meshRender = base.gameObject.GetComponent<MeshRenderer>();
		meshFilter.sharedMesh = new Mesh();
		meshFilter.sharedMesh.hideFlags = HideFlags.DontSave;
		meshRender.castShadows = false;
		meshRender.receiveShadows = false;
	}

	public void Start()
	{
		UpdateMesh();
	}

	private void OnDestroy()
	{
		if ((bool)meshFilter && (bool)meshFilter.sharedMesh)
		{
			UnityEngine.Object.DestroyImmediate(meshFilter.sharedMesh);
		}
		if ((bool)materialClone)
		{
			UnityEngine.Object.DestroyImmediate(materialClone);
		}
	}

	public void Update()
	{
		if (!Static)
		{
			mDelta += Time.deltaTime;
			if (mDelta > mCDTime)
			{
				mDelta = 0f;
				Static = true;
				fillAmount = 0f;
				UpdateMesh();
			}
			else
			{
				fillAmount = 1f - mDelta / mCDTime;
				UpdateMesh();
			}
		}
	}

	private void UpdateMesh()
	{
		if (meshFilter == null || meshRender == null)
		{
			return;
		}
		TUITextureManager.Frame frame = TUITextureManager.Instance().GetFrame(frameName);
		if ((bool)materialClone)
		{
			materialClone.mainTexture = frame.texture;
			meshRender.sharedMaterial = materialClone;
		}
		else if ((bool)frame.material)
		{
			meshRender.sharedMaterial = frame.material;
		}
		Vector4 uv = frame.uv;
		if (flipX)
		{
			float x = uv.x;
			uv.x = uv.z;
			uv.z = x;
		}
		if (flipY)
		{
			float y = uv.y;
			uv.y = uv.w;
			uv.w = y;
		}
		Vector3 vector = new Vector3(base.transform.position.x - (float)(int)base.transform.position.x, base.transform.position.y - (float)(int)base.transform.position.y, 0f);
		Vector3 vector2 = new Vector3(frame.size.x % 2f / 2f, frame.size.y % 2f / 2f, 0f);
		Vector3 vector3 = vector + vector2;
		float x2 = frame.size.x * -0.5f - vector3.x;
		float y2 = frame.size.y * 0.5f - vector3.y;
		float z = frame.size.x * 0.5f - vector3.x;
		float w = frame.size.y * -0.5f - vector3.y;
		Vector4 pos = new Vector4(x2, y2, z, w);
		cols.Clear();
		uvs.Clear();
		verts.Clear();
		OnFill(pos, uv, verts, uvs, cols);
		int count = verts.Count;
		if (count > 0 && count == uvs.Count && count == cols.Count && count % 4 == 0)
		{
			int num = (count >> 1) * 3;
			mIndices = new int[num];
			int num2 = 0;
			for (int i = 0; i < count; i += 4)
			{
				mIndices[num2++] = i;
				mIndices[num2++] = i + 1;
				mIndices[num2++] = i + 2;
				mIndices[num2++] = i + 2;
				mIndices[num2++] = i + 3;
				mIndices[num2++] = i;
			}
			meshFilter.sharedMesh.Clear();
			meshFilter.sharedMesh.vertices = verts.ToArray();
			meshFilter.sharedMesh.uv = uvs.ToArray();
			meshFilter.sharedMesh.colors = cols.ToArray();
			meshFilter.sharedMesh.triangles = mIndices;
		}
		else if (meshFilter.sharedMesh != null)
		{
			meshFilter.sharedMesh.Clear();
		}
	}

	private void OnFill(Vector4 pos, Vector4 tex, List<Vector3> verts, List<Vector2> uvs, List<Color> cols)
	{
		float x = pos.x;
		float y = pos.y;
		float num = pos.z;
		float num2 = pos.w;
		float num3 = tex.x;
		float num4 = tex.y;
		float num5 = tex.z;
		float num6 = tex.w;
		if (mFillDirection == FillDirection.Horizontal || mFillDirection == FillDirection.Vertical)
		{
			float num7 = (num5 - num3) * mFillAmount;
			float num8 = (num6 - num4) * mFillAmount;
			if (fillDirection == FillDirection.Horizontal)
			{
				if (mInvert)
				{
					x = 1f - mFillAmount;
					num3 = num5 - num7;
				}
				else
				{
					num *= mFillAmount;
					num5 = num3 + num7;
				}
			}
			else if (fillDirection == FillDirection.Vertical)
			{
				if (mInvert)
				{
					num2 *= mFillAmount;
					num4 = num6 - num8;
				}
				else
				{
					y = 0f - (1f - mFillAmount);
					num6 = num4 + num8;
				}
			}
		}
		Vector2[] array = new Vector2[4];
		Vector2[] array2 = new Vector2[4];
		array[0] = new Vector2(num, y);
		array[1] = new Vector2(num, num2);
		array[2] = new Vector2(x, num2);
		array[3] = new Vector2(x, y);
		array2[0] = new Vector2(num5, num6);
		array2[1] = new Vector2(num5, num4);
		array2[2] = new Vector2(num3, num4);
		array2[3] = new Vector2(num3, num6);
		if (fillDirection == FillDirection.Radial90)
		{
			if (!AdjustRadial(array, array2, mFillAmount, mInvert))
			{
				return;
			}
		}
		else
		{
			if (fillDirection == FillDirection.Radial180)
			{
				Vector2[] array3 = new Vector2[4];
				Vector2[] array4 = new Vector2[4];
				for (int i = 0; i < 2; i++)
				{
					array3[0] = new Vector2(0f, 0f);
					array3[1] = new Vector2(0f, 1f);
					array3[2] = new Vector2(1f, 1f);
					array3[3] = new Vector2(1f, 0f);
					array4[0] = new Vector2(0f, 0f);
					array4[1] = new Vector2(0f, 1f);
					array4[2] = new Vector2(1f, 1f);
					array4[3] = new Vector2(1f, 0f);
					if (mInvert)
					{
						if (i > 0)
						{
							Rotate(array3, i);
							Rotate(array4, i);
						}
					}
					else if (i < 1)
					{
						Rotate(array3, 1 - i);
						Rotate(array4, 1 - i);
					}
					float from;
					float to;
					if (i == 1)
					{
						from = ((!mInvert) ? 1f : 0.5f);
						to = ((!mInvert) ? 0.5f : 1f);
					}
					else
					{
						from = ((!mInvert) ? 0.5f : 1f);
						to = ((!mInvert) ? 1f : 0.5f);
					}
					array3[1].y = Mathf.Lerp(from, to, array3[1].y);
					array3[2].y = Mathf.Lerp(from, to, array3[2].y);
					array4[1].y = Mathf.Lerp(from, to, array4[1].y);
					array4[2].y = Mathf.Lerp(from, to, array4[2].y);
					float fill = mFillAmount * 2f - (float)i;
					bool flag = i % 2 == 1;
					if (!AdjustRadial(array3, array4, fill, !flag))
					{
						continue;
					}
					if (mInvert)
					{
						flag = !flag;
					}
					if (flag)
					{
						for (int j = 0; j < 4; j++)
						{
							from = Mathf.Lerp(array[0].x, array[2].x, array3[j].x);
							to = Mathf.Lerp(array[0].y, array[2].y, array3[j].y);
							float x2 = Mathf.Lerp(array2[0].x, array2[2].x, array4[j].x);
							float y2 = Mathf.Lerp(array2[0].y, array2[2].y, array4[j].y);
							verts.Add(new Vector3(from, to, 0f));
							uvs.Add(new Vector2(x2, y2));
							cols.Add(color);
						}
						continue;
					}
					for (int num9 = 3; num9 > -1; num9--)
					{
						from = Mathf.Lerp(array[0].x, array[2].x, array3[num9].x);
						to = Mathf.Lerp(array[0].y, array[2].y, array3[num9].y);
						float x3 = Mathf.Lerp(array2[0].x, array2[2].x, array4[num9].x);
						float y3 = Mathf.Lerp(array2[0].y, array2[2].y, array4[num9].y);
						verts.Add(new Vector3(from, to, 0f));
						uvs.Add(new Vector2(x3, y3));
						cols.Add(color);
					}
				}
				return;
			}
			if (fillDirection == FillDirection.Radial360)
			{
				float[] array5 = new float[16]
				{
					0.5f, 1f, 0f, 0.5f, 0.5f, 1f, 0.5f, 1f, 0f, 0.5f,
					0.5f, 1f, 0f, 0.5f, 0f, 0.5f
				};
				Vector2[] array6 = new Vector2[4];
				Vector2[] array7 = new Vector2[4];
				for (int k = 0; k < 4; k++)
				{
					array6[0] = new Vector2(0f, 0f);
					array6[1] = new Vector2(0f, 1f);
					array6[2] = new Vector2(1f, 1f);
					array6[3] = new Vector2(1f, 0f);
					array7[0] = new Vector2(0f, 0f);
					array7[1] = new Vector2(0f, 1f);
					array7[2] = new Vector2(1f, 1f);
					array7[3] = new Vector2(1f, 0f);
					if (mInvert)
					{
						if (k > 0)
						{
							Rotate(array6, k);
							Rotate(array7, k);
						}
					}
					else if (k < 3)
					{
						Rotate(array6, 3 - k);
						Rotate(array7, 3 - k);
					}
					for (int l = 0; l < 4; l++)
					{
						int num10 = ((!mInvert) ? (k * 4) : ((3 - k) * 4));
						float from2 = array5[num10];
						float to2 = array5[num10 + 1];
						float from3 = array5[num10 + 2];
						float to3 = array5[num10 + 3];
						array6[l].x = Mathf.Lerp(from2, to2, array6[l].x);
						array6[l].y = Mathf.Lerp(from3, to3, array6[l].y);
						array7[l].x = Mathf.Lerp(from2, to2, array7[l].x);
						array7[l].y = Mathf.Lerp(from3, to3, array7[l].y);
					}
					float fill2 = mFillAmount * 4f - (float)k;
					bool flag2 = k % 2 == 1;
					if (!AdjustRadial(array6, array7, fill2, !flag2))
					{
						continue;
					}
					if (mInvert)
					{
						flag2 = !flag2;
					}
					if (flag2)
					{
						for (int m = 0; m < 4; m++)
						{
							float x4 = Mathf.Lerp(array[0].x, array[2].x, array6[m].x);
							float y4 = Mathf.Lerp(array[0].y, array[2].y, array6[m].y);
							float x5 = Mathf.Lerp(array2[0].x, array2[2].x, array7[m].x);
							float y5 = Mathf.Lerp(array2[0].y, array2[2].y, array7[m].y);
							verts.Add(new Vector3(x4, y4, 0f));
							uvs.Add(new Vector2(x5, y5));
							cols.Add(color);
						}
						continue;
					}
					for (int num11 = 3; num11 > -1; num11--)
					{
						float x6 = Mathf.Lerp(array[0].x, array[2].x, array6[num11].x);
						float y6 = Mathf.Lerp(array[0].y, array[2].y, array6[num11].y);
						float x7 = Mathf.Lerp(array2[0].x, array2[2].x, array7[num11].x);
						float y7 = Mathf.Lerp(array2[0].y, array2[2].y, array7[num11].y);
						verts.Add(new Vector3(x6, y6, 0f));
						uvs.Add(new Vector2(x7, y7));
						cols.Add(color);
					}
				}
				return;
			}
		}
		for (int n = 0; n < 4; n++)
		{
			verts.Add(array[n]);
			uvs.Add(array2[n]);
			cols.Add(color);
		}
	}
}
