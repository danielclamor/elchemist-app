import 'package:elchemist_app/core/widgets/fading_vertical_scroll.dart';
import 'package:elchemist_app/features/location/domain/location.dart';
import 'package:elchemist_app/features/location/presentation/providers/location_providers.dart';
import 'package:elchemist_app/features/location/presentation/widgets/location_picker_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationPickerList extends ConsumerWidget {
  final List<String> selectedIds;
  final ValueChanged<LocationSummary> onSelected;

  const LocationPickerList({
    super.key,
    this.selectedIds = const [],
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pager = ref.watch(locationSummaryListPagerProvider);
    final pageKey = (after: pager.currentCursor);
    final pageAsync = ref.watch(locationSummaryListPageProvider(pageKey));

    return pageAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: TextButton(
          onPressed: () =>
              ref.invalidate(locationSummaryListPageProvider(pageKey)),
          child: Text('Failed to load. Retry\n$e'),
        ),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return const Center(
            child: Text(
              'No e-liquids',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        return FadingVerticalScroll(
          fadeHeight: 16,
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: page.items.length,
            separatorBuilder: (context, index) => const Divider(
              height: 0.0,
              thickness: 0.25,
            ),
            itemBuilder: (context, index) {
              final location = page.items[index];
              return LocationPickerListTile(
                key: ValueKey(location.id),
                location: location,
                isSelected: selectedIds.contains(location.id),
                onTap: () => onSelected(location),
              );
            },
          ),
        );
      },
    );
  }
}
