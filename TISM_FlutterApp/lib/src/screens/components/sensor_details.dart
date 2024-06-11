import 'package:flutter/material.dart';
import '../../models/sensor.dart';

class SensorDetails extends StatelessWidget {
  final Sensor sensor;

  const SensorDetails({Key? key, required this.sensor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16), // Adiciona espaço ao redor da borda
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.green.shade700, width: 2), // Borda verde
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Center(
              child: Container(
                height: 100,
                width: 100,
                color: const Color.fromARGB(255, 255, 255, 255), // Placeholder for the image
                 child: Image.asset(
                   sensor.id?.startsWith('uss') ?? false
                       ? 'assets/images/uss_image.png'
                       : 'assets/images/ds_image.jpg',
                   //height: 100,
                   width: 200,
                   fit: BoxFit.fitWidth,
                 ),
              ),
            ),
            SizedBox(height: 16), // Espaço entre a imagem e os detalhes
            _buildDetailRow('Description:', sensor.description ?? 'N/A'),
            if (sensor.id?.startsWith('uss') ?? false)
              _buildDetailRow('Analog Value:', sensor.analogValue?.toString() ?? 'N/A'),
            if (sensor.id?.startsWith('ds') ?? false)
              _buildDetailRow('Digital Value:', sensor.digitalValue?.toString() ?? 'N/A'),
            _buildDetailRow('Last Update:', sensor.timestamp?.toString() ?? 'N/A'),
          ],
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
        SizedBox(height: 8.0), // Adiciona espaçamento entre as linhas
      ],
    );
  }
}
