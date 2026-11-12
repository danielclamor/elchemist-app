import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_session_list_table.dart';
import 'package:flutter/material.dart';

class MixSessionListScreen extends StatefulWidget {
  const MixSessionListScreen({super.key});

  @override
  State<MixSessionListScreen> createState() => _MixSessionListScreenState();
}

class _MixSessionListScreenState extends State<MixSessionListScreen> {
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
                  'Mix Sessions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Expanded(child: MixSessionListTable()),
          ],
        ),
      ),
    );
  }
}
