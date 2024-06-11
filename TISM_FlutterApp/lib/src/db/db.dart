import 'dart:math';
import 'package:appiot/src/models/sensor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static Database? database;

static Future<Database> connect() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'tism.db');
  Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Sensors (id INTEGER PRIMARY KEY, description TEXT, type INT, outPutPin1 INTEGER, outPutPin2 INTEGER, analogValue REAL, digitalValue INTEGER);');
    });

  return database;
}

  static Future<void> insertExampleData(Database? database, int? type) async 
  {
    Random random = Random();
  // Inserir alguns dados de exemplo
    await database?.insert(
      'Sensors',
      {
        'description': "Sensor de nivel",
        'type': type,
        'outPutPin1': 22,
        'outPutPin2': 21,
        'analogValue': random.nextDouble() * 100,
        'digitalValue': 0,
        'timeStamp': DateTime.now().toString(),
      },
    );
  }

  static Future<List<Sensor>> selectFromTableSensors() async 
  {  
    List<Sensor> sensors = [];

    if (Db.database != null)
    {
      List<Map<String, dynamic>> sensorsMap = await Db.database!.query('Sensors');

      for (var sensorMap in sensorsMap) {
        Sensor sensor = Sensor(
          id : sensorMap['id'],
          description : sensorMap['description'],
          type : sensorMap['type'],
          //outPutPin1 : sensorMap['outPutPin1'],
          //outPutPin2 : sensorMap['outPutPin2'],
          //analogValue : sensorMap['analogValue'],
          //digitalValue : sensorMap['digitalValue'],
          //timeStamp : DateTime.parse(sensorMap['TimeStamp']),
        );

        sensors.add(sensor);
      }
    }

    return sensors;
  }

  static Future<Sensor> getLastSensorByType(int type) async {
  if (Db.database != null) {
    List<Map<String, dynamic>> result = await Db.database!.rawQuery(
    '''
      SELECT *
      FROM Sensors
      WHERE type = ?
      ORDER BY timeStamp DESC
      LIMIT 1
    ''', [type]);

    if (result.isNotEmpty) {
      return Sensor(
        id: result[0]['id'],
        description: result[0]['description'],
        type: result[0]['type'],
        //outPutPin1: result[0]['outPutPin1'],
        //outPutPin2: result[0]['outPutPin2'],
        //analogValue: result[0]['analogValue'],
        //digitalValue: (result[0]['digitalValue'] == 1) ? true : false,
        //timeStamp: DateTime.parse(result[0]['timeStamp']),
      );
    }
  }
  return Sensor(
    //    id: 0,
        description: "",
        type: -1,
        //outPutPin1: -1,
        //outPutPin2: -1,
        //analogValue: -1,
        //digitalValue: false,
        //timeStamp: DateTime.now(),
      );
}

// Seleciona eventos cujo sensores estão acima do valor limite de 89
static Future<List<Sensor>> selectFromTableSensorsLimit() async 
{
  List<Sensor> sensors = [];

  if (Db.database != null)
  {
    List<Map<String, dynamic>> sensorsMap = await Db.database!.query('Sensors', where: 'analogValue > 20');

    for (var sensorMap in sensorsMap) {
      Sensor sensor = Sensor(
        id : sensorMap['id'],
        description : sensorMap['description'],
        type : sensorMap['type'],
        //outPutPin1 : sensorMap['outPutPin1'],
        ///outPutPin2 : sensorMap['outPutPin2'],
        //analogValue : sensorMap['analogValue'],
        //digitalValue: (sensorMap['digitalValue'] == 1) ? true : false,
        //timeStamp : DateTime.parse(sensorMap['TimeStamp']),
      );

      sensors.add(sensor);
    }
  }

  return sensors;
}
}
