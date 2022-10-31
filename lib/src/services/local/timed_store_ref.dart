class TimedStoreRef<T> {
  final T value;
  final DateTime dateTime;

  TimedStoreRef(this.value) : dateTime = DateTime.now();

  TimedStoreRef.fromJson(Map<String, dynamic> json)
      : value = json['v'],
        dateTime = DateTime.parse(json['t']);

  Map<String, dynamic> toJson() {
    return {
      'v': value,
      't': dateTime.toIso8601String(),
    };
  }
}
