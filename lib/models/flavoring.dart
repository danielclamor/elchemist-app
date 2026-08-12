import 'package:elchemist_app/models/flavoring_option.dart';
import 'package:elchemist_app/services/api_models.dart';

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
}
