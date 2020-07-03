import 'dart:async';

import 'package:event_bus_auto/event.dart';
import 'package:event_bus_auto/event_auto.dart';

import 'package:example/event/login_event.dart';

import 'config/application.dart';
import 'event/login_event.dart';
part 'main.g.dart';

void main() {
  EventAuto.eventBus = Application.eventBus;

  final subscriptionClass = SubscriptionClass();
  subscriptionClass.registerEvents();

  Application.eventBus.fire(LoginEvent());

  // subscriptionClass.unRegisterEvents();
}

class Store {}

@eventauto
class SubscriptionClass extends Store with _$SubscriptionClassEvent, _$SubscriptionClassEventAuto {
  @override
  @event
  void onLogin(LoginEvent event) {
    print('login event');
  }
}
