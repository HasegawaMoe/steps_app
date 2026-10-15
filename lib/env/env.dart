// lib/env/env.dart
import 'package:envied/envied.dart';

// build_runner が作るファイルを読み込む
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  // .env の NOTION_TOKEN を読み込む
  @EnviedField(varName: 'NOTION_TOKEN', obfuscate: true)
  static final String notionToken = _Env.notionToken;

  // .env の NOTION_DATA_SOURCE_ID を読み込む
  @EnviedField(varName: 'NOTION_DATA_SOURCE_ID', obfuscate: true)
  static final String notionDataSourceId = _Env.notionDataSourceId;
}
