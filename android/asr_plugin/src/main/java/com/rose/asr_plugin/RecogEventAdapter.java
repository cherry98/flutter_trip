package com.rose.asr_plugin;


import android.util.Log;

import com.baidu.speech.EventListener;
import com.baidu.speech.asr.SpeechConstant;

import org.json.JSONException;
import org.json.JSONObject;

public class RecogEventAdapter implements EventListener {
    private OnAsrListener listener;

    private static final String TAG = "RecogEventManager";

    public RecogEventAdapter(OnAsrListener listener) {
        this.listener = listener;
    }

    //基于DEMO继承3.1 开始回调事件
    @Override
    public void onEvent(String name, String params, byte[] data, int offset, int length) {
        String currentJson = params;
        String logMessage = "name:" + name + ",params:" + params;
        //logcat中搜索RecogEventAdapter 可以看见下面的日志
        Log.i(TAG, logMessage);
        if (false) {//若不需要后续逻辑 可以调试
            return;
        }
        if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_LOADED)) {
            listener.onOfflineLoaded();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_UNLOADED)) {
            listener.onOfflineUnLoaded();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_READY)) {
            listener.onAsrReady();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_BEGIN)) {
            listener.onAsrBegin();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_END)) {
            listener.onAsrEnd();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_PARTIAL)) {
            RecogResult recogResult = RecogResult.parseJson(params);
            //临时识别结果 长语音模式需要从此消息中取出结果
            String[] results = recogResult.getResultsRecognition();
            if (recogResult.isFinalResult()) {
                listener.onAsrFinalResult(results, recogResult);
            } else if (recogResult.isPartialResult()) {
                listener.onAsrPartialResult(results, recogResult);
            } else if (recogResult.isNluResult()) {
                listener.onAsrOnlineNluResult(new String(data, offset, length));
            }
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_FINISH)) {
            //识别结束 最终识别结果或可能的错误
            RecogResult recogResult = RecogResult.parseJson(params);
            if (recogResult.hasError()) {
                int errorCode = recogResult.getError();
                int subErrorCode = recogResult.getSubError();
                Log.e(TAG, "asr error:" + params);
                listener.onAsrFinishError(errorCode, subErrorCode, recogResult.getDesc(), recogResult);
            } else {
                listener.onAsrFinish(recogResult);
            }
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_LONG_SPEECH)) {//长语音
            listener.onAsrLongFinish();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_EXIT)) {
            listener.onAsrExit();
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_VOLUME)) {
            Volume volume = parseVolumeJson(params);
            listener.onAsrVolume(volume.volumePercent, volume.volume);
        } else if (name.equals(SpeechConstant.CALLBACK_EVENT_ASR_AUDIO)) {
            if (data.length != length) {
                Log.e(TAG, "internal error: asr.aduio callback data length is not equal to length param");
            }
            listener.onAsrAudio(data, offset, length);
        }
    }


    private Volume parseVolumeJson(String jsonStr) {
        Volume volume = new Volume();
        volume.origalJson = jsonStr;
        try {
            JSONObject json = new JSONObject(jsonStr);
            volume.volumePercent = json.getInt("percent");
            volume.volume = json.getInt("volume");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return volume;
    }

    private class Volume {
        private int volumePercent = -1;
        private int volume = -1;
        private String origalJson;
    }
}
