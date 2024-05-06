import 'package:flutter/material.dart';
import '../../models/actuators.dart';

class ActatorDetails extends StatelessWidget {
  final Actuator actuator;

  const ActatorDetails({Key? key, required this.actuator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Description:', actuator.description ?? 'N/A'),
          _buildDetailRow('Output Pin:', actuator.outPutPin?.toString() ?? 'N/A'),
          _buildDetailRow('Type: ', actuator.getType()?.toString() ?? 'N/A'),
          _buildDetailRow('State:', actuator.getState()?.toString() ?? 'N/A'),
          _buildDetailRow('Last Update:', actuator.getTimeStamp()?.toString() ?? 'N/A'),
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
