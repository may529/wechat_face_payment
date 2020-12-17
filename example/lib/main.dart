import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wechat_face_payment/wechat_face_payment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _initFacePayMsg = 'Unknown';
  String _releaseFacePayMsg = '';
  String _testWxPayFaceMsg = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WechatFacePayment.platformVersion;
      WechatFacePayment.hidePayLoadingDialog();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  ///
  /// FACEPAY 人脸凭证，常用于人脸支付
  /// FACEPAY_DELAY 延迟支付(提供商户号信息联系微信支付开通权限)
  ///
  Future<void> initFacePay() async {
    WechatFacePayment msg = await WechatFacePayment.initFacePay(
        "wx34aa1d8ffa545b06",
        "1506994921",
        "123455",
        "",
        "",
        "13249817234123412343",
        "1",
        "FACEPAY");
    if (!mounted) return;
    print(msg);
    setState(() {
      _initFacePayMsg = '${msg.resultCode}_${msg.returnMsg}';
    });
  }

  Future<void> wxFaceVerify() async {
    final Map<String, dynamic> result = await WechatFacePayment.wxFaceVerify();
    print('==========wxFaceVerify=============');
    print(result);
  }

  Future<void> wxFacePay() async {
    final Map<String, dynamic> result = await WechatFacePayment.wxFacePay();
    print('===========wxFacePay============');
    print(result);
  }

  ///
  /// 人脸识别模式。可选值：
  ///   FACEID-ONCE: 人脸识别(单次模式)
  ///   FACEID-LOOP: 人脸识别(循环模式)
  ///   ONCE与LOOP的区别：
  ///
  ///   ONCE只会识别一次。 即调用本接口后， 如果在指定时间内（比如５秒）没有识别出来，则会返回识别失败。
  ///   LOOP会持续识别人脸， 直到识别成功为止。（或者调用停止接口
  ///
  Future<void> startFacePay() async {
    WechatFacePayment msg = await WechatFacePayment.initFacePay(
        "wx34aa1d8ffa545b06",
        "1506994921",
        "123455",
        "",
        "",
        "13249817234123412343",
        "1",
        "FACEID-LOOP");
    if (!mounted) return;
    setState(() {
      _initFacePayMsg = '${msg.resultCode}_${msg.returnMsg}';
    });
  }

  ///
  ///  实名认证 FACE_AUTH
  ///
  Future<void> startFaceVerified() async {
    WechatFacePayment msg = await WechatFacePayment.initFacePay(
        "wx34aa1d8ffa545b06",
        "1506994921",
        "123455",
        "",
        "",
        "13249817234123412343",
        "1",
        "FACE_AUTH");
    if (!mounted) return;
    setState(() {
      _initFacePayMsg = '${msg.resultCode}_${msg.returnMsg}';
    });
  }

  ///
  /// 扫码
  ///
  Future<void> startScanCodeToPay() async {
    final Map<String, dynamic> result = await WechatFacePayment.wxScanCode();
    print('===========startScanCodeToPay============');
    print(result);
    // 扫码结果返回后需要手动关闭扫码
    await WechatFacePayment.wxStopCodeScanner;
  }

  Future<void> releaseWxpayface() async {
    String msg = await WechatFacePayment.releaseWxPayFace;
    if (!mounted) return;
    setState(() {
      _initFacePayMsg = '';
      _testWxPayFaceMsg = '';
      _releaseFacePayMsg = msg;
    });
  }

  Future<void> testWxPayFace() async {
    WechatFacePayment wechatFacePayment = await WechatFacePayment.testWxPayFace;
    if (!mounted) return;
    setState(() {
      _testWxPayFaceMsg = wechatFacePayment.resultCode ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wechat face payment example app'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text('Running on: $_platformVersion\n'),
              SizedBox(height: 30),
              Text('Running on: $_initFacePayMsg\n'),
              FlatButton(
                color: Colors.grey,
                onPressed: () {
                  testWxPayFace();
                },
                child: Text('testWxPayFace'),
              ),
              Text('testWxPayFace: $_testWxPayFaceMsg\n',
                  style: TextStyle(color: Colors.redAccent)),
              FlatButton(
                color: Colors.amberAccent,
                onPressed: () {
                  initFacePay();
                },
                child: Text('初始化插件'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.amberAccent[400],
                    onPressed: () {
                      wxFaceVerify();
                    },
                    child: Text('人脸识别'),
                  ),
                  SizedBox(width: 20),
                  FlatButton(
                    color: Colors.amberAccent[400],
                    onPressed: () {
                      wxFacePay();
                    },
                    child: Text('面 部 支 付'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Colors.green[500],
                onPressed: () {
                  startScanCodeToPay();
                },
                child: Text('扫码支付'),
              ),
              SizedBox(height: 20),
              Text('releaseWxpayface: $_releaseFacePayMsg\n',
                  style: TextStyle(color: Colors.redAccent)),
              FlatButton(
                color: Colors.redAccent[400],
                onPressed: () {
                  releaseWxpayface();
                },
                child: Text('释放资源，这步需要在组件销毁的时候调用',
                    style: TextStyle(color: Colors.white)),
              ),
              FlatButton(
                onPressed: () {
                  WechatFacePayment.showPayLoadingDialog();

                  /// 3 秒后自动关闭
                  Future.delayed(Duration(milliseconds: 3000), () {
                    WechatFacePayment.hidePayLoadingDialog();
                  });
                },
                child: Text('showPayLoading'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
