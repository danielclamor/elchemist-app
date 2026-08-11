class FormulaDto {
  final String slug;
  final String name;
  final String brand;
  final String chillType;
  final String nicType;
  final List<NicProfileDto> nicProfiles;

  const FormulaDto({
    required this.slug,
    required this.name,
    required this.brand,
    required this.chillType,
    required this.nicType,
    required this.nicProfiles,
  });

  factory FormulaDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'slug': String slug,
        'name': String name,
        'brand': String brand,
        'chillType': String chillType,
        'nicType': String nicType,
        'nicProfiles': List<Map<String, dynamic>> nicProfiles
      } =>
        FormulaDto(
          slug: slug,
          name: name,
          brand: brand,
          chillType: chillType,
          nicType: nicType,
          nicProfiles: nicProfiles
              .map((nicProfile) => NicProfileDto.fromJson(nicProfile))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load')
    };
  }
}

class NicProfileDto {
  final String slug;
  final String name;
  final String fullName;
  final bool isNewMix;
  final double targetNicStr;
  final double targetVg;
  final double targetPg;
  final double nicBaseNicStr;
  final List<NicBaseDto> nicBases;
  final List<FlavoringDto> flavorings;

  const NicProfileDto({
    required this.slug,
    required this.name,
    required this.fullName,
    required this.isNewMix,
    required this.targetNicStr,
    required this.targetVg,
    required this.targetPg,
    required this.nicBaseNicStr,
    required this.nicBases,
    required this.flavorings,
  });

  factory NicProfileDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'slug': String slug,
        'name': String name,
        'fullName': String fullName,
        'isNewMix': bool isNewMix,
        'targetNicStr': double targetNicStr,
        'targetVg': double targetVg,
        'targetPg': double targetPg,
        'nicBaseNicStr': double nicBaseNicStr,
        'nicBases': List<Map<String, dynamic>> nicBases,
        'flavorings': List<Map<String, dynamic>> flavorings,
      } =>
        NicProfileDto(
          slug: slug,
          name: name,
          fullName: fullName,
          isNewMix: isNewMix,
          targetNicStr: targetNicStr,
          targetVg: targetVg,
          targetPg: targetPg,
          nicBaseNicStr: nicBaseNicStr,
          nicBases:
              nicBases.map((nicBase) => NicBaseDto.fromJson(nicBase)).toList(),
          flavorings: flavorings
              .map((flavoring) => FlavoringDto.fromJson(flavoring))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load Formula')
    };
  }
}

class NicBaseDto {
  final double ratio;
  final NicBaseOptionDto nicBaseOption;

  const NicBaseDto({
    required this.ratio,
    required this.nicBaseOption,
  });

  factory NicBaseDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'ratio': double ratio,
        'nicBaseOption': Map<String, dynamic> nicBaseOption,
      } =>
        NicBaseDto(
          ratio: ratio,
          nicBaseOption: NicBaseOptionDto.fromJson(nicBaseOption),
        ),
      _ => throw const FormatException('Failed to load NicBase')
    };
  }
}

class FlavoringDto {
  final String name;
  final double ratio;
  final bool isVg;

  const FlavoringDto({
    required this.name,
    required this.ratio,
    required this.isVg,
  });

  factory FlavoringDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'ratio': double ratio,
        'isVg': bool isVg,
      } =>
        FlavoringDto(
          name: name,
          ratio: ratio,
          isVg: isVg,
        ),
      _ => throw const FormatException('Failed to load Flavoring')
    };
  }
}

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
    return switch (json) {
      {
        'code': String code,
        'name': String name,
        'isVg': bool isVg,
      } =>
        NicBaseOptionDto(
          code: code,
          name: name,
          isVg: isVg,
        ),
      _ => throw const FormatException('Failed to load NicBaseOption')
    };
  }
}
