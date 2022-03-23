// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:solacellbackendweb/models/site_model.dart';
import 'package:solacellbackendweb/utility/my_constant.dart';
import 'package:solacellbackendweb/utility/my_dialog.dart';
import 'package:solacellbackendweb/utility/service_find.dart';
import 'package:solacellbackendweb/widgets/show_button.dart';
import 'package:solacellbackendweb/widgets/show_form_edit.dart';
import 'package:solacellbackendweb/widgets/show_title.dart';

class EditSite extends StatefulWidget {
  final SiteModel siteModel;
  final String siteId;
  const EditSite({
    Key? key,
    required this.siteModel,
    required this.siteId,
  }) : super(key: key);

  @override
  State<EditSite> createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
  SiteModel? siteModel;
  String? siteId;
  bool change = false;

  @override
  void initState() {
    super.initState();
    siteModel = widget.siteModel;
    siteId = widget.siteId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SiteID : $siteId'),
        elevation: 0,
        foregroundColor: MyConstant.dark,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShowFormEdit(
                  lable: 'Name :',
                  iconData: Icons.fingerprint,
                  changeFunc: (String string) {
                    change = true;
                    addValueToMap(keyMap: 'name', valueMap: string.trim());
                  },
                  initial: siteModel!.name,
                ),
                ShowFormEdit(
                  lable: 'PinCode :',
                  initial: siteModel!.pinCode,
                  iconData: Icons.pin,
                  changeFunc: (String string) {
                    change = true;
                    addValueToMap(keyMap: 'pinCode', valueMap: string.trim());
                  },
                ),
              ],
            ),
            ShowFormEdit(
              width: 500,
              lable: 'apiKey :',
              initial: siteModel!.apiKey,
              iconData: Icons.key,
              changeFunc: (String string) {
                change = true;
                addValueToMap(keyMap: 'apiKey', valueMap: string.trim());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  decoration: MyConstant().box1Style(),
                  width: constraints.maxWidth * 0.3,
                  child: ListTile(
                    title: ShowTitle(
                      title: 'Mainten 1',
                      detail: ServiceFind().findDate(siteModel!.mainten1),
                      widthSizebox: 4,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          chooseNewDate(siteModel!.mainten1, 'mainten1');
                        },
                        icon: const Icon(Icons.calendar_month_outlined)),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  decoration: MyConstant().box1Style(),
                  width: constraints.maxWidth * 0.3,
                  child: ListTile(
                    title: ShowTitle(
                      title: 'Mainten 2',
                      detail: ServiceFind().findDate(siteModel!.mainten2),
                      widthSizebox: 4,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          chooseNewDate(siteModel!.mainten2, 'mainten2');
                        },
                        icon: const Icon(Icons.calendar_month_outlined)),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  decoration: MyConstant().box1Style(),
                  width: constraints.maxWidth * 0.3,
                  child: ListTile(
                    title: ShowTitle(
                      title: 'Mainten 3',
                      detail: ServiceFind().findDate(siteModel!.mainten3),
                      widthSizebox: 4,
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          chooseNewDate(siteModel!.mainten3, 'mainten3');
                        },
                        icon: const Icon(Icons.calendar_month_outlined)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShowButton(
                  label: 'Edit Data',
                  pressFunc: () async {
                    if (change) {
                      if (siteModel!.pinCode.length == 6) {
                        await FirebaseFirestore.instance
                            .collection('site')
                            .doc(siteId)
                            .update(siteModel!.toMap())
                            .then((value) => Navigator.pop(context));
                      } else {
                        MyDialog(context: context).normalDialog(
                            title: 'PinCode False ?',
                            message: 'PinCode mush be 6 digit');
                      }
                    } else {
                      MyDialog(context: context).normalDialog(
                          title: 'Not Change ?',
                          message: 'Please Change SomeThing for Edit');
                    }
                  },
                ),
                const SizedBox(
                  width: 64,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Future<void> chooseNewDate(Timestamp timestamp, String keyFirebase) async {
    DateTime dateTime =
        DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);

    await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(dateTime.year - 1),
            lastDate: DateTime(dateTime.year + 1))
        .then((value) {
      DateTime? newDateTime = value;
      print('newDateTime ==>> $newDateTime');
      if (newDateTime != null) {
        change = true;
        Map<String, dynamic> map = siteModel!.toMap();
        map[keyFirebase] = Timestamp.fromDate(newDateTime);
        siteModel = SiteModel.fromMap(map);
      }
      setState(() {});
    });
  }

  void addValueToMap({required String keyMap, required String valueMap}) {
    Map<String, dynamic> map = siteModel!.toMap();
    map[keyMap] = valueMap;
    siteModel = SiteModel.fromMap(map);
  }
}
