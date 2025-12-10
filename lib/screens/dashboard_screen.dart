import 'package:app_emergencia/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isActive = provider.isSystemActive;

    return Scaffold(
      appBar: AppBar(title: const Text("Monitoramento")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status Indicator
            Icon(
              isActive ? Icons.shield : Icons.shield_outlined,
              size: 80,
              color: isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              isActive ? "SISTEMA ATIVADO" : "SISTEMA DESATIVADO",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            
            // Botão de Pânico
            GestureDetector(
              onTap: isActive ? () => provider.triggerPanic() : null,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: isActive ? Colors.red : Colors.red.shade200,
                  shape: BoxShape.circle,
                  boxShadow: isActive ? [
                    BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)
                  ] : [],
                ),
                child: const Center(
                  child: Text(
                    "PÂNICO",
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (!isActive)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Ative o sistema para habilitar o alerta.", style: TextStyle(color: Colors.grey)),
              )
          ],
        ),
      ),
    );
  }
}