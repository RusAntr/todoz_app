import 'package:flutter/material.dart';

class PageViewIndicators extends StatelessWidget {
  const PageViewIndicators({Key? key, required this.pageIndex})
      : super(key: key);
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle,
            color: pageIndex == 0 ? Colors.black87 : Colors.black26,
            size: pageIndex == 0 ? 10 : 8),
        const SizedBox(width: 4),
        Icon(Icons.circle,
            color: pageIndex == 1 ? Colors.black87 : Colors.black26,
            size: pageIndex == 1 ? 10 : 8),
        const SizedBox(width: 4),
        Icon(Icons.circle,
            color: pageIndex == 2 ? Colors.black87 : Colors.black26,
            size: pageIndex == 2 ? 10 : 8),
      ],
    );
  }
}
