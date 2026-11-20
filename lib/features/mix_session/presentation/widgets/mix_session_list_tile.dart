import 'package:elchemist_app/core/utils/date_helper.dart';
import 'package:elchemist_app/core/widgets/el_checkbox.dart';
import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:elchemist_app/features/mix_session/presentation/screens/mix_session_mix_screen.dart';
import 'package:elchemist_app/features/formula/presentation/widgets/pre_mix_chip.dart';
import 'package:elchemist_app/features/mix_session/presentation/widgets/mix_session_status_chip.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionListTile extends ConsumerWidget {
  final MixSessionSummary session;

  const MixSessionListTile({
    super.key,
    required this.session,
  });

  MixSessionStatusChip _getStatusChip(MixSessionStatus? status) {
    if (status == null) {
      return MixSessionStatusChip(
        labelIcon: null,
        labelText: "",
        fgColor: Colors.grey,
        bgColor: Colors.grey,
      );
    }
    return MixSessionStatusChip.fromStatus(status: status);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArchived = session.isArchived;

    final formattedCreatedAtDate = session.createdAt.toTileDateString();
    final mixedAt = session.mixedAt;
    final formattedMixedAtDate =
        mixedAt != null ? mixedAt.toTileDateString() : "";

    final textStyle = TextStyle(
      fontSize: 14,
      color: isArchived ? Colors.grey : null,
      decorationColor: Colors.grey,
      decorationThickness: 1.0,
    );

    return ListTile(
      tileColor: isArchived ? Theme.of(context).scaffoldBackgroundColor : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => MixSessionMixScreen(id: session.id)),
        );
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          spacing: 12.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElCheckbox(
                value: ref.watch(mixSessionSelectedTilesProvider.select(
                  (selectedMap) => selectedMap.containsKey(session.id),
                )),
                onChanged: (_) {
                  ref
                      .read(mixSessionSelectedTilesProvider.notifier)
                      .toggle(session);
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(session.sessionNumber, style: textStyle),
            ),
            Expanded(
              flex: 4,
              child: Row(
                spacing: 8.0,
                children: [
                  Text(session.formulaName, style: textStyle),
                  if (session.formulaIsPreMix)
                    PreMixChip(
                      fgColor: _getStatusChip(session.status).fgColor,
                      bgColor: _getStatusChip(session.status).bgColor,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(formattedCreatedAtDate, style: textStyle),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: AlignmentGeometry.centerLeft,
                child: _getStatusChip(session.status),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(formattedMixedAtDate, style: textStyle),
            ),
            Expanded(
              flex: 2,
              child: Text(session.batchCode ?? "", style: textStyle),
            ),
          ],
        ),
      ),
    );
  }
}
