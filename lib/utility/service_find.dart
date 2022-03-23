import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ServiceFind {
  
  String findDate(Timestamp mainten) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy');
    String string = dateFormat.format(mainten.toDate());
    return string;
  }



}