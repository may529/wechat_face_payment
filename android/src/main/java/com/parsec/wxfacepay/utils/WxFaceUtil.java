package com.parsec.wxfacepay.utils;


import android.content.Context;

import com.parsec.wxfacepay.WxFacePayServer;
import com.parsec.wxfacepay.WxFaceVerServer;
import com.tencent.wxpayface.WxPayFace;

/**
 * Author:yin.juan
 * Time:2020/10/16 14:50
 * Description:[一句话描述]
 */
public class WxFaceUtil {

    /**
     * 初始化
     */
    public static void init(final Context context, final ICallback callback) {
        WxFaceVerServer wxFaceVerServer = new WxFaceVerServer();
        wxFaceVerServer.initWxFacePay(context, callback);
    }

    /**
     * 刷脸实名
     */
    public static void InfoVer(Context context, final ICallback callback) {
        WxFaceVerServer wxFaceVerServer = new WxFaceVerServer();
        wxFaceVerServer.getWxPayFaceRawData(context, callback);
    }

    /**
     * 刷脸支付
     * @param faceJson
     */
    public static void FacePay(Context context, String faceJson, final ICallback callback) {
//        WxFaceVerServer wxFaceVerServer = new WxFaceVerServer();
//        //将json转成map
//        HashMap<String, String> hashMap =new HashMap<>();
//        Map<String, Object> map = new Gson().fromJson(faceJson ,new TypeToken<Map<String, Object>>(){}.getType());
//        for (String key:map.keySet()) {
//            String value = (String) map.get(key);
//            hashMap.put(key,value);
//        }
//        wxFaceVerServer.getWxpayfaceCode(hashMap,callback);
        WxFacePayServer wxFacePayServer = new WxFacePayServer();
        wxFacePayServer.getWxPayFaceRawData(context, callback);
    }


    /**
     * 启动扫码
     * @param context
     * @param callback
     */
    public static void ScanCode(Context context, final  ICallback callback){
        WxFacePayServer wxFacePayServer = new WxFacePayServer();
        wxFacePayServer.startCodeScanner(context, callback);
    }

    /**
     * 关闭扫码
     * 接口作用：在取消扫码或者扫码成功后调用。
     */
    public static void stopCodeScanner(){
        WxPayFace.getInstance().stopCodeScanner();
    }

    /**
     * 释放资源
     * 接口作用：释放人脸服务，断开连接。
     */
    public static void releaseWxpayface(Context context){
        WxPayFace.getInstance().releaseWxpayface(context);
    }
}
