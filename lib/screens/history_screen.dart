import 'package:app_emergencia/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<AppProvider>(context).history;

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Eventos")),
      body: history.isEmpty
          ? const Center(child: Text("Nenhum evento registrado."))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final event = history[i];
                return ListTile(
                  leading: Icon(
                    event.type.contains("Pânico") ? Icons.warning : Icons.info,
                    color: event.type.contains("Pânico") ? Colors.red : Colors.blue,
                  ),
                  title: Text(event.type),
                  subtitle: Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(event.timestamp)),
                );
              },
            ),
    );
  }
}