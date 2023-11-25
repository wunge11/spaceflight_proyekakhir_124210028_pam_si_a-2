import 'package:flutter/material.dart';
import 'package:units_converter/units_converter.dart';
import 'package:intl/intl.dart';

class SupportUsPage extends StatefulWidget {
  const SupportUsPage({Key? key}) : super(key: key);

  @override
  _SupportUsPageState createState() => _SupportUsPageState();
}

class _SupportUsPageState extends State<SupportUsPage> {
  TextEditingController amountController = TextEditingController();
  String selectedFromCurrency = 'USD';
  String selectedToCurrency = 'USD';
  String result = '';
  bool hover = false;

  void convertCurrency() {
    double amount = double.tryParse(amountController.text) ?? 0.0;

    // Konversi mata uang
    final Map<String, double> conversionMap = {
      'USD': 1,
      'EUR': 0.85,
      'GBP': 0.73,
      'JPY': 110.22,
      'CNY': 6.37,
      'IDR': 14337.50,
      'KRW': 1183.43,
      'MYR': 4.13,
      'SGD': 1.34,
    };

    final Map<String, String> mapSymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'IDR': 'Rp',
      'KRW': '₩',
      'MYR': 'RM',
      'SGD': 'S\$',
    };

    var customConversion = SimpleCustomProperty(conversionMap, mapSymbols: mapSymbols);
    customConversion.convert(selectedFromCurrency, amount);

    Unit targetCurrency = customConversion.getUnit(selectedToCurrency);

    // Format hasil donasi dalam format mata uang
    NumberFormat currencyFormat = NumberFormat.currency(symbol: targetCurrency.symbol, decimalDigits: 2, locale: 'id_ID');
    String formattedResult = currencyFormat.format(targetCurrency.value);

    setState(() {
      result = '$formattedResult ';
    });
  }

  void showThanksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You!'),
          content: Text('Thank you for supporting us for $result'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void donate() {
    double amount = double.tryParse(amountController.text) ?? 0.0;

    // Cek apakah jumlah donasi lebih dari 0
    if (amount > 0) {
      convertCurrency();

      Future.delayed(Duration(milliseconds: 500), () {
        showThanksDialog();
      });
    } else {
      // Tampilkan pesan jika jumlah donasi kurang dari atau sama dengan 0
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Attention!'),
            content: Text('Donation amount must be more than 0'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Support Us!",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Image.asset(
                        "asset/love.png",
                        height: 75,
                        width: 75,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Enter donation amount:'),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),
                    Text('Select currency to convert from:'),
                    DropdownButton<String>(
                      value: selectedFromCurrency,
                      onChanged: (value) {
                        setState(() {
                          selectedFromCurrency = value!;
                        });
                      },
                      items: ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'IDR', 'KRW', 'MYR', 'SGD'].map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Text('Select currency to convert to:'),
                    DropdownButton<String>(
                      value: selectedToCurrency,
                      onChanged: (value) {
                        setState(() {
                          selectedToCurrency = value!;
                        });
                      },
                      items: ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'IDR', 'KRW', 'MYR', 'SGD'].map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: convertCurrency,
                          child: Text('Convert'),
                        ),
                        ElevatedButton(
                          onPressed: donate,
                          child: Text('Donate'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: InkWell(
                onHover: (hovering) {
                  setState(() {
                    hover = hovering;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: hover ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    result.isEmpty ? 'Donation Results Will Appear Here' : result,
                    style: TextStyle(
                      color: hover ? Colors.white : Colors.black,
                    ),
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
