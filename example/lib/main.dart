import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:event_bus_auto/event.dart';
import 'package:event_bus_auto/event_auto.dart';

part 'main.g.dart';

class LoginEvent {}

@EventAuto()
class Logic with _$LogicEvent, _$LogicEventAuto {
  @override
  @event
  void onLogin(LoginEvent event) {
    print('login event');
  }
}

void main() {
  final eventBus = EventBus();

  // set eventbus instance
  EventAuto.eventBus = eventBus;

  final logic = Logic();
  logic.registerEvents();

  eventBus.fire(LoginEvent());

  // logic.unRegisterEvents();
}
