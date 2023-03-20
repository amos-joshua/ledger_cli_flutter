
class TextFieldDelay<ValueType> {
  final Duration threshold;
  final void Function(ValueType) onChange;
  ValueType? value;
  var _lastUpdated = DateTime.fromMillisecondsSinceEpoch(0);

  TextFieldDelay({required this.onChange, this.value, this.threshold = const Duration(milliseconds: 300)});

  void updateValue(ValueType newValue) {
    if (newValue == value) return;
    value = newValue;
    _lastUpdated = DateTime.now();
    Future.delayed(threshold, tryTriggerCallback);
  }

  void tryTriggerCallback() {
    final delta = DateTime.now().difference(_lastUpdated);
    if (delta.inMilliseconds < threshold.inMilliseconds) {
      onChange(value as ValueType);
    }
  }
}