import 'package:flutter/material.dart';
import 'package:steps_app/controller/detail_controller.dart';

class DetailScreen extends StatefulWidget {
  final int steps;
  final int stepGoal;

  const DetailScreen({super.key, required this.steps, required this.stepGoal});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final detailController = DetailController();
  final TextEditingController _memoController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 画面をタップしたらキーボードが閉じる
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('メモを記録', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '目標歩数：${widget.stepGoal}歩',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromRGBO(70, 75, 70, 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  child: Text(
                    '現在の歩数：${widget.steps}歩',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromRGBO(70, 75, 70, 1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 15.0),
                  child: TextField(
                    controller: _memoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'メモを入力',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                // ---------- メモ新規作成ボタン ----------
                ElevatedButton(
                  onPressed: _isLoading ? null : ()async{await isResponseReceived(context);},
                  child: Text('記録する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- 保存するボタンの処理メソッド ----------
  Future<void> isResponseReceived(BuildContext context) async {
    print('🐣ボタン押された！');
    // ----- ボタンを押せなくする -----
    setState(() {
    _isLoading = true;
    });
    // ----- キーボードを閉じる -----
    FocusScope.of(context).unfocus();
    // ----- 通信、statusCodeを受け取る -----
    final statusCode = await detailController.save(
      widget.steps,
      widget.stepGoal,
      _memoController.text,
    );
    if (!context.mounted) return;
    if (statusCode != 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('記録に失敗しました')));
      // -----  ボタンを有効に戻す -----
      setState(() {
      _isLoading = false;
      print('🐣通信失敗。。。ボタン戻す！');
      });
    } else {
      Navigator.of(context).pop();
      // ----- ボタンを有効に戻す -----
      print('🐣通信成功！ボタン戻す！');
      setState(() {
      _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }
}
