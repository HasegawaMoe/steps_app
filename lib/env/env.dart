// lib/env/env.dart
import 'package:envied/envied.dart';

// build_runner が作るファイルを読み込む
part 'env.g.dart';

// 「.env ファイルから値を読み込んでね」という目印
@Envied(path: '.env')
abstract class Env {
  // .env の NOTION_TOKEN を読み込む
  // obfuscate:true 値をそのまま埋め込まず、読みにくく変換（難読化） して埋め込む
  @EnviedField(varName: 'NOTION_TOKEN', obfuscate: true)
  // obfuscate: true のときは const ではなく final にする決まり
  static final String notionToken = _Env.notionToken;

  // .env の NOTION_DATA_SOURCE_ID を読み込む
  @EnviedField(varName: 'NOTION_DATA_SOURCE_ID', obfuscate: true)
  static final String notionDataSourceId = _Env.notionDataSourceId;
}
