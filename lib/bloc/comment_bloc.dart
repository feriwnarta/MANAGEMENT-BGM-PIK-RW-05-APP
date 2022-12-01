import 'package:aplikasi_rw/model/comment_model.dart';
import 'package:aplikasi_rw/services/comment_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBlocEvent {
  int idStatus;
  CommentBlocEvent({this.idStatus});
}

abstract class CommentBlocState {}

class CommentBlocUnitialized extends CommentBlocState {}

class CommentEventRefresh extends CommentBlocEvent {
  int idStatus;
  CommentEventRefresh({this.idStatus});
}

class CommentBlocLoaded extends CommentBlocState {
  List<CommentModel> listComment = [];
  bool isMaxReached;

  CommentBlocLoaded({this.listComment, this.isMaxReached});

  CommentBlocLoaded copyWith(
      {List<CommentModel> listComment, bool isMaxReached}) {
    return CommentBlocLoaded(
        listComment: listComment ?? this.listComment,
        isMaxReached: isMaxReached ?? this.isMaxReached);
  }
}

class CommentBloc extends Bloc<CommentBlocEvent, CommentBlocState> {
  CommentBloc(CommentBlocState initialState) : super(initialState);
  List<CommentModel> listComment;

  // @override
  Stream<CommentBlocState> mapEventToState(CommentBlocEvent event) async* {
    print('event id status bloc ${event.idStatus}');

    if (event is CommentBlocEvent) {
      listComment = await CommentService.getDataApi(event.idStatus, 0, 10);
      yield CommentBlocLoaded(isMaxReached: false, listComment: listComment);
    }

    if (state is CommentBlocUnitialized) {
      listComment = await CommentService.getDataApi(event.idStatus, 0, 10);
      yield CommentBlocLoaded(isMaxReached: false, listComment: listComment);
    } else {
      // ambil data sebelumnya
      CommentBlocLoaded loaded = state as CommentBlocLoaded;

      // ambil data baru dengan start dari data sebelumnya sebanyak 10
      listComment = await CommentService.getDataApi(
          event.idStatus, loaded.listComment.length, 10);

      // jika list comment empty (sudah abis) diberikan data sebelumny dengan ismaxreached true
      // jika belum berikan comment bloc loaded baru dengan list sebelumnya di tambah list baru is max reached false
      yield (listComment.isEmpty)
          ? loaded.copyWith(isMaxReached: true)
          : CommentBlocLoaded(
              listComment: loaded.listComment + listComment,
              isMaxReached: false);
    }
  }
}

class CommentCountEvent {
  int number;
}
