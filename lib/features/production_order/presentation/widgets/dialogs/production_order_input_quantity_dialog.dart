import 'package:elchemist_app/components/atoms/el_text_field.dart';
import 'package:elchemist_app/features/production_order/domain/production_order.dart';
import 'package:flutter/material.dart';

class ProductionOrderInputQuantityDialog extends StatefulWidget {
  final int? orderedQuantity;
  final ProductionOrderJobType jobType;

  const ProductionOrderInputQuantityDialog({
    super.key,
    this.orderedQuantity,
    required this.jobType,
  });

  @override
  State<ProductionOrderInputQuantityDialog> createState() =>
      _ProductionOrderInputQuantityDialogState();
}

class _ProductionOrderInputQuantityDialogState
    extends State<ProductionOrderInputQuantityDialog> {
  final _quantityController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.orderedQuantity != null) {
      _quantityController.text = widget.orderedQuantity.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
  }

  bool _isQuantityRequired() => switch (widget.jobType) {
        ProductionOrderJobType.mix => true,
        ProductionOrderJobType.repat => false,
      };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${widget.orderedQuantity != null ? 'Confirm' : 'Enter'} ordered quantity',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElTextField(
            controller: _quantityController,
            contentType: ElTextFieldContentType.numeric,
            hasError: _hasError,
            onSubmitted: (value) {
              if (_hasError) {
                final qty = int.tryParse(value);
                if (qty != null && qty > 0) {
                  setState(() => _hasError = false);
                }
              }

              setState(() => _quantityController.text = value);
            },
          ),
          if (widget.jobType == ProductionOrderJobType.mix)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Quantity is required for mixing',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            final qty = int.tryParse(_quantityController.text);

            if (_isQuantityRequired() && (qty == null || qty <= 0)) {
              setState(() => _hasError = true);
            } else {
              setState(() => _hasError = false);
              Navigator.of(context).pop(qty);
            }
          },
          child: Text('Submit'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
