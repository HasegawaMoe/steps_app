import 'package:steps_app/env/env.dart';
import 'package:http/http.dart' as http;

class DetailController {

  final headers = {
  'Authorization': 'Bearer ${Env.notionToken}',
  'Notion-Version': '2026-03-11',
  'Content-Type': 'application/json',
};

  // final postData = {
  // "parent": {"database_id":"3f331cb5-c9cd-80e9-82a5-ff6f406395c3"},
  // "properties":
  // };

  // Future<void> postData() async {
  //   final response = await http.post(
  //     Uri.parse('/v1/data_sources/{data_source_id}/query'),
  //     headers: headers,
  //     body: {


  //     }

  //   );
  // }
}