import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:steps_app/env/env.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steps_app/screen/home_screen.dart';

class StepServiceController extends ChangeNotifier {
  int steps = 0;
  String stepStatus = '初期値';

  StreamSubscription<StepCount>? _stepSubscription;
  StreamSubscription<PedestrianStatus>? _stepStatusSubscription;

  // ---------- 権限許可リクエスト ----------
  Future<void> isPermissionGranted() async {
    final status = await Permission.activityRecognition.status;
    // ----- 許可されている場合 -----
    if (status.isGranted || status.isLimited) {
      start();
    } else {
      // ----- 許可されていない場合 ----- (⚠️未記入)
      null;
    }
  }

  void start() {
    // ----------- 歩数取得 ------------
    Stream<StepCount> stepStream = Pedometer.stepCountStream;
    _stepSubscription = stepStream.listen((event) {
      steps = event.steps;
      notifyListeners();
    });

    // ----------- 歩行状態取得 ----------
    Stream<PedestrianStatus> stepStatusStream =
        Pedometer.pedestrianStatusStream;
    _stepStatusSubscription = stepStatusStream.listen((event) {
      stepStatus = event.status;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // ---------- 購読を取り消す -----------
    _stepSubscription?.cancel();
    _stepStatusSubscription?.cancel();
    super.dispose();
  }
}
