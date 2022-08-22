import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';

class BaseFormWidget extends StatelessWidget {
  const BaseFormWidget({
    required this.child,
    required this.titleHeader,
    required this.iconHeader,
    required this.labelNext,
    required this.iconNext,
    required this.onPressedNext,
    required this.labelBack,
    required this.iconBack,
    required this.onPressedBack,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final String titleHeader;
  final String labelNext;
  final String labelBack;
  final IconData iconHeader;
  final IconData iconNext;
  final IconData iconBack;
  final void Function()? onPressedNext;
  final void Function()? onPressedBack;

  @override
  Widget build(BuildContext context) {
    final heightAppbar = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.brownDark, width: 1.5)),
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - heightAppbar,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: AppColors.brownDark,
              child: Row(
                children: [
                  Icon(
                    iconHeader,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    titleHeader,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(child: child)),
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: onPressedBack, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          iconBack,
                          // color: Colors.red,
                          size: 30,
                        ),
                        const SizedBox(
                          height: 3,
                        ), // icon
                        Text(labelBack), // text
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: onPressedNext, // button pressed
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          iconNext,
                          // color: AppColors.green,
                          size: 30,
                        ),
                        const SizedBox(
                          height: 3,
                        ), // icon
                        Text(labelNext), // text
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
