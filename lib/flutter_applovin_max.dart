library applovin;

import 'dart:async';

import 'package:flutter/services.dart';

enum AppLovinAdListener {
  adLoaded,
  adLoadFailed,
  adDisplayed,
  adHidden,
  adClicked,
  onAdDisplayFailed,
  onRewardedVideoStarted,
  onRewardedVideoCompleted,
  onUserRewarded
}

typedef AppLovinListener = Function(AppLovinAdListener listener);

class FlutterApplovinMax {
  FlutterApplovinMax._();

  static const MethodChannel _channel = MethodChannel('flutter_applovin_max');
  static final Map<String, AppLovinAdListener> appLovinAdListener = <String, AppLovinAdListener>{
    'AdLoaded': AppLovinAdListener.adLoaded,
    'AdLoadFailed': AppLovinAdListener.adLoadFailed,
    'AdDisplayed': AppLovinAdListener.adDisplayed,
    'AdHidden': AppLovinAdListener.adHidden,
    'AdClicked': AppLovinAdListener.adClicked,
    'AdFailedToDisplay': AppLovinAdListener.onAdDisplayFailed,
    'RewardedVideoStarted': AppLovinAdListener.onRewardedVideoStarted,
    'RewardedVideoCompleted': AppLovinAdListener.onRewardedVideoCompleted,
    'UserRewarded': AppLovinAdListener.onUserRewarded,
  };

  static Future<void> init(String unitId) async {
    try {
      await _channel.invokeMethod<void>('Init', <String, dynamic>{'UnitId': unitId});
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> showRewardVideo(AppLovinListener listener) async {
    try {
      _channel.setMethodCallHandler((MethodCall call) async => handleMethod(call, listener));
      await _channel.invokeMethod<void>('ShowRewardVideo');
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> isLoaded(AppLovinListener listener) async {
    return await _channel.invokeMethod('IsLoaded');
  }

  static Future<void> handleMethod(MethodCall call, AppLovinListener listener) async {
    listener(appLovinAdListener[call.method]);
  }
}
