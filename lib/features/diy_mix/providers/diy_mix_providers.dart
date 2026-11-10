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
  (ref) => 100 - ref.watch(diyMixNicBaseVgPercProvider),
);

final diyMixTargetNicStrPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(2.0),
);

final diyMixTargetVgPercProvider =
    NotifierProvider.autoDispose<DiyMixPercentageValue, double>(
  () => DiyMixPercentageValue(40.0),
);

final diyMixTargetPgPercProvider = Provider.autoDispose<double>(
  (ref) => 100 - ref.watch(diyMixTargetVgPercProvider),
);

class DiyMixFlavoringEntry {
  final String id;
  final String name;
  final double percentage;
  final bool isVg;

  const DiyMixFlavoringEntry({
    required this.id,
    this.name = '',
    this.percentage = 0.0,
    required this.isVg,
  });

  DiyMixFlavoringEntry copyWith({
    String? name,
    double? percentage,
    required bool isVg,
  }) =>
      DiyMixFlavoringEntry(
        id: id,
        name: name ?? this.name,
        percentage: percentage ?? this.percentage,
        isVg: isVg,
      );

  @override
  bool operator ==(Object other) =>
      other is DiyMixFlavoringEntry &&
      other.id == id &&
      other.name == name &&
      other.percentage == percentage &&
      other.isVg == isVg;

  @override
  int get hashCode => Object.hash(id, name, percentage, isVg);
}

class DiyMixFlavoringEntries extends Notifier<List<DiyMixFlavoringEntry>> {
  int _nextId = 0;

  @override
  List<DiyMixFlavoringEntry> build() => const [];

  void add() => state = [
        ...state,
        DiyMixFlavoringEntry(
          id: '${_nextId++}',
          name: 'Flavour ${state.length + 1}',
          isVg: false,
        )
      ];

  void remove(String id) => state = state.where((e) => e.id != id).toList();

  /// One write per commit; does nothing if the row didn't actually change.
  void update(
    String id, {
    required String name,
    required String percentage,
    required bool isVg,
  }) {
    final index = state.indexWhere((e) => e.id == id);
    if (index < 0) return; // row was removed meanwhile

    final updated = state[index].copyWith(
      name: name.trim(),
      percentage:
          (double.tryParse(percentage) ?? 0.0).clamp(0.0, 100.0).toDouble(),
      isVg: isVg,
    );
    if (updated == state[index]) return; // no change, so no refetch

    state = [...state]..[index] = updated;
  }
}

final diyMixFlavoringEntriesProvider = NotifierProvider.autoDispose<
    DiyMixFlavoringEntries, List<DiyMixFlavoringEntry>>(
  DiyMixFlavoringEntries.new,
);
