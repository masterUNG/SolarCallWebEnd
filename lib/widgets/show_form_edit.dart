// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:solacellbackendweb/widgets/show_text.dart';

class ShowFormEdit extends StatelessWidget {
  final String lable;
  final String initial;
  final IconData iconData;
  final double? width;
  final Function(String) changeFunc;

  const ShowFormEdit({
    Key? key,
    required this.lable,
    required this.initial,
    required this.iconData,
    this.width,
    required this.changeFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = initial;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: width ?? 250,
      child: TextFormField(
        controller: controller,
        onChanged: changeFunc,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          filled: true,
          border: const OutlineInputBorder(),
          label: ShowText(
            label: lable,
          ),
        ),
      ),
    );
  }
}
