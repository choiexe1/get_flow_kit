import 'base_exception.dart';

class AuthException extends BaseException {
  AuthException({super.message, super.status, super.statusCode});
}
