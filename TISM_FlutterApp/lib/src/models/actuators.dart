class Actuator{
  int? id;
  String? description;
  int? type;
  int? outPutPin;
  int? state;
  int? pwmOutput;
  DateTime? timeStamp;

  Actuator({
    this.id, 
    this.description, 
    this.type, 
    this.outPutPin, 
    this.state, 
    this.pwmOutput, 
    this.timeStamp
  });


  void setDescription(String value){
    description = value;
  }

  void setType(int value){
    type = value;
  }

  void setOutPutPin(int value){
    outPutPin = value;
  }

  void setState(int value){
    state = value;
  }

  void setPwmOutput(int value){
    pwmOutput = value;
  }

  String getDescription(){
    return description!;
  }

  int getType(){
    return type!;
  }

  int getOutPutPin(){
    return outPutPin!;
  }

  int getState(){
    return state!;
  }

  int getPwmOutput(){
    return pwmOutput!;
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

 Actuator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    type = json['type'];
    outPutPin = json['outPutPin'];
    state = json['state'];
    pwmOutput = json['pwmOutput'];
    timeStamp = DateTime.parse(json['timeStamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['type'] = type;
    data['outPutPin'] = outPutPin;
    data['state'] = state;
    data['pwmOutput'] = pwmOutput;
    data['timeStamp'] = timeStamp!.toIso8601String();
    return data;
  }

  


}