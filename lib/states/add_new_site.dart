import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solacellbackendweb/models/site_model.dart';
import 'package:solacellbackendweb/states/admin_service.dart';
import 'package:solacellbackendweb/utility/my_constant.dart';
import 'package:solacellbackendweb/utility/my_dialog.dart';
import 'package:solacellbackendweb/widgets/show_button.dart';
import 'package:solacellbackendweb/widgets/show_form.dart';
import 'package:solacellbackendweb/widgets/show_title.dart';

class AddNewSite extends StatefulWidget {
  const AddNewSite({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewSite> createState() => _AddNewSiteState();
}

class _AddNewSiteState extends State<AddNewSite> {
  String? siteName, siteID, pinCode, apiKey;
  Timestamp? mainten1, mainten2, mainten3;
  DateTime datetime = DateTime.now();
  String mainten1Str = 'dd MMM yyyy';
  String mainten2Str = 'dd MMM yyyy';
  String mainten3Str = 'dd MMM yyyy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminService(),
                ),
                (route) => false),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
        title: const Text('Add New Site'),
        actions: [
          ShowButton(
              label: 'Add New Site',
              pressFunc: () {
                if ((siteName?.isEmpty ?? true) ||
                    (siteID?.isEmpty ?? true) ||
                    (pinCode?.isEmpty ?? true) ||
                    (apiKey?.isEmpty ?? true)) {
                  MyDialog(context: context).normalDialog(
                      title: 'Have Space ?',
                      message: 'Please Fill Everyt Blank');
                } else if (pinCode!.length != 6) {
                  MyDialog(context: context).normalDialog(
                      title: 'pinCode False ?',
                      message: 'pinCode Mush 6 Gigit');
                } else if ((mainten1 == null) ||
                    (mainten2 == null) ||
                    (mainten3 == null)) {
                  MyDialog(context: context).normalDialog(
                      title: 'Mainten False ?',
                      message: 'Please Choose DateTime on Mainten');
                } else {
                  processInsertSite();
                }
              }),
          const SizedBox(
            width: 32,
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ShowForm(
                  width: constraints.maxWidth * 0.75,
                  lable: 'Site Name :',
                  iconData: Icons.fingerprint,
                  changeFunc: (String string) => siteName = string.trim()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowForm(
                      lable: 'Site ID :',
                      iconData: Icons.code,
                      changeFunc: (String string) => siteID = string.trim()),
                  const SizedBox(
                    width: 16,
                  ),
                  ShowForm(
                      lable: 'pinCode :',
                      iconData: Icons.pin,
                      changeFunc: (String string) => pinCode = string.trim()),
                ],
              ),
              ShowForm(
                  width: constraints.maxWidth * 0.75,
                  lable: 'apiKey :',
                  iconData: Icons.key_outlined,
                  changeFunc: (String string) => apiKey = string.trim()),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: MyConstant().box1Style(),
                      width: constraints.maxWidth * 0.3,
                      child: ListTile(
                        title: ShowTitle(
                          widthSizebox: 4,
                          title: 'Mainten1',
                          detail: mainten1Str,
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: datetime,
                                      firstDate: DateTime(datetime.year - 1),
                                      lastDate: DateTime(datetime.year + 1))
                                  .then((value) {
                                mainten1 = Timestamp.fromDate(value!);
                                DateFormat dateFormat =
                                    DateFormat('dd MMM yyyy');
                                setState(() {
                                  mainten1Str = dateFormat.format(value);
                                });
                              });
                            },
                            icon: const Icon(Icons.calendar_month)),
                      ),
                    ),
                    Container(
                      decoration: MyConstant().box1Style(),
                      width: constraints.maxWidth * 0.3,
                      child: ListTile(
                        title: ShowTitle(
                          widthSizebox: 4,
                          title: 'Mainten2',
                          detail: mainten2Str,
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: datetime,
                                      firstDate: DateTime(datetime.year - 1),
                                      lastDate: DateTime(datetime.year + 1))
                                  .then((value) {
                                mainten2 = Timestamp.fromDate(value!);
                                DateFormat dateFormat =
                                    DateFormat('dd MMM yyyy');
                                setState(() {
                                  mainten2Str = dateFormat.format(value);
                                });
                              });
                            },
                            icon: const Icon(Icons.calendar_month)),
                      ),
                    ),
                    Container(
                      decoration: MyConstant().box1Style(),
                      width: constraints.maxWidth * 0.3,
                      child: ListTile(
                        title: ShowTitle(
                          widthSizebox: 4,
                          title: 'Mainten3',
                          detail: mainten3Str,
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: datetime,
                                      firstDate: DateTime(datetime.year - 1),
                                      lastDate: DateTime(datetime.year + 1))
                                  .then((value) {
                                mainten3 = Timestamp.fromDate(value!);
                                DateFormat dateFormat =
                                    DateFormat('dd MMM yyyy');
                                setState(() {
                                  mainten3Str = dateFormat.format(value);
                                });
                              });
                            },
                            icon: const Icon(Icons.calendar_month)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> checkSiteIDandApiKey() async {
    String pathAPI =
        'https://monitoringapi.solaredge.com/site/$siteID/details?api_key=$apiKey';

    String pathTest = 'https://www.google.com/';

    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    await dio.get(pathTest).then((value) {}).catchError(
        (onError) => print('error on dio ==> ${onError.toString()}'));
  }

  Future<void> processInsertSite() async {
    SiteModel siteModel = SiteModel(
        apiKey: apiKey!,
        mainten1: mainten1!,
        mainten2: mainten2!,
        mainten3: mainten3!,
        name: siteName!,
        pinCode: pinCode!);

    await FirebaseFirestore.instance
        .collection('site')
        .doc(siteID)
        .set(siteModel.toMap())
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminService(),
            ),
            (route) => false))
        // ignore: invalid_return_type_for_catch_error
        .catchError((onError) => MyDialog(context: context).normalDialog(
            title: 'Cannot Add New Site', message: 'Please Try Again'));
  }
}
