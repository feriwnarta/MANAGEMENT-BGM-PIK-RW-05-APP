import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class TulisStatusEvent {
  final bool isVisibility;
  final PickedFile imageFile;

  TulisStatusEvent({this.imageFile, this.isVisibility});
}

class TempatTulisStatusState {
  final bool isVisible;
  final PickedFile imageFile;

  TempatTulisStatusState({this.isVisible, this.imageFile});
}

class TempatTulisStatusBloc
    extends Bloc<TulisStatusEvent, TempatTulisStatusState> {
  TempatTulisStatusBloc(TempatTulisStatusState initialState)
      : super(initialState);

  @override
  Stream<TempatTulisStatusState> mapEventToState(
      TulisStatusEvent event) async* {
    yield (event.imageFile != null && event.isVisibility)
        ? TempatTulisStatusState(
            imageFile: event.imageFile, isVisible: event.isVisibility)
        : TempatTulisStatusState(imageFile: null, isVisible: false);

    // yield (state == TulisStatusEvent.getImage)
    //     ? state = TempatTulisStatusState(isVisible: true)
    //     : (state == TulisStatusEvent.deleteImage)
    //         ? state = TempatTulisStatusState(isVisible: false)
    //         : state = TempatTulisStatusState(isVisible: false);
  }
}
