// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:solacellbackendweb/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String lable;
  final IconData iconData;
  final Function(String) changeFunc;
  final bool? obsecu;
  final double? width;
  const ShowForm({
    Key? key,
    required this.lable,
    required this.iconData,
    required this.changeFunc,
    this.obsecu,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: width ?? 250,
      child: TextFormField(
        obscureText: obsecu ?? false,
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
