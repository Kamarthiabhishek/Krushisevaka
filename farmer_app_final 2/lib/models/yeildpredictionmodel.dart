import 'dart:convert';

Yeildprediction yeildpredictionFromJson(String str) => Yeildprediction.fromJson(json.decode(str));

String yeildpredictionToJson(Yeildprediction data) => json.encode(data.toJson());

class Yeildprediction {
  Yeildprediction({
     this.prediction,
  });

  String? prediction;

  factory Yeildprediction.fromJson(Map<String, dynamic> json) => Yeildprediction(
    prediction: json["prediction"],
  );

  Map<String, dynamic> toJson() => {
    "prediction": prediction,
  };
}
