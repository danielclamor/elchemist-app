class NicBaseOption {
  final String code;
  final String name;
  final bool isVG;

  NicBaseOption({
    required this.code,
    required this.name,
    required this.isVG,
  });

  factory NicBaseOption.fromMap(Map<String, dynamic> map) => NicBaseOption(
        code: map["code"] as String,
        name: map["name"] as String,
        isVG: map["is_vg"] as bool,
      );

  @override
  bool operator ==(other) => other is NicBaseOption && code == other.code;

  @override
  int get hashCode => Object.hash(code.hashCode, name.hashCode);

  String get label => '$name ($code)';

  @override
  String toString() => 'NicBaseOption: {label: $label, is_vg: $isVG"}';
}

class NicBase {
  final NicBaseOption nicBaseOption;
  double percentage;

  NicBase({
    required this.nicBaseOption,
    required this.percentage,
  });

  factory NicBase.fromMap(Map<String, dynamic> map) => NicBase(
        nicBaseOption:
            NicBaseOption.fromMap(map["nic_base"] as Map<String, dynamic>),
        percentage: map["percentage"] as double,
      );

  String get code => nicBaseOption.code;

  String get name => nicBaseOption.name;

  bool get isVG => nicBaseOption.isVG;

  String get label => nicBaseOption.label;

  @override
  String toString() =>
      'Nicbase {label: $label, percentage: $percentage, is_vg: $isVG}';
}
