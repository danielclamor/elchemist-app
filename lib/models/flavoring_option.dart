import 'package:elchemist_app/services/api_models.dart';

class FlavoringOption {
  final String slug;
  final String name;
  final bool isVg;

  const FlavoringOption({
    required this.slug,
    required this.name,
    required this.isVg,
  });

  factory FlavoringOption.fromDto(FlavoringOptionDto o) => FlavoringOption(
        slug: o.slug,
        name: o.name,
        isVg: o.isVg,
      );

  @override
  String toString() => 'FlavoringOption: {name: $name, isVg: $isVg"}';
}
