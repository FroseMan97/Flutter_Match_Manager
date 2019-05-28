import 'dart:async';
import 'dart:core';

import 'auth_events.dart';
import 'auth_states.dart';
import '../repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc {
  final UserRepository _userRepo;

  StreamController<AuthEvent> _eventController = StreamController<AuthEvent>();
  Stream<AuthEvent> get _eventStream => _eventController.stream;
  StreamSink<AuthEvent> get eventSink => _eventController.sink;

  StreamController<AuthState> _stateController = StreamController<AuthState>();
  Stream<AuthState> get stateStream => _stateController.stream;
  StreamSink<AuthState> get _stateSink => _stateController.sink;

  AuthBloc(this._userRepo) {
    _eventStream.listen(_mapEventToState); // слушаем события
  }

  _mapEventToState(AuthEvent event) async { // event -> BLoC -> stream
    if (event is Decision) {
      try {
        final isSignedIn = await _userRepo.isSigned();
        if (isSignedIn) {
          _stateSink.add(Authenticated());
        } else {
          _stateSink.add(UnAuthenticated());
        }
      } catch (_) {
        _stateSink.add(UnAuthenticated());
      }
    }

    if (event is Login) {
      try {
        _stateSink.add(AuthLoading());
        FirebaseUser _user =
            await _userRepo.signInWithEmail('sosat@mail.ru', '123456'); // учетная запись для теста
        if (_user == null) {
          _stateSink.add(UnAuthenticated());
        } else {
          _stateSink.add(Authenticated());
        }
      } catch (e) {
        _stateSink.add(UnAuthenticated());
      }
    }

    if (event is Logout) {
      try {
        _stateSink.add(AuthLoading());
        _userRepo.signOut();
        _stateSink.add(UnAuthenticated());
      } catch (_) {
        _stateSink?.add(UnAuthenticated());
      }
    }
  }

  dispose() {
    _eventController?.close();
    _stateController?.close();
  }
}
