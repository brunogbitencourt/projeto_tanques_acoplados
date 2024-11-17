import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl
import '../../models/sensor.dart'; 
import '../components/sensor_details.dart';

class SensorWidget extends StatelessWidget {
  final Sensor sensor;

  const SensorWidget({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss'); // Formato de data desejado

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green.shade700, width: 2), // Borda verde
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.green.shade700,
            child: Text(
              sensor.id?.toUpperCase() ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 4),
          ListTile(
            title: Text(
              sensor.description ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sensor.id?.startsWith('uss') ?? false)
                  Text(
                    '${sensor.analogValue ?? ''} ${sensor.unit ?? ''}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                if (sensor.id?.startsWith('d') ?? false)
                  Text(
                    sensor.digitalValue == 1 ? 'LIGADO' : 'Desligado',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SensorDetails(sensor: sensor);
                },
              );
            },
          ),
          SizedBox(height: 4),
          Divider(
            color: Colors.green.shade700,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          SizedBox(height: 4),
          Text(
            "  " + dateFormat.format(sensor.timestamp ?? DateTime.now()), // Formatar a data
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
