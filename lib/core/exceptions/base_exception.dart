import 'dart:io' show HttpStatus;

class BaseException implements Exception {
  const BaseException({this.message, this.status, this.statusCode});

  final HttpStatus? status;
  final int? statusCode;
  final String? message;
}
