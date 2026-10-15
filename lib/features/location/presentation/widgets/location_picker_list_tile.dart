import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:flutter/material.dart';

class LocationPickerListTile extends StatelessWidget {
  final LocationSummary location;
  final bool isSelected;
  final VoidCallback? onTap;

  const LocationPickerListTile({
    super.key,
    required this.location,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      enabled: onTap != null,
      selected: isSelected,
      title: Text(location.name),
      subtitle: location.isHq
          ? Text(
              "Headquarters",
              style: TextStyle(fontSize: 12),
            )
          : null,
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
