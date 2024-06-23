import 'package:flutter/material.dart';
import '../../models/actuator.dart';
import '../components/actuator_details.dart';
import 'package:intl/intl.dart'; // Importe o pacote intl


class ActuatorWidget extends StatefulWidget {
  final Actuator actuator;

  const ActuatorWidget({Key? key, required this.actuator}) : super(key: key);

  @override
  _ActuatorWidgetState createState() => _ActuatorWidgetState();
}

class _ActuatorWidgetState extends State<ActuatorWidget> {
  late bool isValve;
  late double sliderValue;
  late String textTitle; // Variável para armazenar o título personalizado

  @override
  void initState() {
    super.initState();
    isValve = widget.actuator.id?.startsWith('AV') ?? false;
    sliderValue = (widget.actuator.outputPWM ?? 0).toDouble(); // Inicializa com o valor do banco convertido para double
    
    // Define o texto de título baseado no prefixo do id do atuador
    if (widget.actuator.id?.startsWith("AV") ?? false) {
      textTitle = "Valve " + (widget.actuator.id ?? "");
    } else if (widget.actuator.id?.startsWith("AM") ?? false) {
      textTitle = "Motor " + (widget.actuator.id ?? "");
    } else if (widget.actuator.id?.startsWith("AP") ?? false) {
      textTitle = "Pump " + (widget.actuator.id ?? "");
    } else {
      textTitle = widget.actuator.id ?? ""; // Caso padrão, use o ID como está
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss'); // Formato de data desejado
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.green.shade700, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.green.shade700,
            child: Text(
              textTitle, // Usa o título personalizado
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 4),
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isValve)
                  Row(
                    children: [
                      Switch(
                        value: widget.actuator.outputPWM != 0,
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              widget.actuator.outputPWM = 100.0; // Define o valor de outputPWM para abrir completamente a válvula
                              sliderValue = 100.0; // Atualiza o slider
                            } else {
                              widget.actuator.outputPWM = 0.0; // Define o valor de outputPWM para fechar completamente a válvula
                              sliderValue = 0.0; // Atualiza o slider
                            }
                          });
                        },
                        activeColor: Colors.green.shade700,
                      ),
                    ],
                  ),
                if (!isValve)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                        value: sliderValue,
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        label: '${sliderValue.round()}%',
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                            widget.actuator.outputPWM = value; // Atualiza o valor de outputPWM
                          });
                        },
                        activeColor: Colors.green.shade700,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '%: ${widget.actuator.outputPWM?.toStringAsFixed(2)}', // Exibe o valor de outputPWM
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return ActuatorDetails(actuator: widget.actuator);
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
            "  " + dateFormat.format(widget.actuator.timestamp ?? DateTime.now()), // Formatar a data
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
