class Sensor{
  int? id;
  String? description;
  int? type;
  int? outPutPin1;
  int? outPutPin2;
  double? analogValue;
  bool? digitalValue;
  DateTime? timeStamp;

  Sensor({
    this.id,
    this.description,
    this.type,
    this.outPutPin1,
    this.outPutPin2,
    required this.analogValue,
    this.digitalValue,
    this.timeStamp,
  });

  Sensor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    type = json['type'];
    outPutPin1 = json['outPutPin1'];
    outPutPin2 = json['outPutPin2'];
    analogValue = json['analogValue'];
    digitalValue = json['digitalValue'];
    timeStamp = DateTime.parse(json['timeStamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['type'] = type;
    data['outPutPin1'] = outPutPin1;
    data['outPutPin2'] = outPutPin2;
    data['analogValue'] = analogValue;
    data['digitalValue'] = digitalValue;
    data['timeStamp'] = timeStamp!.toIso8601String();
    return data;
  }

  void setAnalogValue(double value){
    analogValue = value;
  }

  void setDigitalValue(bool value){
    digitalValue = value;
  }

  void setDescription(String value){
    description = value;
  }

  void setType(int value){
    type = value;
  }

  void setOutPutPin1(int value){
    outPutPin1 = value;
  }

  void setOutPutPin2(int value){
    outPutPin2 = value;
  }

  double getAnalogValue(){
    return analogValue!;
  }

  bool getDigitalValue(){
    return digitalValue!;
  }

  String getDescription(){
    return description!;
  }

  int getType(){
    return type!;
  }

  int getOutPutPin1(){
    return outPutPin1!;
  }

  int getOutPutPin2(){
    return outPutPin2!;
  }

  int getId(){
    return id!;
  }

  void setId(int value){
    id = value;
  }

  DateTime getTimeStamp(){
    return timeStamp!;
  }

  void setTimeStamp(DateTime value){
    timeStamp = value;
  }






}


