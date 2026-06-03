import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanterna Inteligente',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const PermissionWrapper(),
    );
  }
}

class AppCores {
  static const amarelo = Color(0xFFFFD700);
  static const cinzaEscuro = Color(0xFF1A1A1A);
  static const cinzaMedio = Color(0xFF2C2C2C);
  static const cinzaTexto = Color(0xFF888888);
  static const vermelho = Color(0xFFEF5350);
  static const azul = Color(0xFF42A5F5);
  static const verde = Color(0xFF66BB6A);
  static const roxo = Color(0xFFAB47BC);
}

class PermissionWrapper extends StatefulWidget {
  const PermissionWrapper({super.key});

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  bool _lanternaLigada = false;
  bool _modoAutomatico = false;

  @override
  void dispose() {
    if (_lanternaLigada) {
      TorchLight.disableTorch();
    }
    super.dispose();
  }

  Future<void> _alternarLanterna() async {
    try {
      if (_lanternaLigada) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }

      if (mounted) {
        setState(() {
          _lanternaLigada = !_lanternaLigada;
        });
      }
    } catch (e) {
      debugPrint('Erro ao controlar lanterna: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível acessar a lanterna'),
          ),
        );
      }
    }
  }

  void _alternarModoAutomatico(bool valor) {
    setState(() {
      _modoAutomatico = valor;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          valor
              ? 'Modo automático ativado'
              : 'Modo automático desativado',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔦 Lanterna',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _lanternaLigada
                          ? AppCores.amarelo
                          : AppCores.cinzaTexto,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _lanternaLigada ? 'LIGADA' : 'DESLIGADA',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _lanternaLigada
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _modoAutomatico
                      ? AppCores.roxo.withOpacity(0.25)
                      : AppCores.cinzaEscuro,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _modoAutomatico
                        ? AppCores.roxo
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_mode,
                      color: _modoAutomatico
                          ? AppCores.roxo
                          : AppCores.cinzaTexto,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo Automático',
                            style: TextStyle(
                              color: _modoAutomatico
                                  ? Colors.white
                                  : AppCores.cinzaTexto,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ajusta o brilho pelo sensor de luz',
                            style: TextStyle(
                              color: AppCores.cinzaTexto,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _modoAutomatico,
                      onChanged: _alternarModoAutomatico,
                      activeColor: AppCores.roxo,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: _lanternaLigada
                      ? largura * 0.45
                      : largura * 0.35,
                  height: _lanternaLigada
                      ? largura * 0.45
                      : largura * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _lanternaLigada
                        ? AppCores.amarelo.withOpacity(0.15)
                        : AppCores.cinzaEscuro,
                    boxShadow: _lanternaLigada
                        ? [
                            BoxShadow(
                              color: AppCores.amarelo.withOpacity(0.6),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                            BoxShadow(
                              color: AppCores.amarelo.withOpacity(0.3),
                              blurRadius: 100,
                              spreadRadius: 40,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _lanternaLigada
                        ? Icons.flashlight_on
                        : Icons.flashlight_off,
                    size: _lanternaLigada ? 90 : 70,
                    color: _lanternaLigada
                        ? AppCores.amarelo
                        : AppCores.cinzaTexto,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: GestureDetector(
                onTap: _alternarLanterna,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _lanternaLigada
                        ? AppCores.amarelo
                        : AppCores.cinzaMedio,
                    boxShadow: _lanternaLigada
                        ? [
                            BoxShadow(
                              color: AppCores.amarelo.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    Icons.power_settings_new,
                    size: 40,
                    color: _lanternaLigada
                        ? Colors.black
                        : AppCores.cinzaTexto,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}