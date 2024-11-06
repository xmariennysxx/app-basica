import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const Aplicacion());
}

class Aplicacion extends StatelessWidget {
  const Aplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moneda',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(206, 206, 206, 206),
        colorScheme: const ColorScheme(
          primary: Color.fromARGB(255, 144, 194, 141),
          brightness: Brightness.light,
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 82, 128, 105),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'VES';
  String toCurrency = 'USD_PARALELO';
  double result = 0.0;

  final Map<String, double> exchangeRates = {
    'VES': 1.0,
    'EUR': 45.17,
    'USD_BCV': 41.73,
    'USD_PARALELO': 49.34,
  };

  final List<String> currencies = ['VES', 'EUR', 'USD_BCV', 'USD_PARALELO'];
  final AudioPlayer player = AudioPlayer();

  void convert() {
    if (amountController.text.isEmpty) {
      return;
    }
    double amount = double.parse(amountController.text);
    if (!exchangeRates.containsKey(fromCurrency) || !exchangeRates.containsKey(toCurrency)) {
      return;
    }
    double rate = exchangeRates[toCurrency]! / exchangeRates[fromCurrency]!;
    setState(() {
      result = double.parse(amount.toStringAsFixed(2)) * rate;
    });
    player.play(AssetSource('coin_sound.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DineroFlash',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo.png',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
              ),
              DropdownButtonFormField(
                value: toCurrency,
                items: currencies.map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                )).toList(),
                onChanged: (value) => setState(() => toCurrency = value!),
              ),
              DropdownButtonFormField(
                value: fromCurrency,
                items: currencies.map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                )).toList(),
                onChanged: (value) => setState(() => fromCurrency = value!),
              ),
              ElevatedButton(
                onPressed: convert,
                child: const Text('Convertir'),
              ),
              const SizedBox(height: 20.0),
              Container(
                color: const Color.fromARGB(206, 206, 206, 206),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'TOTAL: ${NumberFormat.decimalPattern('es').format(result)} VES',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
