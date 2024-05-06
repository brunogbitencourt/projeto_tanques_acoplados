import 'package:flutter/material.dart';
import '../../models/sensor.dart';

class SensorDetails extends StatelessWidget {
  final Sensor sensor;

  const SensorDetails({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Description:', sensor.description ?? 'N/A'),
          _buildDetailRow('Output Pin 1:', sensor.outPutPin1?.toString() ?? 'N/A'),
          _buildDetailRow('Output Pin 2:', sensor.outPutPin2?.toString() ?? 'N/A'),
          _buildDetailRow('Analog Value:', sensor.analogValue?.toString() ?? 'N/A'),
          _buildDetailRow('Digital Value:', sensor.digitalValue?.toString() ?? 'N/A'),
          _buildDetailRow('Last Update:', sensor.timeStamp?.toString() ?? 'N/A'),
        ],
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
        SizedBox(height: 8.0), // Adiciona espaçamento entre as linhas
      ],
    );
  }
}
