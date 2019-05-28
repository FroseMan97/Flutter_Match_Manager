abstract class AuthState {}

class Authenticated extends AuthState {}

class UnAuthenticated extends AuthState {}

class UnInitialized extends AuthState {}

class AuthLoading extends AuthState {}
