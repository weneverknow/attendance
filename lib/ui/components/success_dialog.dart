import '../../constants.dart';
import 'general_dialog.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends GeneralDialog {
  final BuildContext context;
  SuccessDialog(this.context) {
    title = 'Selamat';
    subTitle = "Transaksi berhasil disimpan.";
  }

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
                          shape: BoxShape.circle, color: Color(0xff25AE88)),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    title ?? "Congratulation",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Text(
                        subTitle ?? 'Something went wrong',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300),
                      )),
                  const SizedBox(
                    height: defaultPadding * 1.5,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff25AE88),
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
