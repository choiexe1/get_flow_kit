import 'package:get_flow_kit/core/base_exception.dart';

class AuthException extends BaseException {
  AuthException({super.message, super.status, super.statusCode});
}
