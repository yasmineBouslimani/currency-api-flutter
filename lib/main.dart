import 'package:currency_api_flutter/domain/currency.dart';
import 'package:currency_api_flutter/presentation/conversion.dart';
import 'package:currency_api_flutter/presentation/list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(CurrencyApp());
}

class CurrencyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  List<Currency> currencies;
  Currency _selected;


  @override
  void initState() {
    super.initState();
    currencies = [];
    _loadMovies().then((result) => {
          setState(() {
            currencies = result;
          })
        });
  }

  Future<List<Currency>> _loadMovies() async {
    List<Currency> currencies = [
      Currency(
          "Alien",
          "1345",
          ),
      Currency(
          "Blade",
          "2018",
          ),
      Currency(
          "Star Wars: Episode IV - A New Hope",
          "1997",
         ),
      Currency(
          "Rang De Basanti",
          "1967",
          ),
    ];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var m in currencies) {
      m.favorite = prefs.getBool(m.name) ?? false;
    }
    return currencies;
  }

  void _handleCurrency(Currency currency) {
    setState(() {
      _selected = currency;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movies",
      theme: ThemeData(
        primaryColor: const Color(0xFF303F9F),
      ),
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('PageList'),
            child: CurrencyList(currencies: currencies, onSelect: _handleCurrency),
          ),
          if (_selected != null) CurrencyPage(_selected)
        ],
        //si on peut pas retourner en arrière on retourne false
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          //sinon on reset  notre selection et on renvoit true pour que le navigateur puisse retourner en arrière
          setState(() {
            _selected = null;
          });
          return true;
        },
      ),
    );
  }
}

class CurrencyPage extends Page {
  final Currency currency;

  CurrencyPage(this.currency) : super(key: ValueKey(currency.name));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return CurrencyConversion(currency: currency);
        });
  }
}
