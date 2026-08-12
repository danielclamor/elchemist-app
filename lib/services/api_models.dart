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
        'nicProfiles': List<dynamic> nicProfiles
      } =>
        FormulaDto(
          slug: slug,
          name: name,
          brand: brand,
          chillType: chillType,
          nicType: nicType,
          nicProfiles: nicProfiles
              .map((p) =>
                  NicProfileDto.fromJson(Map<String, dynamic>.from(p as Map)))
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
        'targetNicStr': num targetNicStr,
        'targetVg': num targetVg,
        'targetPg': num targetPg,
        'nicBaseNicStr': num nicBaseNicStr,
        'nicBases': List<dynamic> nicBases,
        'flavorings': List<dynamic> flavorings,
      } =>
        NicProfileDto(
          slug: slug,
          name: name,
          fullName: fullName,
          isNewMix: isNewMix,
          targetNicStr: _toDouble(targetNicStr),
          targetVg: _toDouble(targetVg),
          targetPg: _toDouble(targetPg),
          nicBaseNicStr: _toDouble(nicBaseNicStr),
          nicBases: nicBases
              .map((b) =>
                  NicBaseDto.fromJson(Map<String, dynamic>.from(b as Map)))
              .toList(),
          flavorings: flavorings
              .map((f) => FlavoringDto.fromJson(Map<String, dynamic>.from(f)))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load Formula')
    };
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
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
        'ratio': num ratio,
        'nicBaseOption': dynamic nicBaseOption,
      } =>
        NicBaseDto(
          ratio: _toDouble(ratio),
          nicBaseOption: NicBaseOptionDto.fromJson(
              Map<String, dynamic>.from(nicBaseOption)),
        ),
      _ => throw const FormatException('Failed to load NicBase')
    };
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
}

class FlavoringDto {
  final FlavoringOptionDto flavoringOption;
  final double ratio;

  const FlavoringDto({
    required this.flavoringOption,
    required this.ratio,
  });

  factory FlavoringDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'flavoringOption': dynamic flavoringOption,
        'ratio': num ratio,
      } =>
        FlavoringDto(
          flavoringOption: FlavoringOptionDto.fromJson(
            Map<String, dynamic>.from(flavoringOption),
          ),
          ratio: _toDouble(ratio),
        ),
      _ => throw const FormatException('Failed to load Flavoring')
    };
  }

  static double _toDouble(Object? v) => (v as num).toDouble();
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

class FlavoringOptionDto {
  final String slug;
  final String name;
  final bool isVg;

  const FlavoringOptionDto({
    required this.slug,
    required this.name,
    required this.isVg,
  });

  factory FlavoringOptionDto.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'slug': String slug,
        'name': String name,
        'isVg': bool isVg,
      } =>
        FlavoringOptionDto(
          slug: slug,
          name: name,
          isVg: isVg,
        ),
      _ => throw const FormatException('Failed to load FlavoringOption')
    };
  }
}
