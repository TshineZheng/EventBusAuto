import 'package:build/build.dart';
import 'package:event_bus_auto_codegen/src/config.dart';
import 'package:event_bus_auto_codegen/src/event_bus_auto_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder eventBusAuto(BuilderOptions options) {
  return SharedPartBuilder([EventBusAutoGenerator(config: Config())], 'event_bus_auto_codegen');
}
