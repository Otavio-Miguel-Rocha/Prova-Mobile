# Emergência Local - Sistema de Monitoramento Pessoal

Este projeto consiste em um aplicativo móvel desenvolvido em Flutter que
simula um sistema de alerta e monitoramento para situações de
emergência. O foco principal é a capacidade de disparar alertas críticos
(sonoros e vibratórios) que sobrepõem configurações de "Não Perturbe" ou
modo silencioso do dispositivo (Android), além de integração com API de
clima e geolocalização.

## Arquitetura do Projeto

O projeto adota uma arquitetura MVVM simplificada utilizando o padrão
Provider para injeção de dependência e gerenciamento de estado.

### Estrutura de Pastas

    lib/
    ├── models/
    │   ├── event_model.dart
    │   └── weather_model.dart
    ├── providers/
    │   ├── app_provider.dart
    │   └── weather_provider.dart
    ├── screens/
    │   ├── dashboard_screen.dart
    │   ├── history_screen.dart
    │   ├── settings_screen.dart
    │   └── weather_screen.dart
    ├── services/
    │   ├── database_service.dart
    │   ├── notification_service.dart
    │   └── weather_service.dart
    └── main.dart

### Fluxo de Dados

1.  View → interação do usuário\
2.  Provider → lógica\
3.  Service → APIs e nativos\
4.  Model → dados tipados\
5.  notifyListeners()

## Tecnologias e Pacotes Utilizados

-   Flutter & Dart
-   Provider
-   Flutter Local Notifications
-   SQFLite
-   Shared Preferences
-   Http
-   Geolocator
-   Mockito & Build Runner

## Dificuldades e Soluções

### 1. Imutabilidade dos Canais

Solução: versionar IDs dos canais.

### 2. Loop Sonoro

Solução: WidgetsBindingObserver + cancelAllNotifications().

### 3. Permissões Android 13+

Solução: POST_NOTIFICATIONS + INTERNET + runtime permission.

### 4. Conectividade Emulador

Solução: adicionar permissão + cold boot.

## Como Executar o Projeto

### Instalar dependências

    flutter pub get

### Gerar mocks

    flutter pub run build_runner build
    flutter test

### Modo debug

    flutter run

### Gerar APK release

    flutter build apk --release

### Instalar APK

    flutter install
