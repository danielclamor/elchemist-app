class FlavoringOptionDto {
  final String id;
  final String slug;
  final String name;
  final bool isVg;

  const FlavoringOptionDto({
    required this.id,
    required this.slug,
    required this.name,
    required this.isVg,
  });

  factory FlavoringOptionDto.fromJson(Map<String, dynamic> json) {
    return FlavoringOptionDto(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      isVg: json['isVg'] as bool,
    );
  }
}
