import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<bool, bool> {
  PaymentBloc(bool initialState) : super(initialState);

  // @override
  Stream<bool> mapEventToState(bool event) async* {
    yield !event;
  }
}
