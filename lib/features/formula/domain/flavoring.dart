import 'package:elchemist_app/features/flavoring_option.dart/domain/flavoring_option.dart';
import 'package:elchemist_app/features/formula/data/flavoring_dto.dart';

class Flavoring {
  final FlavoringOption flavoringOption;
  double ratio;

  Flavoring({
    required this.flavoringOption,
    required this.ratio,
  });

  factory Flavoring.fromDto(FlavoringDto d) => Flavoring(
        flavoringOption: FlavoringOption.fromDto(d.flavoringOption),
        ratio: d.ratio,
      );

  double get percentage => ratio * 100;

  String get name => flavoringOption.name;

  bool get isVg => flavoringOption.isVg;
}
