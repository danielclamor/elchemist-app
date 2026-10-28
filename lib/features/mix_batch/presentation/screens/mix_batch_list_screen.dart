import 'package:elchemist_app/features/mix_batch/presentation/widgets/mix_batch_list_table.dart';
import 'package:flutter/material.dart';

class MixBatchListScreen extends StatefulWidget {
  const MixBatchListScreen({super.key});

  @override
  State<MixBatchListScreen> createState() => _MixBatchListScreenState();
}

class _MixBatchListScreenState extends State<MixBatchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width >= 800
              ? MediaQuery.of(context).size.width - 280
              : MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mix Batches',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Expanded(child: MixBatchListTable()),
          ],
        ),
      ),
    );
  }
}
