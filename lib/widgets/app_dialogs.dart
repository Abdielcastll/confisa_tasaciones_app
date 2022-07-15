import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasaciones_app/theme/theme.dart';

import 'app_buttons.dart';

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

  static confirm(
    BuildContext context, {
    required String tittle,
    required String description,
    required Function confirm,
  }) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 2,
                    color: AppColors.orange,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      alignment: Alignment.center,
                      color: AppColors.orange,
                      child: Text(
                        tittle.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 25),
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppButton(
                            text: 'NO',
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: AppColors.orange),
                        AppButton(
                            text: 'SI',
                            onPressed: () {
                              Navigator.pop(_);
                              confirm();
                            },
                            color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ));
  }
}

abstract class ProgressDialog {
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
}
