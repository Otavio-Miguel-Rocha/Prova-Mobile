🚨 Emergência Local - Sistema de Monitoramento Pessoal

Este projeto consiste em um aplicativo móvel desenvolvido em Flutter que simula um sistema de alerta e monitoramento para situações de emergência. O foco principal é a capacidade de disparar alertas críticos (sonoros e vibratórios) que sobrepõem configurações de "Não Perturbe" ou modo silencioso do dispositivo (Android), além de integração com API de clima e geolocalização.

🏗 Arquitetura do Projeto

O projeto segue uma arquitetura baseada em MVVM (Model-View-ViewModel) simplificada, utilizando o padrão Provider para injeção de dependência e gerenciamento de estado. O objetivo foi manter um baixo acoplamento entre a interface (UI) e a lógica de negócios.

Estrutura de Pastas

A organização do código fonte (/lib) segue a separação de responsabilidades:

lib/
├── models/         # Classes de dados (DTOs)
│   ├── event_model.dart    # Modelo para eventos do histórico
│   └── weather_model.dart  # Modelo para dados da API de clima
├── providers/      # Gerenciamento de Estado (ViewModel)
│   ├── app_provider.dart      # Lógica central do app (Pânico, Configs)
│   └── weather_provider.dart  # Lógica de conexão com API e GPS
├── screens/        # Interface do Usuário (Views)
│   ├── dashboard_screen.dart
│   ├── history_screen.dart
│   ├── settings_screen.dart
│   └── weather_screen.dart
├── services/       # Interação com APIs e Recursos Nativos
│   ├── database_service.dart     # SQLite (Persistência Local)
│   ├── notification_service.dart # Canais de Notificação Android
│   └── weather_service.dart      # Http Client e Geolocator
└── main.dart       # Ponto de entrada e configuração de rotas/temas


Fluxo de Dados

View (Screens): O usuário interage com a tela (ex: clica em "Pânico").

Provider: A View chama um método no Provider.

Service: O Provider aciona um Serviço (ex: NotificationService ou DatabaseService).

Model: O Serviço processa dados brutos e retorna Modelos tipados.

NotifyListeners: O Provider atualiza seu estado e notifica a View para reconstruir a UI.

🛠 Documentação de Desenvolvimento

Tecnologias e Pacotes Utilizados

Flutter & Dart: SDK principal.

Provider: Para gerenciamento de estado reativo.

Flutter Local Notifications: Para criação de canais de notificação críticos e manipulação de vibração/som.

SQFLite: Para persistência de dados offline (histórico de eventos).

Shared Preferences: Para salvar configurações simples (flags de ativado/desativado).

Http: Para consumo da API REST Open-Meteo.

Geolocator: Para obtenção de coordenadas GPS.

Mockito & Build Runner: Para testes unitários e Mocks.

Funcionalidades Chave

Modo Crítico (Android): Utiliza a flag nativa FLAG_INSISTENT e canais de notificação com Importance.max e AudioAttributesUsage.alarm. Isso força o som a tocar em loop contínuo até o app ser aberto, simulando um pager de bombeiro.

Persistência Híbrida: Configurações de usuário persistem via SharedPreferences, enquanto logs de eventos robustos são salvos em banco relacional SQLite.

Monitoramento Climático: Integração com a API pública Open-Meteo para fornecer temperatura local baseada no GPS do dispositivo, útil para análise de riscos ambientais.

⚠️ Dificuldades e Desafios Encontrados

Durante o ciclo de desenvolvimento, os seguintes desafios técnicos foram superados:

1. Imutabilidade dos Canais de Notificação (Android)

Problema: Ao tentar alterar o som ou padrão de vibração da notificação, as mudanças não surtiam efeito.
Causa: O Android cria e "cacheia" as configurações de um Canal de Notificação na primeira vez que ele é usado. Edições posteriores no código são ignoradas pelo sistema operacional para proteger as preferências do usuário.
Solução: Implementação de versionamento nos IDs dos canais (ex: de critical_channel para critical_channel_v3) para forçar a recriação do canal com as novas configurações.

2. Ciclo de Vida e Loop Sonoro

Problema: O som de alerta (sirene/bip) continuava tocando mesmo após o usuário desbloquear o celular, ou não parava nunca.
Solução: Implementação do WidgetsBindingObserver na MainScreen. O app observa quando o estado muda para AppLifecycleState.resumed (app em foco) e chama explicitamente cancelAllNotifications().

3. Permissões no Android 13+

Problema: O app falhava silenciosamente ao tentar notificar ou acessar a internet em dispositivos modernos.
Solução:

Adição explícita de <uses-permission> no AndroidManifest.xml para POST_NOTIFICATIONS e INTERNET.

Implementação de lógica para solicitar permissão em tempo de execução na inicialização do NotificationService.

4. Emulador e Conectividade

Problema: Erro ClientException: Failed host lookup ao testar a API de clima.
Causa: O emulador Android ocasionalmente perde a ponte de rede com o host ou falta de permissão de internet no manifesto.
Solução: Adição da permissão de Internet e reinicialização (Cold Boot) do emulador.

🚀 Passo a Passo para Rodar o APK

Siga estas instruções para compilar e instalar o aplicativo em um dispositivo Android.

Pré-requisitos

Flutter SDK instalado e configurado no PATH.

Java (JDK 11 ou 17).

Android Studio ou VS Code configurados.

Dispositivo Android com Depuração USB ativada OU Emulador Android.

1. Clonar e Instalar Dependências

Abra o terminal na pasta raiz do projeto e execute:

# Baixar todas as bibliotecas listadas no pubspec.yaml
flutter pub get


2. Gerar Arquivos de Mock (Para Testes)

Se você for rodar os testes unitários, precisa gerar os mocks antes:

flutter pub run build_runner build


Para rodar os testes: flutter test

3. Executar em Modo Debug (Desenvolvimento)

Com o dispositivo conectado:

flutter run


4. Gerar o APK (Release)

Para gerar o arquivo instalável .apk otimizado:

flutter build apk --release


O arquivo será gerado em: build/app/outputs/flutter-apk/app-release.apk

5. Instalar no Dispositivo

Você pode copiar o arquivo gerado para o celular ou instalar via ADB:

flutter install
