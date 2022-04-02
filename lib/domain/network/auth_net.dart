import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hashmicro/domain/models/user_m.dart';
import 'package:hashmicro/domain/repositories/auth_repo.dart';
import '../../utils/app_dialog.dart';

class AuthNet extends AuthRepo {
  @override
  Future<UserM?> getInfoUser(String uid) async {
    try {
      final response =
          await FirebaseFirestore.instance.collection("/users").doc(uid).get();

      final responseJson = response.data() as Map<String, dynamic>;
      return UserM.fromJson(responseJson);
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    }
  }

  @override
  Future<String?> signin(String email, password) async {
    try {
      final res = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password!);
      return res.user!.uid;
    } on FirebaseAuthException catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return null;
    }
  }
}
