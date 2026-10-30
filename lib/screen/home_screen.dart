import 'package:flutter/material.dart';
import 'package:steps_app/env/env.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steps_app/controller/step_controller.dart';

final headers = {
  'Authorization': 'Bearer ${Env.notionToken}',
  'Notion-Version': '2026-03-11',
  'Content-Type': 'application/json',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final stepController = StepServiceController();

  @override
  void initState() {
    super.initState();
    stepController.isPermissionGranted();
  }

  @override
  void dispose() {
    print('🌟dispose');
    stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: const Text('端末起動後の歩数'),
            ),
            ListenableBuilder(
              listenable: stepController,
              builder: (BuildContext context, Widget? child) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ----- フォントサイズの異なる文字のベースラインを揃える ------
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          '${stepController.steps}',
                          style: TextStyle(
                            fontSize: 100,
                            color: Color.fromRGBO(70, 75, 70, 1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('歩', style: TextStyle(fontSize: 20.0)),
                        ),
                      ],
                    ),
                    const Divider(),
                    statusPart(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------- 歩行状態を表すカード ----------
  Widget statusPart() {
    return switch (stepController.stepStatus) {
      'walking' => createStatusPart('歩いています', Icons.directions_walk),
      'stopped' => createStatusPart('止まっています', Icons.man),
      'unknown' => createStatusPart('状態を取得できません', Icons.cancel),
      '初期値' => createStatusPart('状態を取得中です', Icons.hourglass_empty),
      _ => createStatusPart('予想外のエラーです', Icons.error),
    };
  }

  // ---------- カードの中身 ----------
  Widget createStatusPart(String status, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(10.0), child: Text('現在の歩行状態')),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(status, style: TextStyle(fontSize: 20)),
            ),
            leading: Icon(icon, size: 50.0, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
