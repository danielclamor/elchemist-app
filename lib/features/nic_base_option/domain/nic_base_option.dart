import 'package:elchemist_app/features/nic_base_option/data/nic_base_option_dto.dart';

class NicBaseOption {
  final String code;
  final String name;
  final bool isVg;

  const NicBaseOption({
    required this.code,
    required this.name,
    required this.isVg,
  });

  factory NicBaseOption.fromDto(NicBaseOptionDto o) {
    return NicBaseOption(
      code: o.code,
      name: o.name,
      isVg: o.isVg,
    );
  }

  @override
  bool operator ==(other) => other is NicBaseOption && code == other.code;

  @override
  int get hashCode => Object.hash(code.hashCode, name.hashCode);

  String get label => '$name ($code)';
}
