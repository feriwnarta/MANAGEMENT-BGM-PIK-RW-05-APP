import 'package:aplikasi_rw/model/bills_history_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillRegulerEvent {
  int index;
  bool isExpanded;

  BillRegulerEvent({this.index, this.isExpanded});
}

class BillRegulerBloc extends Bloc<BillRegulerEvent, List<BillsHistoryModel>> {
  BillRegulerBloc(List<BillsHistoryModel> initialState) : super(initialState);

  // @override
  Stream<List<BillsHistoryModel>> mapEventToState(
      BillRegulerEvent event) async* {
    List<BillsHistoryModel> model = BillsHistoryModel.getBillsHistory();
    model[event.index].isExpanded = event.isExpanded;
    yield model;
  }
}
