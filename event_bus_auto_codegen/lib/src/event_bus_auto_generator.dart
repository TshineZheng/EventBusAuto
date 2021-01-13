import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:event_bus_auto/event_auto.dart';
import 'package:event_bus_auto/event_bus_auto.dart';
import 'package:event_bus_auto_codegen/src/config.dart';
import 'package:event_bus_auto_codegen/src/log.dart';
import 'package:source_gen/source_gen.dart';

class EventBusAutoGenerator extends GeneratorForAnnotation<EventAuto> {
  /// 配置
  final Config config;

  EventBusAutoGenerator({this.config}) {
    log_debug = config.debug;
  }

  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    // 仅处理注解 EventAuto 的类
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('EventAuto class is not ok for ${element.displayName}');
    }

    final clazz = element as ClassElement;

    log('processing class ${clazz.name}');

    final subList = <EventAnotationRet>[];

    /// 循环类里所有方法，对注解有 event 的方法进行处理
    for (final methodElement in clazz.methods) {
      log('processing ${clazz.name}.${methodElement.displayName}');

      if (_eventAnnotationChecker.hasAnnotationOfExact(methodElement)) {
        log('${clazz.name}.${methodElement.displayName} has event');

        /// 默认使用 EventAuto.eventBus 注册事件
        var bus = config.bus;

        /// 如果注解里有自定义bus，则取出并使用
        final busField = _eventAnnotationChecker.firstAnnotationOfExact(methodElement).getField('bus');
        if (!busField.isNull) bus = busField.toStringValue();

        subList.add(_genEventAnotation(clazz, methodElement, bus));
      }
    }

    return _genEventAutoMixinClass(clazz, subList);
  }
}

String _genEventAutoMixinClass(ClassElement classElement, List<EventAnotationRet> eventList) {
  final sb = StringBuffer('');

  sb.writeln('mixin _\$${classElement.displayName}EventAuto {');

  eventList.forEach((element) {
    sb.writeln('${element.subHolderDef}');
  });

  sb.writeln('void registerEvents(){');
  sb.writeln('unRegisterEvents();');
  eventList.forEach((element) {
    sb.writeln(element.register);
  });
  sb.write('}');

  sb.writeln('void unRegisterEvents(){');
  eventList.forEach((element) {
    sb.writeln('${element.subHolder}?.cancel();');
  });
  sb.write('}');

  sb.write('}');

  return sb.toString();
}

EventAnotationRet _genEventAnotation(ClassElement classElement, MethodElement method, String bus) {
  if (method.parameters.length != 1) {
    throw InvalidGenerationSourceError(
        'Event method must be 1 parameter >> ${classElement.displayName}.${method.displayName}');
  }
  final methodName = method.displayName;

  final firstParameterType = method.parameters[0].type.getDisplayString(withNullability: false);
  final subHolder = '${methodName}Sub';
  final subHolderDef = 'StreamSubscription<$firstParameterType> $subHolder;';

  final register =
      '$subHolder = ${bus}.on<${firstParameterType}>().listen((this as ${classElement.displayName}).${methodName});';

  return EventAnotationRet(
    subHolder: subHolder,
    register: register,
    subHolderDef: subHolderDef,
  );
}

class EventAnotationRet {
  /// StreamSubscription holder
  final String subHolder;

  /// StreamSubscription define
  final String subHolderDef;

  /// StreamSubscription register
  final String register;

  EventAnotationRet({
    this.subHolder,
    this.register,
    this.subHolderDef,
  });
}

final _eventAnnotationChecker = const TypeChecker.fromRuntime(Event);
