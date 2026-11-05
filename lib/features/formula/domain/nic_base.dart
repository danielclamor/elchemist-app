import 'package:elchemist_app/features/formula/data/nic_base_dto.dart';
import 'package:elchemist_app/features/nic_base_option/domain/nic_base_option.dart';

class NicBase {
  final double ratio;
  final NicBaseOption nicBaseOption;

  const NicBase({
    required this.ratio,
    required this.nicBaseOption,
  });

  factory NicBase.fromDto(NicBaseDto b) {
    return NicBase(
      nicBaseOption: NicBaseOption.fromDto(b.nicBaseOption),
      ratio: b.ratio,
    );
  }

  double get percentage => ratio * 100;

  String get code => nicBaseOption.code;

  String get name => nicBaseOption.name;

  bool get isVg => nicBaseOption.isVg;

  String get label => nicBaseOption.label;
}
