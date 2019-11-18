package com.rose.asr_plugin;

import android.content.Context;
import android.util.Log;

import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.baidu.speech.asr.SpeechConstant;

import org.json.JSONObject;

import java.util.Map;

public class AsrManager {
    private static final String TAG = "AsrManager";

    /**
     * SDK内部核心 EventManager
     */
    private EventManager asr;

    //SDK 内部核心 事件回调类 英语开发者写自己的识别回调逻辑
    private RecogEventAdapter eventListener;

    //未release前 只能new一个
    private static volatile boolean isInited = false;


    /**
     * 初始化 提供E岑他ManagerFactory需要的Context和RecogEventAdapter
     *
     * @param context
     * @param listener 识别状态和结果回调
     */
    public AsrManager(Context context, OnAsrListener listener) {
        if (isInited) {
            Log.e(TAG, "还未调用release() 请勿新建一个新类");
            throw new RuntimeException("还未调用release() 请勿新建一个新类");
        }
        isInited = true;
        //SDK集成步骤 初始化asr的EventManager示例 多次得到的类，只能选择一个使用
        asr = EventManagerFactory.create(context, "asr");
        asr.registerListener(eventListener = new RecogEventAdapter(listener));
    }

    public void start(Map<String, Object> params) {
        //SDK集成步骤 拼接识别参数
        String json = new JSONObject(params).toString();
        Log.e(TAG + ".Debug", "识别参数" + json);
        asr.send(SpeechConstant.ASR_START, json, null, 0, 0);
    }

    public void stop() {
        Log.i(TAG, "停止录音");
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        asr.send(SpeechConstant.ASR_STOP, "{}", null, 0, 0);
    }

    public void cancel() {
        Log.i(TAG, "取消识别");
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        asr.send(SpeechConstant.ASR_CANCEL, "{}", null, 0, 0);
    }

    public void release() {
        if (asr == null) {
            return;
        }
        cancel();
        asr.unregisterListener(eventListener);
        asr = null;
        isInited = false;
    }
}
