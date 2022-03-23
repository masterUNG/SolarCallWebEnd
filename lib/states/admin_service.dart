import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solacellbackendweb/models/site_model.dart';
import 'package:solacellbackendweb/states/add_new_site.dart';
import 'package:solacellbackendweb/states/editsite.dart';
import 'package:solacellbackendweb/states/home.dart';
import 'package:solacellbackendweb/utility/my_constant.dart';
import 'package:solacellbackendweb/utility/service_find.dart';
import 'package:solacellbackendweb/widgets/show_button.dart';
import 'package:solacellbackendweb/widgets/show_logo.dart';
import 'package:solacellbackendweb/widgets/show_progress.dart';
import 'package:solacellbackendweb/widgets/show_text.dart';
import 'package:solacellbackendweb/widgets/show_title.dart';

class AdminService extends StatefulWidget {
  const AdminService({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminService> createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  bool load = true;
  var siteModels = <SiteModel>[];
  var idSites = <String>[];

  @override
  void initState() {
    super.initState();
    readAllSite();
  }

  Future<void> readAllSite() async {
    if (siteModels.isNotEmpty) {
      siteModels.clear();
      idSites.clear();
      load = true;
      setState(() {});
    }
    await FirebaseFirestore.instance.collection('site').get().then((value) {
      load = false;
      for (var item in value.docs) {
        SiteModel siteModel = SiteModel.fromMap(item.data());
        siteModels.add(siteModel);
        idSites.add(item.id);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MyConstant.dark,
        actions: [
          ShowButton(
              label: 'Add New Site',
              pressFunc: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewSite(),
                    ),
                    (route) => false);
              }),
          const SizedBox(
            width: 32,
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                      (route) => false));
            },
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Logout',
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: load
          ? const ShowProgress()
          : ListView.builder(
              itemCount: siteModels.length,
              itemBuilder: (context, index) => Card(
                color: index % 2 == 0 ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShowText(
                            label: siteModels[index].name,
                            textStyle: MyConstant().h2Style(),
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Edit Site',
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSite(
                                      siteModel: siteModels[index],
                                      siteId: idSites[index],
                                    ),
                                  ),
                                ).then((value) {
                                  siteModels.clear();
                                  idSites.clear();
                                  readAllSite();
                                }),
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Delete Site',
                                onPressed: () async {
                                  String docIdDelete = idSites[index];
                                  print('docIdDelete ==> $docIdDelete');
                                  dialogConfirmDelete(
                                      siteModels[index], docIdDelete);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ShowTitle(title: 'Site ID :', detail: idSites[index]),
                      ShowTitle(
                        title: 'apiKey :',
                        detail: siteModels[index].apiKey,
                      ),
                      ShowTitle(
                          title: 'pinCode :',
                          detail: siteModels[index].pinCode),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShowTitle(
                            title: 'Mainten 1 :',
                            detail: ServiceFind()
                                .findDate(siteModels[index].mainten1),
                          ),
                          ShowTitle(
                            title: 'Mainten 2 :',
                            detail: ServiceFind()
                                .findDate(siteModels[index].mainten2),
                          ),
                          ShowTitle(
                            title: 'Mainten 3 :',
                            detail: ServiceFind()
                                .findDate(siteModels[index].mainten3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> dialogConfirmDelete(
      SiteModel siteModel, String docIdDelete) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: ListTile(
          leading: const ShowLogo(),
          title: ShowText(
            label: 'Confirm Delete ${siteModel.name}',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('site')
                    .doc(docIdDelete)
                    .delete()
                    .then((value) {
                  Navigator.pop(context);
                  readAllSite();
                });
              },
              child: ShowText(
                label: 'Delete',
                textStyle: MyConstant().h3GreenStyle(),
              )),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: ShowText(
                label: 'Cancel',
                textStyle: MyConstant().h3RedStyle(),
              )),
        ],
      ),
    );
  }
}
