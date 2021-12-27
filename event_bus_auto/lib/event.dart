library event_bus_auto;

class Event {
  /// whitch bus will use
  final String? bus;

  const Event({this.bus});
}

const event = Event();
