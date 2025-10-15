import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/color_scheme.dart';
// Adjust this import to match your project structure if needed


class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onOk;

  const SuccessDialog({Key? key, required this.message, this.onOk}) : super(key: key);

  /// Convenience method to display the dialog
  static Future<void> show(BuildContext context, String message, {VoidCallback? onOk}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SuccessDialog(message: message, onOk: onOk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.check_circle,
        color: AppColorScheme.successColor,
        size: 64.sp,
      ),
      title: const Text('SOS Alert Sent'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onOk != null) onOk!();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
