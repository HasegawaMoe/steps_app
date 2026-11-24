import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:steps_app/domain/record_model.dart';
import 'package:steps_app/env/env.dart';

class NotionApiClient {
  final header = {
    'Authorization': 'Bearer ${Env.notionToken}',
    'Notion-Version': '2026-03-11',
    'Content-Type': 'application/json',
  };

  final parent = {
    "type": "data_source_id",
    'data_source_id': Env.notionDataSourceId,
  };

  // ---------- 新規追加 ----------
  Future<int> createRecord(RecordModel record) async {
    Uri url = Uri.parse('https://api.notion.com/v1/pages');
    
    // ----- モデルをJsonで使えるMap型に変換 -----
    final Map<String, dynamic> recordJson = record.toJson();
    //  ----- Map型をJsonに変換 -----
    final body = jsonEncode({'parent': parent, 'properties': recordJson});
    final response = await http.post(url, headers: header, body: body);
    return response.statusCode;
  }
}
