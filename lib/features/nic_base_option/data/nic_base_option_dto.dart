class NicBaseOptionDto {
  final String code;
  final String name;
  final bool isVg;

  const NicBaseOptionDto({
    required this.code,
    required this.name,
    required this.isVg,
  });

  factory NicBaseOptionDto.fromJson(Map<String, dynamic> json) {
    return NicBaseOptionDto(
      code: json['code'] as String,
      name: json['name'] as String,
      isVg: json['isVg'] as bool,
    );
  }
}
