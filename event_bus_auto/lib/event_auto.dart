import 'package:event_bus/event_bus.dart';

class EventAuto {
  /// global eventBus instance
  static EventBus? eventBus;

  const EventAuto();
}

const eventauto = EventAuto();
