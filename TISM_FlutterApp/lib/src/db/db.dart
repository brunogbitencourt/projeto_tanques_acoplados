import 'package:appiot/src/models/actuator.dart';
import 'package:appiot/src/models/sensor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static Database? database;

  static Future<Database> connect() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tism.db');

    // Abre o banco de dados e cria as tabelas caso não existam
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Sensors ('
            'id TEXT, '
            'timestamp TEXT, '
            'description TEXT, '
            'outputPin1 INTEGER, '
            'outputPin2 INTEGER, '
            'analogValue REAL, '
            'digitalValue INTEGER, '
            'unit TEXT, '
            'PRIMARY KEY (id, timestamp)'
            ');');

        await db.execute('CREATE TABLE Actuators('
            'id TEXT, '
            'timestamp TEXT, '
            'description TEXT, '
            'outputPin INTEGER, '
            'outputPWM REAL, '
            'unit TEXT, '
            'PRIMARY KEY (id, timestamp)'
            ');');
      },
    );

    return database;
  }

  static Future<void> insertSensor(Database db, Sensor sensor) async {
    await db.insert(
      'Sensors',
      sensor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // ou ConflictAlgorithm.ignore, dependendo da lógica desejada
    );
  }

  static Future<void> insertActuator(Database db, Actuator actuator) async {
    await db.insert(
      'Actuators',
      actuator.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // ou ConflictAlgorithm.ignore, dependendo da lógica desejada
    );
  }

  static Future<List<Actuator>> getAllActuators(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('Actuators');

    return List.generate(maps.length, (i) {
      String id = maps[i]['id'] ?? '';
      String description = maps[i]['description'] ?? '';
      int outputPin = maps[i]['outputPin'] ?? 0;
      double outputPWM = maps[i]['outputPWM'] ?? 0.0;
      String unit = maps[i]['unit'] ?? '';

      DateTime? timestamp;
      try {
        if (maps[i]['timestamp'] != null) {
          timestamp = DateTime.parse(maps[i]['timestamp']);
        }
      } catch (e) {
        print("Erro ao converter timestamp: $e");
      }

      return Actuator(
        id: id,
        timestamp: timestamp,
        description: description,
        outputPin: outputPin,
        outputPWM: outputPWM,
        unit: unit,
      );
    });
  }

  static Future<List<Actuator>> getLastValuePerActuator(Database db) async {
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT A.* FROM Actuators A INNER JOIN ('
      'SELECT id, MAX(timestamp) AS max_timestamp FROM Actuators GROUP BY id'
      ') B ON A.id = B.id AND A.timestamp = B.max_timestamp'
    );
    print("fez o select");

    return maps.map((map) {
      return Actuator(
        id: map['id'],
        timestamp: DateTime.tryParse(map['timestamp']),
        description: map['description'],
        outputPin: map['outputPin'],
        outputPWM: map['outputPWM'] != null ? double.tryParse(map['outputPWM'].toString()) : null,
        unit: map['unit'],
      );
    }).toList();
}


  // Método para pegar todos os sensores
  static Future<List<Sensor>> getAllSensors(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('Sensors');

    return List.generate(maps.length, (i) {
      String id = maps[i]['id'] ?? '';
      String description = maps[i]['description'] ?? '';
      int outputPin1 = maps[i]['outputPin1'] ?? 0;
      int outputPin2 = maps[i]['outputPin2'] ?? 0;
      double analogValue = maps[i]['analogValue'] ?? 0.0;
      bool digitalValue = maps[i]['digitalValue'] == 1;
      String unit = maps[i]['unit'] ?? '';

      DateTime? timestamp;
      try {
        if (maps[i]['timestamp'] != null) {
          timestamp = DateTime.parse(maps[i]['timestamp']);
        }
      } catch (e) {
        print("Erro ao converter timestamp: $e");
      }

      return Sensor(
        id: id,
        description: description,
        outputPin1: outputPin1,
        outputPin2: outputPin2,
        timestamp: timestamp,
        analogValue: analogValue,
        digitalValue: digitalValue,
        unit: unit,
      );
    });
  }

  // Método para pegar o último valor de cada sensor existente
  static Future<List<Sensor>> getLastValuePerSensor(Database db) async {
  // Consulta para pegar os IDs distintos de sensores
  final List<Map<String, dynamic>> uniqueSensorIds = await db.rawQuery(
    'SELECT DISTINCT id FROM Sensors'
  );

  List<Sensor> sensors = [];

  // Para cada sensor distinto encontrado
  for (var sensorIdMap in uniqueSensorIds) {
    String sensorId = sensorIdMap['id'];

    // Consulta para obter o último registro do sensor específico
    final List<Map<String, dynamic>> result = await db.query(
      'Sensors',
      where: 'id = ?',
      whereArgs: [sensorId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      String id = result[0]['id'] ?? '';
      String description = result[0]['description'] ?? '';
      int outputPin1 = result[0]['outputPin1'] ?? 0;
      int outputPin2 = result[0]['outputPin2'] ?? 0;
      double analogValue = result[0]['analogValue'] ?? 0.0;
      bool digitalValue = result[0]['digitalValue'] == 1;
      String unit = result[0]['unit'] ?? '';

      DateTime? timestamp;
      try {
        if (result[0]['timestamp'] != null) {
          timestamp = DateTime.parse(result[0]['timestamp']);
        }
      } catch (e) {
        print("Erro ao converter timestamp: $e");
      }

      sensors.add(Sensor(
        id: id,
        description: description,
        outputPin1: outputPin1,
        outputPin2: outputPin2,
        timestamp: timestamp,
        analogValue: analogValue,
        digitalValue: digitalValue,
        unit: unit,
      ));
    }
  }

  return sensors;
}


  static Future<void> updateActuator(Database db, Actuator actuator) async {
    await db.update(
      'Actuators',
      actuator.toMap(),
      where: 'id = ?',
      whereArgs: [actuator.id],
    );
  }

  static Future<void> deleteActuator(Database db, String id) async {
    await db.delete(
      'Actuators',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
