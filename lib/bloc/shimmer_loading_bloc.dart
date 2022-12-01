import 'package:flutter_bloc/flutter_bloc.dart';

class ShimmerLoadingBloc extends Bloc<bool, bool> {
  ShimmerLoadingBloc(bool initialState) : super(initialState);

  // @override
  Stream<bool> mapEventToState(bool event) async* {
    yield !event;
  }
}
