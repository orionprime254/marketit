import 'package:flutter/material.dart';

class PriceFilterWidget extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final Function(double, double) onPriceChanged;

  const PriceFilterWidget({
    Key? key,
    required this.minPrice,
    required this.maxPrice,
    required this.onPriceChanged,
  }) : super(key: key);

  @override
  _PriceFilterWidgetState createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget> {
  late double _currentMinPrice;
  late double _currentMaxPrice;

  @override
  void initState() {
    super.initState();
    _currentMinPrice = widget.minPrice;
    _currentMaxPrice = widget.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Filter by Price'),
        RangeSlider(
          min: widget.minPrice,
          max: widget.maxPrice,
          values: RangeValues(_currentMinPrice, _currentMaxPrice),
          onChanged: (values) {
            setState(() {
              _currentMinPrice = values.start;
              _currentMaxPrice = values.end;
            });
            widget.onPriceChanged(_currentMinPrice, _currentMaxPrice);
          },
        ),
        Text('Min: Ksh ${_currentMinPrice.toStringAsFixed(2)}'),
        Text('Max: Ksh ${_currentMaxPrice.toStringAsFixed(2)}'),
      ],
    );
  }
}
