import '../models/user_m.dart';

abstract class AuthRepo {
  Future<String?> signin(String email, password);

  Future<UserM?> getInfoUser(String uid);
}
