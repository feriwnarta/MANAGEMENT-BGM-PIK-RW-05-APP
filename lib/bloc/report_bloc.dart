import 'package:aplikasi_rw/model/ReportModel.dart';
import 'package:aplikasi_rw/services/report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportEvent2 {}

abstract class ReportState2 {}

class ReportUnitialized extends ReportState2 {}

class ReportEventRefresh extends ReportEvent2 {}

class ReportEventMainRefresh extends ReportEvent2 {}

class ReportLoaded extends ReportState2 {
  List<ReportModel> listReport;
  bool isMaxReached;
  String idUser;

  ReportLoaded({this.listReport, this.isMaxReached, this.idUser});

  // update max reached
  ReportLoaded copyWith(
      {List<ReportModel> listReport, bool isMaxReached, String idUser}) {
    return ReportLoaded(
        listReport: listReport ?? this.listReport,
        isMaxReached: isMaxReached ?? this.isMaxReached,
        idUser: idUser ?? this.idUser);
  }
}

class ReportBloc extends Bloc<ReportEvent2, ReportState2> {
  ReportBloc(ReportState2 initialState) : super(initialState);

  // @override
  Stream<ReportState2> mapEventToState(ReportEvent2 event) async* {
    List<ReportModel> listReport;

    String idUser = await UserSecureStorage.getIdUser();

    if (event is ReportEventRefresh) {
      listReport = await ReportServices.getDataApi(idUser, 0, 10);
      yield ReportLoaded(
          listReport: listReport, isMaxReached: false, idUser: idUser);
    }

    if (state is ReportUnitialized) {
      listReport = await ReportServices.getDataApi(idUser, 0, 10);
      yield ReportLoaded(
          listReport: listReport, isMaxReached: false, idUser: idUser);
    } else {
      ReportLoaded reportLoaded = state as ReportLoaded;
      listReport = await ReportServices.getDataApi(
          reportLoaded.idUser, reportLoaded.listReport.length, 10);
      yield (listReport.isEmpty)
          ? reportLoaded.copyWith(
              isMaxReached: true, idUser: reportLoaded.idUser)
          : ReportLoaded(
              listReport: reportLoaded.listReport + listReport,
              isMaxReached: false,
              idUser: reportLoaded.idUser);
    }
  }
}
