import 'package:elchemist_app/services/api_models.dart';

class NicBaseOption {
  final String code;
  final String name;
  final bool isVg;

  NicBaseOption({
    required this.code,
    required this.name,
    required this.isVg,
  });

  factory NicBaseOption.fromDto(NicBaseOptionDto d) => NicBaseOption(
        code: d.code,
        name: d.name,
        isVg: d.isVg,
      );

  @override
  bool operator ==(other) => other is NicBaseOption && code == other.code;

  @override
  int get hashCode => Object.hash(code.hashCode, name.hashCode);

  String get label => '$name ($code)';

  @override
  String toString() => 'NicBaseOption: {label: $label, isVg: $isVg"}';
}
