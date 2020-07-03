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

    var subList = <EventAnotationRet>[];
    for (var methodElement in (element as ClassElement).methods) {
      for (var annometadata in methodElement.metadata) {
        final metadata = annometadata.computeConstantValue();
        // final metadatatype = annometadata.runtimeType;

        final metaTypeName = metadata.type.getDisplayString();

        if (metaTypeName == 'Event') {
          var bus = config.bus;
          final busField = metadata.getField('bus');
          if (!busField.isNull) bus = busField.toStringValue();
          subList.add(_genEventAnotation(methodElement, bus));
        }
      }
    }

    return _genEventAutoMixinClass(element, subList);
  }
}

String _genEventAutoMixinClass(ClassElement classElement, List<EventAnotationRet> eventList) {
  final sb = StringBuffer('');

  final eventClassName = '_\$${classElement.displayName}Event';

  sb.writeln('abstract class $eventClassName {');
  eventList.forEach((element) {
    sb.writeln('${element.methodDisplayName};');
  });
  sb.write('}');

  sb.writeln('mixin _\$${classElement.displayName}EventAuto on ${eventClassName}{');

  eventList.forEach((element) {
    sb.writeln('${element.subHolderDef}');
  });

  sb.writeln('void registerEvents(){');
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

EventAnotationRet _genEventAnotation(MethodElement method, String bus) {
  final methodName = method.displayName;

  final firstParameterType = method.parameters[0].type.getDisplayString();
  final subHolder = '${methodName}Sub';
  final subHolderDef = 'StreamSubscription<LoginEvent> $subHolder;';

  final register = '$subHolder = ${bus}.on<${firstParameterType}>().listen(${methodName});';

  return EventAnotationRet(
    subHolder: subHolder,
    register: register,
    subHolderDef: subHolderDef,
    methodDisplayName: method.getDisplayString(withNullability: false),
  );
}

class EventAnotationRet {
  final String subHolder;
  final String subHolderDef;
  final String register;
  final String methodDisplayName;

  EventAnotationRet({
    this.subHolder,
    this.register,
    this.subHolderDef,
    this.methodDisplayName,
  });
}
