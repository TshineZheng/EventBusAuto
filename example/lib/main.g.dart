// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// EventBusAutoGenerator
// **************************************************************************

mixin _$LogicEventAuto {
  StreamSubscription<NewOrderEvent>? onNewOrderEventSub;
  void registerEvents() {
    unRegisterEvents();
    onNewOrderEventSub = EventAuto.eventBus
        ?.on<NewOrderEvent>()
        .listen((this as Logic).onNewOrderEvent);
  }

  void unRegisterEvents() {
    onNewOrderEventSub?.cancel();
  }
}
