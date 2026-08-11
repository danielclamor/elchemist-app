import 'package:elchemist_app/services/api_models.dart';

class Flavoring {
  final String name;
  double ratio;
  bool isVG;

  Flavoring({
    required this.name,
    required this.ratio,
    required this.isVG,
  });

  factory Flavoring.fromDto(FlavoringDto d) => Flavoring(
        name: d.name,
        ratio: d.ratio,
        isVG: d.isVg,
      );

  double get percentage => ratio * 100;
}
