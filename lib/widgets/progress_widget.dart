import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/theme.dart';

class ProgressWidget extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  const ProgressWidget({
    required this.child,
    required this.inAsyncCall,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: inAsyncCall,
      blurEffectIntensity: 8,
      progressIndicator: const SpinKitFadingCircle(
        color: AppColors.brownDark,
        size: 90.0,
      ),
      opacity: 0.3,
      color: Colors.white,
      child: child,
    );
  }
}
