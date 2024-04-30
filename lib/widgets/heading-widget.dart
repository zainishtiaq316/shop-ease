import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopease/utils/app-constant.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headSubTitle;
  final VoidCallback onTap;
  final String buttonText;
  const HeadingWidget({super.key, required this.buttonText, required this.headSubTitle, required this.headingTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                ),
                Text(
                  headSubTitle,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
            GestureDetector(
              onTap : onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: AppConstant.appSecondaryColor, width: 1.5), ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(buttonText, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0, color: AppConstant.appSecondaryColor),),
                        ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
