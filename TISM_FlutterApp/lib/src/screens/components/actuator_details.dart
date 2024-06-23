import 'package:flutter/material.dart';
import '../../models/actuator.dart';

class ActuatorDetails extends StatelessWidget {
  final Actuator actuator;

  const ActuatorDetails({Key? key, required this.actuator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(40), // Provide ample space around the dialog
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.green.shade700, width: 2),
      ),
      child: Align( // Align the dialog's child
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  alignment: Alignment.topRight,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.white,
                    child:  _buildActuatorImage(actuator.id),
                  ),
                ),
                SizedBox(height: 16),
                _buildDetailRow('ID:', actuator.id ?? 'N/A'),
                _buildDetailRow('Description:', actuator.description ?? 'N/A'),
                _buildDetailRow('Output Pin:', actuator.outputPin?.toString() ?? 'N/A'),
                _buildDetailRow('Output PWM:', actuator.outputPWM?.toStringAsFixed(2) ?? 'N/A'),
                _buildDetailRow('Unit:', actuator.unit ?? 'N/A'),
                _buildDetailRow('Last Update:', actuator.timestamp?.toString() ?? 'N/A'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildActuatorImage(String? id) {
  if (id!.startsWith('AP')) {
    return Image.asset(
      'assets/images/pump_image.jpg',
      fit: BoxFit.fitWidth,
    );
  } else if (id!.startsWith('AM')) {
    return Image.asset(
      'assets/images/motor_image.jpeg',
      fit: BoxFit.fitWidth,
    );
  } else if (id!.startsWith('AV')) {
    return Image.asset(
      'assets/images/valve_image.jpeg',
      fit: BoxFit.fitWidth,
    );
  } else {
    return Image.asset(
      'assets/images/motor_image.jpeg', // Imagem padrão
      fit: BoxFit.fitWidth,
    );
  }
}



}
