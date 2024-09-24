import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProductProgressIndicator extends StatelessWidget {
  final DateTime addedDate;
  final DateTime expiryDate;

  ProductProgressIndicator({required this.addedDate, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    final totalDuration = expiryDate.difference(addedDate).inDays;
    final remainingDuration = expiryDate.difference(DateTime.now()).inDays;
    final progress = (totalDuration - remainingDuration) / totalDuration;

    Color getColor() {
      if (progress <= 0.5) {
        return Colors.green;
      } else if (progress > 0.5 && progress <= 0.75) {
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }

    return CircularPercentIndicator(
      radius: 20.0,
      lineWidth: 5.0,
      percent: progress,
      center: Text(
        '${(progress * 100).toInt()}%',
        style: TextStyle(fontSize: 10.0),
      ),
      progressColor: getColor(),
    );
  }
}
