import 'package:elchemist_app/models/nic_base_option.dart';
import 'package:elchemist_app/services/api_models.dart';

class NicBase {
  final NicBaseOption nicBaseOption;
  final double ratio;

  NicBase({
    required this.nicBaseOption,
    required this.ratio,
  });

  factory NicBase.fromDto(NicBaseDto d) => NicBase(
        nicBaseOption: NicBaseOption.fromDto(d.nicBaseOption),
        ratio: d.ratio,
      );

  String get code => nicBaseOption.code;

  String get name => nicBaseOption.name;

  bool get isVG => nicBaseOption.isVG;

  String get label => nicBaseOption.label;

  double get percentage => ratio * 100;

  @override
  String toString() =>
      'Nicbase {label: $label, percentage: $percentage%, is_vg: $isVG}';
}
