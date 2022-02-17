import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/user_state.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/serv/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  final HTTPRequests requests = new HTTPRequests();
  final GoogleAuth googleSign = new GoogleAuth();

  UserCubit(this.userRepository) : super(UserEmptyState());

  void fetchUser() async {
    emit(UserLoadingState());
    await googleSign.googleLogin();
    if (googleSign.googleSignIn.currentUser != null) {
      try {
        print(googleSign.googleSignIn.currentUser);
        final _loadedUser =
            await requests.auth(googleSign.googleSignIn.currentUser);
        emit(UserLoadedState(loadedUser: _loadedUser));
      } catch (e) {
        emit(UserErrorState());
      }
    } else {
      emit(UserErrorState());
    }
  }
}
