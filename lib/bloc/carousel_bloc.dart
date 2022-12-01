import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselBloc extends Bloc<int, int> {
  CarouselBloc(int initialState) : super(initialState);

  // @override
  Stream<int> mapEventToState(int event) async* {
    yield event;
  }
}
