import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/user_state.dart';
import 'package:gn/mod/User.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/data/user_repository.dart';
import 'package:http/http.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  final HTTPRequests requests = new HTTPRequests();
  final GoogleAuth googleSign = new GoogleAuth();

  UserCubit(this.userRepository) : super(UserEmptyState());

  void fetchUser() async {
    emit(UserLoadingState());
    try {
      final Response _loadedUser = await userRepository.getUser();
      if(_loadedUser.statusCode == 200){
        var userMap = jsonDecode(_loadedUser.body)[0];
        User user = new User();
        print(userMap.runtimeType);
        user = User.fromJson(userMap);
        print(11111);
        await requests.auth(user);
        emit(UserLoadedState(loadedUser: _loadedUser));
      } else{
        emit(UserErrorState());
      }
    } catch (e) {
      print(e);
      emit(UserErrorState());
    }
  }
}
