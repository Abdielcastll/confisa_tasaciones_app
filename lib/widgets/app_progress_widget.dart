import 'package:flutter/material.dart';

import '../theme/theme.dart';

class LineProgressWidget extends StatelessWidget {
  const LineProgressWidget({
    Key? key,
    required this.currentItem,
    required this.totalItem,
  }) : super(key: key);

  final int totalItem;
  final int currentItem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.center,
          height: 50,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            color: AppColors.brownDark,
            height: 2,
            width: MediaQuery.of(context).size.width * .95,
          ),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  totalItem,
                  (i) => ClipOval(
                        child: Container(
                          child: Center(
                              child: Text(
                            (i + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                          height: 30,
                          width: 30,
                          color: currentItem == i + 1
                              ? AppColors.gold
                              : AppColors.brownDark,
                        ),
                      )),
            ),
          ),
        )
      ],
    );
  }
}
