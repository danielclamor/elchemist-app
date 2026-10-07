import 'package:elchemist_app/features/production_order/presentation/providers/production_order_providers.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/dialogs/eliquid_past_orders_dialog.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/eliquid_past_orders_list_tile.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/eliquid_past_orders_preview_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EliquidPastOrdersPreview extends ConsumerWidget {
  final String eliquidId;
  const EliquidPastOrdersPreview({
    super.key,
    required this.eliquidId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(eliquidPastOrdersPreviewProvider(eliquidId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Failed to load history\n$e'),
      data: (page) {
        if (page.items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No past orders',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          );
        }
        return Column(
          children: [
            EliquidPastOrdersPreviewHeader(),
            Divider(
              height: 1.0,
              thickness: 0.25,
              color: Colors.black,
            ),
            ListView.separated(
              itemBuilder: (context, index) {
                final order = page.items[index];
                return EliquidPastOrdersPreviewListTile(
                  order: order,
                );
              },
              separatorBuilder: (context, index) => Divider(
                height: 0.0,
                thickness: 0.25,
                color: Colors.grey.shade500,
              ),
              itemCount: page.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            Divider(
              height: 1.0,
              thickness: 0.25,
              color: Colors.black,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 0.0,
              shape: RoundedRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: (page.totalCount > eliquidPastOrdersPreviewSize)
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => EliquidPastOrdersDialog(
                              eliquidId: eliquidId,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8.0),
                            ),
                          ),
                          label: Text('View all (${page.totalCount})'),
                          icon: Icon(Icons.arrow_forward_rounded),
                          iconAlignment: IconAlignment.end,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
    );
  }
}
