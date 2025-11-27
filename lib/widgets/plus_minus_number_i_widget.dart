import 'package:flutter/material.dart';

class NumberInput extends StatefulWidget {
  final int initialValue;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const NumberInput({
    Key? key,
    this.initialValue = 1,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(widget.min, widget.max);
  }

  void _increment() {
    if (_value < widget.max) {
      setState(() => _value++);
      widget.onChanged(_value);
    }
  }

  void _decrement() {
    if (_value > widget.min) {
      setState(() => _value--);
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: const Icon(Icons.remove), onPressed: _decrement),
        Text('$_value', style: const TextStyle(fontSize: 18)),
        IconButton(icon: const Icon(Icons.add), onPressed: _increment),
      ],
    );
  }
}
