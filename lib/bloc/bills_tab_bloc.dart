import 'package:aplikasi_rw/model/bills_tab_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TabEvent {
  int index;
  List<BillTab> tab;

  TabEvent({this.index, this.tab});
}

class TabState {
  Color colorAppBar, colorsText;

  TabState({this.colorAppBar, this.colorsText});
}

class BillTabColorBloc extends Bloc<TabEvent, TabState> {
  BillTabColorBloc(TabState initialState) : super(initialState);

  // @override
  Stream<TabState> mapEventToState(TabEvent event) async* {
    print(event.index);
    yield TabState(
        colorAppBar: Colors.green,
        colorsText: event.tab[event.index].colorsText);
  }
}
