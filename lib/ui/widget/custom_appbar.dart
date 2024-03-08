import 'package:flutter/material.dart';

import '../../constant/values.dart';

class CustomAppBar extends StatefulWidget {
  final Widget child;
  final String middle;
  final double spacing;
  final Widget? trailing;
  final Widget? spare;
  final bool showDivider;
  final bool scrollable;

  const CustomAppBar({super.key,
    required this.child,
    required this.middle,
    this.spacing = 56,
    this.trailing,
    this.spare,
    this.showDivider = false,
    this.scrollable = true
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final scrollController = ScrollController();
  final double height = 42;
  late final double spacing;
  bool collapsed = false;
  double offset = 0;

  @override
  void initState() {
    super.initState();
    spacing = widget.spacing;
    scrollController.addListener(() {
      setState(() {
        if(scrollController.hasClients) {
          offset = scrollController.offset;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  getOpacity() {
    if(offset < spacing) {
      return 0.0;
    } else if(offset < spacing * 2) {
      return (offset / spacing) - 1;
    } else {
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.scrollable) {
      return getScrollWidget();
    } else {
      return getWidget();
    }
  }

  getScrollWidget() {
    return Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.only(
              left: Spacing.large.size,
              right: Spacing.large.size
          ),
          child: scrollContentView()
      ),
      Opacity(
          opacity: getOpacity(),
          child: Container(
              height: height,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  top: Spacing.tiny.size,
                  bottom: Spacing.tiny.size,
                  left: Spacing.medium.size,
                  right: Spacing.medium.size
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background.withOpacity(0.95),
                  border: Border(
                      bottom: BorderSide(
                          color: (offset > spacing)?
                          Theme.of(context).colorScheme.outlineVariant:
                          Colors.transparent,
                          width: 1
                      )
                  )
              ),
              child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "BookLet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                                fontFamily: "COOKIE",
                                height: 1
                            )
                        )
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.middle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: getTrailing(),
                    )
                  ]
              )
          )
      )
    ]);
  }

  getTrailing() {
    if(widget.trailing == null) {
      return Material(
        borderRadius: BorderRadius.circular(CustomRadius.circle.radius),
        child: InkWell(
            borderRadius: BorderRadius.circular(CustomRadius.circle.radius),
            child: Icon(
                Icons.arrow_upward_rounded,
                size: 24,
                color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () => scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linearToEaseOut)
        )
      );
    } else {
      return widget.trailing;
    }
  }

  scrollContentView() {
    return ListView(
        shrinkWrap: true,
        controller: scrollController,
        children: [
          Container(
              height: spacing,
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: height),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        widget.middle,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            height: 1
                        )
                    ),
                    (widget.spare == null)?const SizedBox(width: 0, height: 0):widget.spare!
                  ]
              )
          ),
          (widget.showDivider)?const Divider(height: 16):Container(),
          widget.child
        ]
    );
  }

  getWidget() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: Spacing.large.size,
          right: Spacing.large.size,
        ),
        child: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                  height: spacing,
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(top: height),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            widget.middle,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                height: 1
                            )
                        ),
                        (widget.spare == null)?const SizedBox(width: 0, height: 0):widget.spare!
                      ]
                  )
              ),
              Divider(height: 12, color: (widget.showDivider)?null:Colors.transparent),
              Expanded(child: widget.child)
            ]
        )
    );
  }
}
