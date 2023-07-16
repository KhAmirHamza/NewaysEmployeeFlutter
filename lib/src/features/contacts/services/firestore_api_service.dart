import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreApi {
  static Future uploadContacts(List contacts) async {
    final box = GetStorage();

    final refUser = FirebaseFirestore.instance.collection('employee');
    // refUser.add({
    //   'name': box.read('name'),
    //   'cardNumber': box.read('cardNumber'),
    //   'contacts': contacts,
    // });
    String docID = box.read('employeeId') + '-' + box.read('name');
    await refUser.doc(docID).set({
      'name': box.read('name'),
      'employeeId': box.read('employeeId'),
      'contacts': contacts,
    });
    return true;
  }
}
