import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:event_bus_auto/event.dart';
import 'package:event_bus_auto/event_auto.dart';

part 'main.g.dart';

class NewOrderEvent {}

@EventAuto()
class Logic with _$LogicEventAuto {
  @event
  void onNewOrderEvent(NewOrderEvent event) {
    print('new order event');
  }
}

void main() {
  final eventBus = EventBus();

  // set eventbus instance
  EventAuto.eventBus = eventBus;

  final logic = Logic();
  logic.registerEvents();

  eventBus.fire(NewOrderEvent());

  // logic.unRegisterEvents();
}
