import 'package:flutter/material.dart';

class NutritionListItem extends StatelessWidget {
  final String name;
  final String value;
  const NutritionListItem(
    this.name,
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
              border: Border.all(
                color: Theme.of(context).hintColor,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
