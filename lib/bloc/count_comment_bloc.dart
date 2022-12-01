import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/count_comment_services.dart';

class CommentCountBlocEvent {
  String idUser, idStatus;
  CommentCountBlocEvent({this.idStatus, this.idUser});
}

class CommentCountBlocState {
  String countComment;

  CommentCountBlocState({this.countComment});
}

class CommentCountBloc
    extends Bloc<CommentCountBlocEvent, CommentCountBlocState> {
  CommentCountBloc(CommentCountBlocState initialState) : super(initialState);

  // @override
  Stream<CommentCountBlocState> mapEventToState(
      CommentCountBlocEvent event) async* {
    String count = await CountCommentServices.getCountComment(
        idStatus: event.idStatus, idUser: event.idUser);
    yield CommentCountBlocState(countComment: count);
  }
}
