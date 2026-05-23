import 'package:flutter/material.dart';

class CharacterCounter extends StatelessWidget {
  final int currentLength;
  final int maxLength;

  const CharacterCounter({
    required this.currentLength,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currentLength/$maxLength',
      style: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }
}
