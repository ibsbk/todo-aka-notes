import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/note_state.dart';
import 'package:gn/mod/Note.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/serv/note_repository.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;
  final HTTPRequests requests = new HTTPRequests();
  final GoogleAuth googleSign = new GoogleAuth();

  NoteCubit(this.noteRepository) : super(NoteEmptyState());

  Future<void> fetchNotes() async {
    emit(NoteLoadingState());
    await googleSign.googleLogin();
    print(googleSign.googleSignIn.currentUser);
    if (googleSign.googleSignIn.currentUser != null) {
      print(googleSign.googleSignIn.currentUser);
      final List<dynamic> _loadedNoteList =
          await requests.getAllNotes(googleSign.googleSignIn.currentUser!.id);
      print(_loadedNoteList);
      emit(NoteLoadedState(loadedNote: _loadedNoteList));
    }
  }
}
