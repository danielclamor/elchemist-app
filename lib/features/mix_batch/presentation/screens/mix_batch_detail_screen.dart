import 'package:elchemist_app/features/mix_batch/presentation/providers/mix_batch_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixBatchDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const MixBatchDetailScreen({super.key, required this.id});

  @override
  ConsumerState<MixBatchDetailScreen> createState() =>
      _MixBatchDetailScreenState();
}

class _MixBatchDetailScreenState extends ConsumerState<MixBatchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final async = ref.watch(mixBatchDetailsProvider(id));
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(),
            child: Column(
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: "Mix",
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
                            Icons.arrow_back_ios_rounded,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
