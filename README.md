# EventBusAuto
A tool for generating un/registerEvents method for [EventBus](https://pub.flutter-io.cn/packages/event_bus), based on `build_runner`.

# Installation
Add dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  event_bus_auto:
    path: ../event_bus_auto

dev_dependencies:
  build_runner: ^1.10.0
  event_bus_auto_codegen:
    path: ../event_bus_auto_codegen
```

# Usage
```dart
part 'xxx.g.dart';

class LoginEvent{
}

@EventAuto()
class Logic with _$LogicextendsEvent, _$LogicextendsEventAuto {
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

  Application.eventBus.fire(LoginEvent());

  // logic.unRegisterEvents();
}
```