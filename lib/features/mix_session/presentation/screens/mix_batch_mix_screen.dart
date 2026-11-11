import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_target_section.dart';
import 'package:elchemist_app/core/utils/date_helper.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_flavoring_section.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_nic_base_section.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_orders_section.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_recipe_section.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_batch_volume_section.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_batch_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class MixBatchMixScreen extends ConsumerStatefulWidget {
  final String id;

  const MixBatchMixScreen({super.key, required this.id});

  @override
  ConsumerState<MixBatchMixScreen> createState() => _MixBatchScreenState();
}

class _MixBatchScreenState extends ConsumerState<MixBatchMixScreen> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final async = ref.watch(mixBatchDetailsProvider(id));

    var screenSize = MediaQuery.of(context).size;
    var mixWrapperWidth = screenSize.width < 1920 ? 800.0 : null;
    var sectionWidth = 350.0;
    var recipeSectionWidth =
        screenSize.width < 1920 ? sectionWidth : sectionWidth + 250;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            constraints: BoxConstraints(),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerEnd,
                  child: Tooltip(
                    message: "Cancel mix batch",
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        async.when(
                          data: (data) => Text(
                            data != null ? data.mixNumber : "",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          error: (error, stackTrace) => Text(
                            "",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          loading: () => Container(
                            width: 40,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          async.when(
                            data: (data) => data != null
                                ? data.createdAt.toTileDateString()
                                : "",
                            error: (error, stackTrace) => "",
                            loading: () => "",
                          ),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Gap(28.0),
                        MixBatchOrdersSection(
                          width: sectionWidth,
                          productionOrders: async.when(
                            data: (data) =>
                                data != null ? data.productionOrders : [],
                            error: (error, stackTrace) => [],
                            loading: () => [],
                          ),
                        ),
                      ],
                    ),
                    Gap(20.0),
                    async.when(
                      data: (data) {
                        if (data == null) {
                          return SizedBox.shrink();
                        }
                        final formula = data.formula;
                        final nicBases = formula.nicBases;
                        final flavorings = formula.flavorings;
                        final nicLevel =
                            formula.targetNicStr * formula.nicLevelMultiplier;

                        return Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: mixWrapperWidth ?? double.infinity,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      formula.name,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (formula.isPreMix)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: PreMixChip(
                                          fgColor: Colors.black,
                                          bgColor: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                                Text(
                                  'Nic Level: ${nicLevel.toInt()}mg',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Gap(24),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 20.0,
                                  runSpacing: 8.0,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: recipeSectionWidth,
                                      ),
                                      child: Column(
                                        spacing: 20.0,
                                        children: [
                                          MixBatchVolumeSection(),
                                          MixBatchRecipeSection(
                                            formulaId: formula.id,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: sectionWidth,
                                      ),
                                      child: Column(
                                        spacing: 20.0,
                                        children: [
                                          MixBatchFlavoringSection(
                                            flavorings: flavorings,
                                          ),
                                          MixBatchTargetSection(
                                            nicStr: formula.targetNicStr,
                                            vg: formula.targetVg,
                                            pg: formula.targetPg,
                                          ),
                                          MixNicBaseSection(
                                            nicStr: formula.nicBaseNicStr,
                                            vg: formula.nicBaseVg,
                                            pg: formula.nicBasePg,
                                            nicBases: nicBases,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) => SizedBox.shrink(),
                      loading: () => SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
