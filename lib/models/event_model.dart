class EventModel {
  final int? id;
  final String type; 
  final DateTime timestamp;

  EventModel({this.id, required this.type, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}