import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final bool opacity;
  const ProgressWidget({
    this.opacity = true,
    required this.child,
    required this.inAsyncCall,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: inAsyncCall,
      blurEffectIntensity: 8,
      progressIndicator: const CircularProgressIndicator(),
      opacity: opacity ? 0.3 : 1.0,
      color: Colors.white,
      child: child,
    );
  }
}
