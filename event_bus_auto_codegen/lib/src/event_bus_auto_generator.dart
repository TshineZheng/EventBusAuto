import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:event_bus_auto/event_auto.dart';
import 'package:event_bus_auto_codegen/src/config.dart';
import 'package:source_gen/source_gen.dart';

class EventBusAutoGenerator extends GeneratorForAnnotation<EventAuto> {
  final Config config;

  EventBusAutoGenerator({this.config});

  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('EventAuto class is not ok for ${element.displayName}');
    }

    final subList = <EventAnotationRet>[];
    for (final methodElement in (element as ClassElement).methods) {
      for (final annometadata in methodElement.metadata) {
        final metadata = annometadata.computeConstantValue();
        // final metadatatype = annometadata.runtimeType;

        final metaTypeName = metadata.type.getDisplayString();

        if (metaTypeName == 'Event') {
          var bus = config.bus;
          final busField = metadata.getField('bus');
          if (!busField.isNull) bus = busField.toStringValue();
          subList.add(_genEventAnotation(element, methodElement, bus));
        }
      }
    }

    return _genEventAutoMixinClass(element, subList);
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

  final firstParameterType = method.parameters[0].type.getDisplayString();
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
