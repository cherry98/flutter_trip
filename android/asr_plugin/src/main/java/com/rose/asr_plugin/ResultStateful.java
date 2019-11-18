package com.rose.asr_plugin;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class ResultStateful implements MethodChannel.Result {

    private final static String TAG = "ResultStateful";
    private MethodChannel.Result result;
    private boolean called;

    private ResultStateful(MethodChannel.Result result) {
        this.result = result;
    }

    public static ResultStateful of(MethodChannel.Result result) {
        return new ResultStateful(result);
    }

    @Override
    public void success(Object o) {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.success(o);
    }

    @Override
    public void error(String s, String s1, Object o) {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.error(s, s1, o);
    }

    @Override
    public void notImplemented() {
        if (called) {
            printError();
            return;
        }
        called = true;
        result.notImplemented();
    }

    private void printError() {
        Log.e(TAG, "error：result called");
    }
}
