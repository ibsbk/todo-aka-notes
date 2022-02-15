import 'package:gn/mod/User.dart';
import 'package:http/http.dart';

abstract class UserState{}

class UserEmptyState extends UserState{}

class UserLoadingState extends UserState{}

class UserLoadedState extends UserState{
  String loadedUser;
  UserLoadedState({required this.loadedUser});
}

class UserErrorState extends UserState{}