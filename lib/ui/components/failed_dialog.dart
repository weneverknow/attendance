import 'package:flutter/material.dart';

import '../../constants.dart';
import 'general_dialog.dart';

class FailedDialog extends GeneralDialog {
  FailedDialog(this.context);
  final BuildContext context;

  show() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffE45959)),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/failed-alert.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    title ?? 'Failed',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Flexible(
                      child: Text(
                    subTitle ?? 'Something went wrong',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                  )),
                  const SizedBox(
                    height: defaultPadding * 1.5,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffE45959),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding / 2)),
                        onPressed: okPressed,
                        child: Text('Ok')),
                  )
                ],
              ),
            ),
          );
        });
  }
}
