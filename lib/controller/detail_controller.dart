import 'package:intl/intl.dart';
import 'package:steps_app/domain/record_model.dart';
import 'package:steps_app/data/notion_api_client.dart';

class DetailController {
  final NotionApiClient notionApiClient= NotionApiClient(); 

  Future<int> save(int steps, int stepGoal, String memo) async{

    // ----- 日時を取得 -----
    DateTime now = DateTime.now();
    final myFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
    //  ----- 取得した日時を使いたいフォーマット（String型）に変換 -----
    final String dateTime = myFormat.format(now);

    // ----- 目標達成しているかチェック -----
     bool isGoalAchieved = false;
    if (steps >= stepGoal) {
      isGoalAchieved = true;
    } else if (steps < stepGoal) {
      isGoalAchieved = false;
    }

    // ----- 値を入れたモデルを作成 -----
    final RecordModel record = RecordModel(
      steps: steps,
      stepGoal: stepGoal,
      isGoalAchieved: isGoalAchieved,
      dateTime: dateTime,
      memo: memo,
    );

    final int responseStatusCode = await notionApiClient.createRecord(record);
    // await Future.delayed(Duration(seconds: 1)); //🌟確認用
    return responseStatusCode;
      // return 1;　//🌟確認用
  }
}
