import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingGoalScreen extends StatefulWidget {
  const SettingGoalScreen({super.key, required this.stepGoal});
  final int stepGoal;
  @override
  State<SettingGoalScreen> createState() => SettingGoalScreenStatus();
}

class SettingGoalScreenStatus extends State<SettingGoalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('目標歩数設定', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('現在設定されている目標歩数:'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text('${widget.stepGoal}',style: TextStyle(fontSize: 30,color: Color.fromRGBO(70, 75, 70, 1)),),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('歩'),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    // ----- 数字のみの入力に制限 -----
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return '値を入力してください';
                      } 
                      final int? valueToInt = int.tryParse(value);
                      if(valueToInt == 0 || valueToInt == null) {
                        return '１以上の数字を入力してください';
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: '目標にしたい歩数を入力してください',hintStyle: TextStyle(color: Colors.grey))),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                    setting();
                    final int textToInt = int.parse(goalController.text);
                    Navigator.of(context).pop(textToInt);
                    }
                  },
                  child: Text('設定する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------- 目標歩数を端末に保存するメソッド ----------
  Future<void> setting() async {
    final goal = int.tryParse(goalController.text);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('goal', goal!);
  }

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }
}
