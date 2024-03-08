import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/values.dart';

class CustomIndicator extends StatelessWidget {
  final bool simple;
  final String label;
  const CustomIndicator({
    super.key,
    this.label = "로딩 중",
    this.simple = false
  });

  @override
  Widget build(BuildContext context) {
    if(simple) {
      return Center(
        child: CupertinoActivityIndicator(
          animating: true,
          color: Theme.of(context).colorScheme.primary
        )
      );
    } else {
      return Center(
          child: Material(
              borderRadius: BorderRadius.circular(CustomRadius.corner.radius),
              elevation: 10,
              child: Container(
                  height: 56,
                  padding: EdgeInsets.all(Spacing.small.size),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(CustomRadius.corner.radius)
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(
                            color: Theme.of(context).colorScheme.primary
                        ),
                        VerticalDivider(
                            width: Spacing.medium.size,
                            color: Colors.transparent
                        ),
                        Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1,
                              fontSize: CustomFont.caption.size,
                            )
                        )
                      ]
                  )
              )
          )
      );
    }
  }
}
