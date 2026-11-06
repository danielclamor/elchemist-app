import 'package:elchemist_app/core/utils/date_helper.dart';
import 'package:elchemist_app/features/mix_batch/providers/mix_batch_providers.dart';
import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_formula_wrapper.dart';
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
                      ],
                    ),
                    Gap(48.0),
                    async.when(
                      data: (data) => data != null
                          ? MixBatchFormulaWrapper(formulaId: data.formula.id)
                          : SizedBox.shrink(),
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
