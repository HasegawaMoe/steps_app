import 'package:flutter/material.dart';
import 'package:steps_app/controller/home_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:steps_app/screen/setting_goal_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final stepController = HomeController();
  int stepGoal = 10000;

  @override
  void initState() {
    super.initState();
    newStepGoal();
    getResult();
  }

  // ---------- コントローラーから権限情報を受け取る ----------
  Future<void> getResult() async {
    bool result = await stepController.isPermissionGranted();
    if (result) {
      stepController.start();
    } else {
      await dialog();
      // OSダイアログで２度連続して拒否されているとPermanentlyDeniedになる
      // PermanentlyDeniedになるとOSダイアログは表示されなくなる
      await stepController.request();
      stepController.start();
    }
  }

  // ---------- ダイアログ ----------
  Future<void> dialog() async {
    // ダイアログを表示する時にWidgetがツリーから消えていないかを確認する
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('アプリを使うために'),
          content: Text(
            '歩数の記録には、身体活動へのアクセス許可が必要です。\n拒否した場合は、スマートフォンの設定から権限を許可し、アプリを再起動してください。',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              movePage();
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              listenable: stepController,
              builder: (BuildContext context, Widget? child) {
                return Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 150.0,
                      lineWidth: 15.0,
                      percent: getPercent(),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('端末起動後の歩数'),
                          Text(
                            '${stepController.steps}',
                            style: TextStyle(
                              fontSize: 60,
                              color: Color.fromRGBO(70, 75, 70, 1),
                            ),
                          ),
                          Text('/ $stepGoal 歩'),
                        ],
                      ),
                      progressColor: Colors.green,
                    ),
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

  // ---------- パーセント計算メソッド ----------
  double getPercent() {
    double decimals = stepController.steps / stepGoal;
    if (decimals <= 1) {
      return decimals;
    } else {
      // パーセントが100を超えたらカンストする
      return 1;
    }
  }

  // ---------- 歩行状態を表すカード ----------
  Widget statusPart() {
    return switch (stepController.stepStatus) {
      'walking' => createStatusPart('歩いています', icon: Icons.directions_walk),
      'stopped' => createStatusPart('止まっています', icon: Icons.man),
      'unknown' => createStatusPart('状態を取得できません', icon: Icons.cancel),
      '初期値' => createStatusPart('状態を取得中です', icon: Icons.hourglass_empty),
      '拒否' => createStatusPart('アクセスが\n許可されていません', icon: Icons.not_interested),
      null => createStatusPart('', icon: null),
      _ => createStatusPart('予想外のエラーです', icon: Icons.error),
    };
  }

  // ---------- カードの中身 ----------
  Widget createStatusPart(String status, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: stepController.stepStatus == null
                ? Text('')
                : Text('現在の歩行状態'),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(status, style: TextStyle(fontSize: 15)),
            ),
            leading: icon == null
                ? null
                : Icon(icon, size: 50.0, color: Colors.green),
          ),
        ],
      ),
    );
  }


  // ---------- 目標歩数設定画面との遷移メソッド ----------
  void movePage() async{
    final popNotion = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SettingGoalScreen(stepGoal: stepGoal))
    );
    if (popNotion != null){
      setState(() {
        stepGoal = popNotion;
      });
    }
  }

  Future<void> newStepGoal() async{
    final savedStepGoal = await stepController.getting();
    if (savedStepGoal != null) {
      stepGoal = savedStepGoal;
    }
  }
}
