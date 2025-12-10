import 'package:app_emergencia/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Preferências")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Ativar Monitoramento"),
            subtitle: const Text("Habilita o botão de pânico"),
            value: provider.isSystemActive,
            onChanged: (val) => provider.toggleSystem(val),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Modo Crítico"),
            subtitle: const Text("Tenta sobrepor 'Não Perturbe' e volume baixo usando canais de alarme."),
            secondary: const Icon(Icons.notification_important, color: Colors.orange),
            value: provider.isCriticalMode,
            onChanged: (val) => provider.toggleCriticalMode(val),
          ),
          const ListTile(
            title: Text("Tipo de Notificação"),
            subtitle: Text("Som + Vibração + Banner (Padrão)"),
            leading: Icon(Icons.notifications_active),
          )
        ],
      ),
    );
  }
}