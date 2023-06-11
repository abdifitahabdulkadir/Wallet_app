import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// managing either if we are in login mode or register mode
final loginRegisterProvider = StateProvider<bool>((ref) => true);

// returing globally instance of FirebasStorage
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

// returing globally instance of firebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// returing globollary instance of cloud_firestore for storing metadata of users
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((Ref) {
  return FirebaseFirestore.instance;
});

// returing globlly the state of isAuthenticating variable for either waiting
// going forward for the operation
final isAuthenticatingProvider = StateProvider<bool>((ref) => false);

// default avator link for user profile incase he did not pick or import any image
// from his device
final defualtImagelinkProvider = StateProvider<String>((ref) =>
    "https://tse3.mm.bing.net/th?id=OIP.i10J5__vNB1o5w_3j38K3AHaEc&pid=Api&P=0&h=180");

/*
* this is the stateProvider that trucks and decides weathers added cars has to filter 
* based on category or not then simply othersize dispaly all avaialble cards 
*/

final addedCardsFilterProvider = StateProvider<String>((ref) => "");
