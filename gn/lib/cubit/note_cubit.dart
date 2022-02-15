// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gn/cubit/note_state.dart';
// import 'package:gn/mod/Note.dart';
// import 'package:gn/serv/HTTPRequests.dart';
//
//
// class NoteCubit extends Cubit<NoteState>{
//   final HTTPRequests requests;
//
//   NoteCubit(this.requests) : super(NoteEmptyState());
//
//   Future<void> fetchNotes() async{
//     emit(NoteLoadingState());
//     final List<Note> _loadedNoteList = await requests.getAllNotes(google_id)
//     emit(NoteLoadedState(loadedNote: loadedNote))
//   }
// }