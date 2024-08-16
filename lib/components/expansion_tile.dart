import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

class MyExpansion extends StatelessWidget {
  const MyExpansion({
    super.key,
    required this.content,
    required this.title,
  });
  final Widget content;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
        initiallyExpanded: false,
        titleBuilder:
            (double animationValue, _, bool isExpaned, toogleFunction) {
          return InkWell(
              onTap: () => toogleFunction(animated: true),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.rotate(
                      angle: 3.14 * animationValue / 2,
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_right, size: 40),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ));
        },
        content: content);
  }
}
