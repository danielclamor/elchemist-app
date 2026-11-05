import 'package:elchemist_app/features/flavoring_option.dart/data/flavoring_option.dart';

class FlavoringOption {
  final String id;
  final String slug;
  final String name;
  final bool isVg;

  const FlavoringOption({
    required this.id,
    required this.slug,
    required this.name,
    required this.isVg,
  });

  factory FlavoringOption.fromDto(FlavoringOptionDto o) {
    return FlavoringOption(
      id: o.id,
      slug: o.slug,
      name: o.name,
      isVg: o.isVg,
    );
  }

  @override
  String toString() => 'FlavoringOption: {name: $name, isVg: $isVg"}';
}
