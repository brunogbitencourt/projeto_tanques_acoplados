import 'package:flutter/material.dart';
import '../../models/actuator.dart';
import '../components/actuator_details.dart';

class ActuatorWidget extends StatefulWidget {
  final Actuator actuator;

  const ActuatorWidget({Key? key, required this.actuator}) : super(key: key);

  @override
  _ActuatorWidgetState createState() => _ActuatorWidgetState();
}

class _ActuatorWidgetState extends State<ActuatorWidget> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    // Inicializa o valor do slider com base no valor do actuator.outputPWM
    // Garantindo que o valor inicial de outputPWM seja convertido para double
    sliderValue = (widget.actuator.outputPWM ?? 0) / 255 * 100;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.actuator.description ?? '',
        style: TextStyle(fontSize: 16.0),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Value: ${widget.actuator.state == 1 ? 'ON' : 'OFF'}',
            style: TextStyle(fontSize: 14.0),
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${sliderValue.round()}%',
            onChanged: (value) {
              setState(() {
                sliderValue = value;
                // Atualiza o actuator.outputPWM com base no valor do slider
                widget.actuator.outputPWM = (sliderValue / 100 * 255);
              });
            },
          ),
          Text(
            'PWM: ${widget.actuator.outputPWM?.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ActatorDetails(actuator: widget.actuator);
          },
        );
      },
    );
  }
}
