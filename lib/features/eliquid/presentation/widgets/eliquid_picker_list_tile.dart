import 'package:elchemist_app/features/eliquid/domain/eliquid.dart';
import 'package:flutter/material.dart';

class EliquidPickerListTile extends StatelessWidget {
  final EliquidSummary eliquid;
  final bool isSelected;
  final VoidCallback? onTap;

  const EliquidPickerListTile({
    super.key,
    required this.eliquid,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      enabled: onTap != null,
      selected: isSelected,
      title: Text(eliquid.description),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 4.0,
      ),
      subtitle: Text(
        eliquid.upc,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
      ),
      trailing: Icon(
        isSelected
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
      ),
    );
  }
}
