import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

abstract class Dialogs {
  static alert(
    BuildContext context, {
    required String tittle,
    required List<String> description,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tittle.toUpperCase(),
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
              ),
              ...description
                  .map((e) => Text(
                        e,
                        style: Theme.of(context).textTheme.headline6,
                      ))
                  .toList(),
              const SizedBox(height: 15),
              MaterialButton(
                onPressed: () => Navigator.pop(_),
                child: const Text('ACEPTAR'),
                color: AppColors.orange,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*abstract class ProgressDialog {
  static show(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.brownDark),
              ),
            ),
          );
        });
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}*/
