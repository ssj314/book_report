import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../constant/values.dart';
import '../../../data/model/paper_model.dart';

class SocialPaperView extends StatelessWidget {
  const SocialPaperView({super.key,
    required this.itemWidth,
    required this.itemHeight,
    required this.papers
  });
  final double itemWidth;
  final double itemHeight;
  final List<Paper> papers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: itemHeight,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => VerticalDivider(
              color: Colors.transparent,
              width: Spacing.small.size,
            ),
            itemCount: papers.length,
            itemBuilder: (context, index) => PaperWidget(
                index: index,
                itemWidth: itemWidth,
                itemHeight: itemHeight,
                paper: papers[index],
            )
        )
    );
  }
}

class PaperWidget extends StatelessWidget {
  const PaperWidget({
    super.key,
    required this.index,
    required this.itemWidth,
    required this.itemHeight,
    required this.paper
  });
  final int index;
  final double itemWidth;
  final double itemHeight;
  final Paper paper;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: itemWidth,
        height: itemHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CustomRadius.small.radius),
            color: Theme.of(context).colorScheme.primaryContainer
        ),
        padding: EdgeInsets.all(Spacing.small.size),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paper.content.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  //color: Colors.black,
                    fontSize: CustomFont.caption.size,
                    fontWeight: FontWeight.bold
                ),
              ),
              Divider(height: Spacing.small.size, color: Colors.transparent),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("p.${paper.pageStart} - p.${paper.pageEnd}",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 1.0, fontSize: CustomFont.small.size),
                  ),
                  getTime(paper.lastDate)
                ],
              )
            ]
        )

    );
  }

  getTime(String lastEdit) {
    String subTime() {
      final last = DateFormat('yy/MM/dd HH:mm:ss').parse(lastEdit);
      return DateFormat('yyyy년 MM월 dd일').format(last);
    }

    return Text(
        subTime(),
        textAlign: TextAlign.center,
        style: TextStyle(
            height: 1.0,
            fontSize: CustomFont.small.size
        )
    );
  }
}
