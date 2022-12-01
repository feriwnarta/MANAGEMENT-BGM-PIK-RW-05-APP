import 'package:flutter_bloc/flutter_bloc.dart';

class ReportEvent {
  final bool isVisibility, isVisibileGuide;
  ReportEvent({this.isVisibility = true, this.isVisibileGuide = true});
}

class ReportState {
  final bool isVisibility, isVisibileGuide;
  ReportState({this.isVisibility = true, this.isVisibileGuide = true});
}

class ReportScreenBloc extends Bloc<ReportEvent, ReportState> {
  ReportScreenBloc(ReportState initialState) : super(initialState);

  // @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event.isVisibility) {
      if (event.isVisibileGuide) {
        yield ReportState();
      } else {
        yield ReportState(isVisibileGuide: false);
      }
    } else {
      if (state.isVisibileGuide) {
        yield ReportState(isVisibility: false);
      } else {
        yield ReportState(isVisibility: false, isVisibileGuide: false);
      }
    }
  }
}
