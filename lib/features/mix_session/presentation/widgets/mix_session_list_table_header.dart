import 'package:elchemist_app/core/widgets/el_checkbox.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionListTableHeader extends ConsumerWidget {
  final List<MixSessionSummary> sessions;
  final Color? cardColor;

  const MixSessionListTableHeader({
    super.key,
    required this.sessions,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = const TextStyle(
      fontSize: 14.0,
    );

    final selectedMap = ref.watch(mixSessionSelectedTilesProvider);

    final selectedIds = selectedMap.values.map((o) => o.id).toList();

    final int selectedCount =
        sessions.where((order) => selectedMap.containsKey(order.id)).length;

    final bool? checkBoxValue;
    if (sessions.isEmpty || selectedCount == 0) {
      checkBoxValue = false;
    } else if (selectedCount == sessions.length) {
      checkBoxValue = true;
    } else {
      checkBoxValue = null;
    }

    return Card(
      color: cardColor,
      margin: EdgeInsets.zero,
      elevation: 0.0,
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(
          spacing: 12.0,
          children: selectedCount > 0
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElCheckbox(
                      value: checkBoxValue,
                      onChanged: sessions.isEmpty
                          ? null
                          : (_) {
                              final notifier = ref.read(
                                  mixSessionSelectedTilesProvider.notifier);

                              if (checkBoxValue == true) {
                                notifier.clear();
                              } else {
                                notifier.selectAll(sessions);
                              }
                            },
                      tristate: true,
                    ),
                  ),
                  Text(
                    '$selectedCount selected',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedIds.length > 1)
                    TextButton(
                      onPressed: () async {
                        try {
                          ref
                              .read(mixSessionSelectedTilesProvider.notifier)
                              .clear();

                          final targetId = selectedIds[0];
                          final sourceIds = selectedIds.sublist(1);
                          await ref
                              .read(mixSessionRepositoryProvider)
                              .mergeMixSessions(
                                sourceIds: sourceIds,
                                targetId: targetId,
                              );

                          final pager = ref.watch(mixSessionListPagerProvider);
                          final pageKey = (after: pager.currentCursor,);
                          ref.invalidate(mixSessionListPageProvider(pageKey));
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString()),
                            ));
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey,
                      ),
                      child: Text('Merge sessions'),
                    ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElCheckbox(
                      value: checkBoxValue,
                      onChanged: sessions.isEmpty
                          ? null
                          : (_) {
                              final notifier = ref.read(
                                  mixSessionSelectedTilesProvider.notifier);

                              if (checkBoxValue == true) {
                                notifier.clear();
                              } else {
                                notifier.selectAll(sessions);
                              }
                            },
                      tristate: true,
                    ),
                  ),
                  Expanded(flex: 2, child: Text("Mix Session", style: style)),
                  Expanded(flex: 4, child: Text("Formula", style: style)),
                  Expanded(flex: 2, child: Text("Date", style: style)),
                  Expanded(flex: 1, child: Text("Status", style: style)),
                  Expanded(flex: 2, child: Text("Mixed at", style: style)),
                  Expanded(flex: 2, child: Text("Batch Code", style: style)),
                ],
        ),
      ),
    );
  }
}
