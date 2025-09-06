import 'package:flutter/material.dart';
import "package:auto_size_text/auto_size_text.dart";

class StatsSummaryTile extends StatelessWidget {
  final String caption;
  final dynamic count;
  final IconData? floatingIcon;

  const StatsSummaryTile({ super.key, required this.count, required this.caption, this.floatingIcon });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: floatingIcon != null 
            ? Opacity(
              opacity: 0.1,
              child: Icon(
                floatingIcon, 
                size: 120.0
              ),
            ) 
            : SizedBox()
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: AutoSizeText(
                  count.toString(), 
                  minFontSize: 50.0,
                ),
              ),
          
              AutoSizeText(
                caption, 
                stepGranularity: 1.25,
                minFontSize: 12.5,
                maxFontSize: 15.0,
                maxLines: 3
              )
            ],
          ),
        ],
      )
    );
  }
}