import 'package:introduction_screen/introduction_screen.dart';

class PositionEmployee {
  String idPosition, position;

  PositionEmployee.fromJson(Map<String, dynamic> data)
      : idPosition = data['id_position'],
        position = data['position'];
}
