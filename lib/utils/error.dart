import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class ErrorUtils {
  // General Methods:-----------------------------------------------------------
  static showErrorMessage(BuildContext context, String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: 'Error',
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
