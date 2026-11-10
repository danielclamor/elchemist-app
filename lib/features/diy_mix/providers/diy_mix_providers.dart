import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiyMixVolumeMlValue extends Notifier<double> {
  @override
  double build() => 30.0;

  void set(String volumeMl) => state = double.tryParse(volumeMl) ?? 0.0;
}

final diyMixVolumeMlValueProvider =
    NotifierProvider.autoDispose<DiyMixVolumeMlValue, double>(
  DiyMixVolumeMlValue.new,
);

class DiyMixPercentageValue extends Notifier<double> {
  DiyMixPercentageValue([this.initial = 0.0]);
  final double initial;

  @override
  double build() => initial;

  void set(String percentage) =>
      state = (double.tryParse(percentage) ?? 0.0).clamp(0.0, 100.0).toDouble();
}

final diyMixNicBaseNicStrPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(10.0),
);

final diyMixNicBaseVgPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(0.0),
);

final diyMixNicBasePgPercProvider = Provider.autoDispose<double>(
  (ref) => 100 - ref.watch(diyMixTargetVgPercProvider),
);

final diyMixTargetNicStrPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(8.0),
);

final diyMixTargetVgPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(40.0),
);

final diyMixTargetPgPercProvider = Provider.autoDispose<double>(
  (ref) => 100 - ref.watch(diyMixTargetVgPercProvider),
);
