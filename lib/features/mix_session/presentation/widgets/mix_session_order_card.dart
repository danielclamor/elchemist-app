import 'package:elchemist_app/core/widgets/el_hover_close_card.dart';
import 'package:elchemist_app/features/mix_session/providers/mix_session_providers.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:elchemist_app/features/production_order/presentation/widgets/cards/production_order_card.dart';
import 'package:elchemist_app/features/production_order/providers/production_order_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MixSessionOrderCard extends ConsumerWidget {
  final String mixSessionId;
  final ProductionOrderSummary order;

  const MixSessionOrderCard({
    super.key,
    required this.mixSessionId,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElHoverCloseCard(
        child: ProductionOrderCard(productionOrder: order),
        onClose: () {
          ref
              .read(productionOrderRepositoryProvider)
              .bulkUnassignFromMixSession(
            productionOrderIds: [order.id],
          );
          ref.invalidate(
            mixSessionDetailsProvider(mixSessionId),
          );
        });
  }
}
