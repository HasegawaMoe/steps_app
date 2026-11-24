class RecordModel {
  final int steps;
  final int stepGoal;
  final bool isGoalAchieved;
  final String dateTime;
  final String memo;

  RecordModel({
    required this.steps,
    required this.stepGoal,
    required this.isGoalAchieved,
    required this.dateTime,
    required this.memo
  });

// ---------- モデル　→ Jsonで使うMap型に変換する ----------
  Map<String, dynamic> toJson(){
    return{
      '歩数': {'number': steps},
        '目標達成': {'checkbox': isGoalAchieved},
        '目標歩数': {'number': stepGoal},
        'メモ': {
          'rich_text': [
            {
              'text': {'content': memo},
            },
          ],
        },
        "保存日時": {
          "title": [
            {
              "text": {"content": dateTime},
            },
          ],
        },
    };
  }


}