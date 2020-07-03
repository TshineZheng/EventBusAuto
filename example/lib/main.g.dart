// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// EventBusAutoGenerator
// **************************************************************************

abstract class _$SubscriptionClassEvent {
  void onLogin(LoginEvent event);
}

mixin _$SubscriptionClassEventAuto on _$SubscriptionClassEvent {
  StreamSubscription<LoginEvent> onLoginSub;
  void registerEvents() {
    onLoginSub = Application.eventBus.on<LoginEvent>().listen(onLogin);
  }

  void unRegisterEvents() {
    onLoginSub?.cancel();
  }
}
