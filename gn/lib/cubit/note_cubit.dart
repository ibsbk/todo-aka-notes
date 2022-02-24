import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gn/cubit/note_state.dart';
import 'package:gn/mod/Note.dart';
import 'package:gn/serv/HTTPRequests.dart';
import 'package:gn/serv/google_sign_in.dart';
import 'package:gn/data/note_repository.dart';
import 'package:gn/data/user_repository.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;
  final UserRepository userRepository = new UserRepository();
  final HTTPRequests requests = new HTTPRequests();

  NoteCubit(this.noteRepository) : super(NoteEmptyState());

  Future<void> fetchNotes() async {
    emit(NoteLoadingState());
    print(noteRepository.getAllNotes());
    try {
      final List<dynamic> _loadedNoteList =
          await noteRepository.getAllNotes();
      if (_loadedNoteList.isNotEmpty){
        emit(NoteLoadedState(loadedNote: _loadedNoteList));
      } else {
        emit(NoteErrorState());
      }
    } catch (e) {
      emit(NoteErrorState());
    }
  }

  Future<void> createNote() async {
    emit(NoteCreatingState());
  }
}
