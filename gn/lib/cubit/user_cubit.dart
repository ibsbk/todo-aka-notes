import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/note_state.dart';
import 'package:gn/cubit/user_state.dart';
import 'package:gn/mod/Note.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/serv/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';


class UserCubit extends Cubit<UserState>{
  final UserRepository userRepository;
  final HTTPRequests requests = new HTTPRequests();
  final GoogleAuth googleSign = new GoogleAuth();

  UserCubit(this.userRepository) : super(UserEmptyState());

  Future<void> fetchUser() async{
    emit(UserLoadingState());
    // print(googleSign.googleSignIn.currentUser);
    await googleSign.googleLogin();
    print(googleSign.googleSignIn.currentUser);
    if (googleSign.googleSignIn.currentUser != null) {
      print(googleSign.googleSignIn.currentUser);
      final _loadedUser = await requests.getUserId(googleSign.googleSignIn.currentUser);
      emit(UserLoadedState(loadedUser: _loadedUser.body));
      print(_loadedUser.body);
    }
  }
}