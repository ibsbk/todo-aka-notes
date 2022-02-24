
abstract class NoteState{}

class NoteEmptyState extends NoteState{}

class NoteLoadingState extends NoteState{}

class NoteLoadedState extends NoteState{
  List<dynamic> loadedNote;
  NoteLoadedState({required this.loadedNote}) : assert(loadedNote!=null);
}

class NoteCreatingState extends NoteState{}

class NoteCreatedState extends NoteState{}

class NoteErrorState extends NoteState{}