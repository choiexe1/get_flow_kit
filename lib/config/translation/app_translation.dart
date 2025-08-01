import 'package:get/route_manager.dart';

/// 앱 전역에서 사용하는 번역 기능
class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ko': {'한국 은행': '한국 은행', '유효기간': '유효기간'},
  };
}
