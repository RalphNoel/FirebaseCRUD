 import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore? firestore;
  initialise(){
    firestore = FirebaseFirestore.instance;
  }

  void create(String todoName)async{
    try{
      await firestore!.collection('name').add({'todoname' : todoName,'timestamp': FieldValue.serverTimestamp()});
    }catch(e){
      print(e);
    }
  }

  Future<List?> read() async{
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
      await firestore!.collection('name').orderBy('timestamp').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {"id": doc.id, "todoname": doc['todoname']};
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async{
    try{
      await firestore!.collection('name').doc(id.toString()).delete();
    } catch(e){
      print(e);
    }
  }

  Future<void> update(String id, String name) async {
    try{
      await firestore!.collection('name').doc(id).update({'todoname': name});
    }catch(e){
      print(e);
    }
  }
 }