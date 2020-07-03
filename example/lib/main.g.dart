// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// EventBusAutoGenerator
// **************************************************************************

abstract class _$LogicEvent {
  void onLogin(LoginEvent event);
}

mixin _$LogicEventAuto on _$LogicEvent {
  StreamSubscription<LoginEvent> onLoginSub;
  void registerEvents() {
    onLoginSub = EventAuto.eventBus.on<LoginEvent>().listen(onLogin);
  }

  void unRegisterEvents() {
    onLoginSub?.cancel();
  }
}
