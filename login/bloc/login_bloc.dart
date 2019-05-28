import 'login_event.dart';
import 'login_state.dart';
import 'package:Zenit/auth/bloc/auth_bloc.dart';
import 'dart:async';

import 'package:Zenit/auth/bloc/auth_events.dart';

class LoginBloc {
  AuthBloc _authBloc;

  LoginBloc(this._authBloc) {
    _eventStream.listen(_mapEventToState);
  }

  StreamController<LoginEvent> _eventConroller = StreamController<LoginEvent>();
  Stream<LoginEvent> get _eventStream => _eventConroller.stream;
  StreamSink<LoginEvent> get eventSink => _eventConroller.sink;

  StreamController<LoginState> _stateController =
      StreamController<LoginState>();
  Stream<LoginState> get stateStream => _stateController.stream;
  StreamSink<LoginState> get _stateSink => _stateController.sink;

   _mapEventToState(LoginEvent event) {
    if (event is LoginPressed) {
      _stateSink.add(LoginLoading());
      try {
        _authBloc.eventSink.add(Login());
      } catch (_) {}
    }
  }

  dispose() {
    _eventConroller.close();
    _stateController.close();
  }
}
