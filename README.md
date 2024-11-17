
# Projeto IoT - Sistema de Controle de Tanques Acoplados

Este repositório contém a implementação completa do **Projeto IoT - Sistema de Controle de Tanques Acoplados**, que integra hardware, software e aplicações móveis para monitoramento e controle em tempo real de um sistema industrial simulado.

## Sumário
- [Descrição do Projeto](#descrição-do-projeto)
- [Arquitetura](#arquitetura)
- [Componentes do Projeto](#componentes-do-projeto)
  - [Projeto IoT (Hardware e Firmware)](#projeto-iot-hardware-e-firmware)
  - [API TISM](#api-tism)
  - [Aplicativo Móvel](#aplicativo-móvel)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Instalação e Configuração](#instalação-e-configuração)
- [Autores](#autores)
- [Licença](#licença)

---

## Descrição do Projeto

Este projeto tem como objetivo desenvolver um sistema de controle para uma planta de dois tanques acoplados, utilizando tecnologias modernas como **ESP32**, **MQTT**, **Firebase**, e **Flutter**. Ele simula processos industriais com alta precisão, integrando sensores e atuadores gerenciados por um sistema em tempo real baseado em RTOS.

### Funcionalidades
- Monitoramento contínuo dos níveis dos tanques.
- Controle de bombas, válvulas e motores.
- Comunicação via protocolo MQTT.
- Interface móvel amigável para visualização e controle.
- Publicação contínua de dados na nuvem utilizando Firebase.

---

## Arquitetura

O sistema é composto por:
1. **Sensores**: Coletam dados dos tanques (níveis e estados).
2. **Atuadores**: Realizam ações (acionamento de bombas, válvulas, etc.).
3. **ESP32**: Coordena as operações locais.
4. **API TISM**: Intermedia a comunicação entre o hardware e a nuvem.
5. **Firebase**: Armazena os dados em tempo real.
6. **Aplicativo Flutter**: Permite o controle e monitoramento remoto.

---

## Componentes do Projeto

### Projeto IoT (Hardware e Firmware)
Implementação do firmware em C++ utilizando PlatformIO, com controle preciso de sensores e atuadores.

Repositório original: [Projeto IoT](https://github.com/brunogbitencourt/ProjetoIOT)

### API TISM
APIs RESTful em .NET para integração com MQTT e Firebase, permitindo escalabilidade e gerenciamento de dados.

Repositório original: [TISM API](https://github.com/brunogbitencourt/TISM_API)

### Aplicativo Móvel
Aplicação desenvolvida em Flutter para controle e monitoramento em tempo real. Inclui telas de login, painel principal e eventos.

Repositório original: [TISM App](https://github.com/brunogbitencourt/TISM_App)

---

## Tecnologias Utilizadas

- **Hardware**:
  - ESP32
  - Sensores digitais e analógicos
  - Motores, válvulas e bombas
- **Software**:
  - PlatformIO
  - RTOS (Real-Time Operating System)
  - .NET Core
  - Firebase Realtime Database
- **Mobile**:
  - Flutter
  - Dart
- **Nuvem**:
  - Azure DevOps para CI/CD
  - Docker para containerização

---

## Instalação e Configuração

### Pré-requisitos
1. **PlatformIO**: Para compilar e carregar o firmware no ESP32.
2. **Docker**: Para executar as APIs localmente.
3. **Flutter SDK**: Para compilar e executar o aplicativo móvel.

### Passos
1. Clone o repositório consolidado:
   ```bash
   git clone https://github.com/brunogbitencourt/projeto_tanques_acoplados.git
   ```
2. Configure o firmware no ESP32:
   - Navegue até `ProjetoIOT/`
   - Compile e carregue usando PlatformIO.
3. Inicie as APIs:
   - Navegue até `TISM_API/`
   - Execute:
     ```bash
     docker-compose up
     ```
4. Configure e execute o aplicativo:
   - Navegue até `TISM_App/`
   - Execute:
     ```bash
     flutter run
     ```

---

## Autores

- **Alberto Magno Machado**
- **Bruno Guimarães Bitencourt**
- **Oscar Oliveira Dias**

Este projeto foi desenvolvido no contexto das disciplinas de **Internet das Coisas** e **Laboratório de Dispositivos Móveis** da **Pontifícia Universidade Católica de Minas Gerais**.

---

## Licença

Este projeto é distribuído sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais informações.

---
