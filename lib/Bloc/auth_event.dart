import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserInteraction extends AuthEvent {
  const AuthUserInteraction();
}

class AuthTimeout extends AuthEvent {
  const AuthTimeout();
}
