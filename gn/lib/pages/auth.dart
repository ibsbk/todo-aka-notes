import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/user_cubit.dart';
import 'package:gn/cubit/user_state.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/user_repository.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

HTTPRequests request = new HTTPRequests();

// void auth(context) async {
//   final googleAccount = new GoogleAuth();
//   await googleAccount.googleLogin();
//
//   if (googleAccount.googleSignIn.currentUser != null) {
//     // request.auth(context, googleAccount.googleSignIn.currentUser);
//   }
// }

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    try {
      // auth(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = new UserRepository();
    return BlocProvider(
      create: (context) => UserCubit(userRepository),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('auth'),
            ),
          ),
          body: BlocListener<UserCubit, UserState>(listener: (context, state) {
            if (state is UserLoadedState) {
              Navigator.pushReplacementNamed(context, "/main");
            } else {
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          try {
                            UserCubit userCubit =
                                BlocProvider.of<UserCubit>(context);
                            // auth(context);
                            userCubit.fetchUser();
                            print(userCubit);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text('Google Sign In'))
                  ],
                ),
              ]);
            }
          }, child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserEmptyState) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                try {
                                  UserCubit userCubit =
                                      BlocProvider.of<UserCubit>(context);
                                  userCubit.fetchUser();
                                  print(userCubit);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text('Google Sign In'))
                        ],
                      ),
                    ]);
              } else if (state is UserErrorState) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text('Ошибка'),
                          )
                        ],
                      ),
                    ]);
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ]);
              }
            },
          )),
        ),
      ),
    );
  }
}
