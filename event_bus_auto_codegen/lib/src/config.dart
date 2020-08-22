class Config {
  /// 全局自定义 eventBus 实例
  final String bus;
  /// 是否打开 debug 显示
  final bool debug;

  Config({this.bus = 'EventAuto.eventBus', this.debug = false});
}
