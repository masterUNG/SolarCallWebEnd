// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:solacellbackendweb/utility/my_constant.dart';
import 'package:solacellbackendweb/widgets/show_text.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  final String detail;
  final double? widthSizebox;
  const ShowTitle({
    Key? key,
    required this.title,
    required this.detail,
    this.widthSizebox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShowText(
          label: title,
        ),
        SizedBox(
          width: widthSizebox ?? 60,
        ),
        ShowText(
          label: detail,
          textStyle: MyConstant().h3GreenStyle(),
        )
      ],
    );
  }
}
