# EventBusAuto
A tool for generating un/registerEvents method for [EventBus](https://pub.flutter-io.cn/packages/event_bus), based on `build_runner`.

# Installation
Add dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  event_bus_auto: ^0.0.2

dev_dependencies:
  build_runner: ^1.10.0
  event_bus_auto_codegen: ^0.0.2
```

# Usage
```dart
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

```