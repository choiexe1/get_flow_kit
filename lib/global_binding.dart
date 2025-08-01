import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';

/// 앱 전역에서 사용될 객체의 의존성 주입 관리
class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
  }
}
