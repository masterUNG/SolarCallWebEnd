// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:solacellbackendweb/utility/my_constant.dart';
import 'package:solacellbackendweb/widgets/show_logo.dart';
import 'package:solacellbackendweb/widgets/show_text.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  Future<void> normalDialog(
      {required String title, required String message}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: const ShowLogo(),
          title: ShowText(
            label: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(label: message),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  Future<void> actionDialog({
    required String title,
    required String message,
    required String labePressFunc,
    required Function() pressFunc,
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading:  const ShowLogo(),
          title: ShowText(
            label: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(label: message),
        ),
        actions: [
          TextButton(onPressed: pressFunc, child: Text(labePressFunc)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
