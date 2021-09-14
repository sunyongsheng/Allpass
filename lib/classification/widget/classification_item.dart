import 'package:flutter/material.dart';

class ClassificationItem extends StatelessWidget {

  final Key? key;
  final String title;
  final Color color;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;

  ClassificationItem({this.key,
    required this.title,
    this.color = Colors.redAccent,
    this.onPress,
    this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      onLongPress: onLongPress,
      child: Card(
        elevation: 0,
        color: color,
        child: Center(
          child: Text(title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }}