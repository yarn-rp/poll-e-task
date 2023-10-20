import 'package:authentication_repository/src/constants/constants.dart';
import 'package:authentication_repository/src/exceptions/exceptions.dart';

class SignUpException extends AuthBaseException {
  SignUpException([String? message])
      : super(message ?? ErrorMessages.signUpError);
}