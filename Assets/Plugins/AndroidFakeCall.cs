using System;
using UnityEngine;

#if !UNITY_ANDROID || UNITY_EDITOR
public class AndroidJavaObject : IDisposable
{
    readonly string name;

    public AndroidJavaObject(string str, params object[] args)
    {
        name = str;
    }

    public void Call(string str, params object[] args)
    {
        Debug.Log("Call from: \"" + name + "\" to: " + str);
    }

    public T Call<T>(string str, params object[] args)
    {
        Debug.Log("RETURNING Call from: \"" + name + "\" to: " + str);

        return default(T);
    }

    public void CallStatic(string str, params object[] args)
    {
        Debug.Log("CallStatic from: \"" + name + "\" to: " + str);
    }

    public T CallStatic<T>(string str, params object[] args)
    {
        Debug.Log("RETURNING CallStatic from: \"" + name + "\" to: " + str);
        return default(T);
    }

    public T Get<T>(string str)
    {
        Debug.Log("RETURNING Get from: \"" + name + "\" in: " + str);

        return default(T);
    }

    public T GetStatic<T>(object str)
    {
        Debug.Log("RETURNING GetStatic from: \"" + name);

        return default(T);
    }

    public IntPtr GetRawObject()
    {
        return IntPtr.Zero;
    }

    public IntPtr GetRawClass()
    {
        return IntPtr.Zero;
    }

    public void Dispose()
    {

    }
}

public class AndroidJavaClass : IDisposable
{
    readonly string name;

    public AndroidJavaClass(string str, params object[] args)
    {
        name = str;
    }

    public void Call(string str, params object[] args)
    {
        Debug.Log("Call from: \"" + name + "\" to: " + str);
    }

    public T Call<T>(string str, params object[] args)
    {
        Debug.Log("RETURNING Call from: \"" + name + "\" to: " + str);

        return default(T);
    }

    public void CallStatic(string str, params object[] args)
    {
        Debug.Log("CallStatic from: \"" + name + "\" to: " + str);
    }

    public T CallStatic<T>(string str, params object[] args)
    {
        Debug.Log("RETURNING CallStatic from: \"" + name + "\" to: " + str);

        if (typeof(T) == typeof(AndroidJavaObject))
        {
            object instance = new AndroidJavaObject(str, args);
            return (T)instance;
        }

        return default(T);
    }

    public T Get<T>(string str)
    {
        Debug.Log("RETURNING Get from: \"" + name + "\" in: " + str);

        return default(T);
    }

    public T GetStatic<T>(object str)
    {
        Debug.Log("RETURNING GetStatic from: \"" + name);

        return default(T);
    }

    public IntPtr GetRawClass()
    {
        return IntPtr.Zero;
    }

    public void Dispose()
    {

    }
}

public static class AndroidJNI
{ 
    public static IntPtr GetMethodID(IntPtr clazz, string name, string sig)
    {
        return IntPtr.Zero;
    }

    public static void CallVoidMethod(IntPtr obj, IntPtr methodID, jvalue[] args)
    {

    }

    public static void AttachCurrentThread()
    {

    }
}
#endif