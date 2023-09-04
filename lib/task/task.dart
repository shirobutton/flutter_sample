import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

const isCompletedKey = 'is_completed';

@freezed
class Task with _$Task {
  const factory Task({
    int? id,
    required String name,
    @JsonKey(name: isCompletedKey)
    @Default(false)
    @IntBoolConverter()
        bool isCompleted,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

class IntBoolConverter implements JsonConverter<bool, dynamic> {
  const IntBoolConverter();
  @override
  bool fromJson(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 0 ? false : true;
    return false;
  }

  @override
  dynamic toJson(bool? bool) => bool;
}
