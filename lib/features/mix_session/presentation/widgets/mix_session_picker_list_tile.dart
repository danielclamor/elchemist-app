import 'package:elchemist_app/features/mix_session/domain/mix_session.dart';
import 'package:flutter/material.dart';

class MixSessionPickerListTile extends StatelessWidget {
  final MixSessionSummary mixSession;
  final bool isSelected;
  final VoidCallback? onTap;

  const MixSessionPickerListTile({
    super.key,
    required this.mixSession,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      enabled: onTap != null,
      selected: isSelected,
      title: Text(mixSession.sessionNumber),
      subtitle: Text(
        mixSession.formulaName,
        style: TextStyle(fontSize: 12),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 4.0,
      ),
      trailing: Icon(
        isSelected
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
      ),
    );
  }
}
