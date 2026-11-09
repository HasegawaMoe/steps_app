import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepServiceController extends ChangeNotifier {
  int steps = 0;
  String? stepStatus;

  StreamSubscription<StepCount>? _stepSubscription;
  StreamSubscription<PedestrianStatus>? _stepStatusSubscription;

  // ---------- 権限確認 ----------
  Future<bool> isPermissionGranted() async {
    return Permission.activityRecognition.isGranted;
  }

  // ---------- 権限確認のダイアログを出すメソッド ----------
  Future<void> request() async {
    await Permission.activityRecognition.request();
  }

  Future<void> start() async {
    final status = await isPermissionGranted();
    // ---------- 許可されていない時 -----------
    if (!status) {
      stepStatus = '拒否';
      notifyListeners();
    } else {
      // ---------- 許可されているとき ----------
      stepStatus = '初期値';
      notifyListeners();
      // ----- 歩数取得 -----
      Stream<StepCount> stepStream = Pedometer.stepCountStream;
      _stepSubscription = stepStream.listen((event) {
        steps = event.steps;
        notifyListeners();
      });
      // ----- 歩行状態取得 -----
      Stream<PedestrianStatus> stepStatusStream =
          Pedometer.pedestrianStatusStream;
      _stepStatusSubscription = stepStatusStream.listen((event) {
        stepStatus = event.status;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    // ---------- 購読を取り消す -----------
    _stepSubscription?.cancel();
    _stepStatusSubscription?.cancel();
    super.dispose();
  }
}
