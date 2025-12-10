import 'package:app_emergencia/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventModel Tests', () {
    test('Deve converter Model para Map corretamente', () {
      final date = DateTime.now();
      final event = EventModel(id: 1, type: 'Teste', timestamp: date);
      
      final map = event.toMap();
      
      expect(map['id'], 1);
      expect(map['type'], 'Teste');
      expect(map['timestamp'], date.toIso8601String());
    });

    test('Deve criar Model a partir de Map corretamente', () {
      final date = DateTime.now();
      final map = {
        'id': 2,
        'type': 'Pânico',
        'timestamp': date.toIso8601String(),
      };

      final event = EventModel.fromMap(map);

      expect(event.id, 2);
      expect(event.type, 'Pânico');
      expect(event.timestamp.toIso8601String(), date.toIso8601String());
    });
  });
}