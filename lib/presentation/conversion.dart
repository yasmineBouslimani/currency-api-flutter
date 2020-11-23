import 'package:flutter/material.dart';
import 'package:currency_api_flutter/config/config.dart';
import 'package:currency_api_flutter/domain/currency.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConversion extends StatefulWidget {
  final Currency currency;

  CurrencyConversion({@required this.currency});

  @override
  State<StatefulWidget> createState() =>
      CurrencyConversionState(currency: currency);
}

class CurrencyConversionState extends State<CurrencyConversion> {
  List lettersCurrencyList = [];
  List entireNameCurrencyList = [];
  Map<dynamic, dynamic> currencyList;
  String currencyResult = "";
  String _firstCurrencySelected = "EUR";
  String _secondCurrencySelected = "USD";
  final Currency currency;
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  Map<dynamic, dynamic> resultat = {};
  bool _favoriteCurrency = false;

  CurrencyConversionState({@required this.currency}) {
    _getLettersCurrencyList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Convertisseur de devises"), actions: []),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 20.0, left: 20.0),
                    padding: EdgeInsets.only(right: 50.0, left: 50.0),
                    child: Card(
                        child: TextField(
                      controller: myController,
                      decoration: InputDecoration(labelText: " Montant"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ], // Only numbers can be entered
                    ))),
                Text("De", style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                    margin: EdgeInsets.only(right: 20.0, left: 20.0),
                    padding: EdgeInsets.only(right: 50.0, left: 50.0),
                    child: Card(
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: _getFirstDropdownList()))),
                Text("À", style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                    margin: EdgeInsets.only(right: 20.0, left: 20.0),
                    padding: EdgeInsets.only(right: 50.0, left: 50.0),
                    child: Card(
                        child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: _getSecondDropdownList(),
                    ))),
                Container(
                    padding: const EdgeInsets.only(
                        left: 150.0, top: 5.0, bottom: 10.0),
                    child: new RaisedButton(
                      child: const Text('Convertir'),
                      onPressed: () => _getConversionResponse(),
                    )),
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Text.rich(TextSpan(
                        text: myController.text +
                            " " +
                            _firstCurrencySelected +
                            " vaut ",
                        children: <TextSpan>[
                          TextSpan(
                              text: currencyResult.toString() +
                                  " " +
                                  _secondCurrencySelected,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ))
                    ])),
                Expanded(
                    child: ListView(children: [
                  for (var currencie in currencyList.entries)
                    ListTile(
                        title: Text(currencie.value),
                        trailing: IconButton(
                          icon: Icon(Icons.star,
                              color: _favoriteCurrency
                                  ? Colors.amber[600]
                                  : Colors.black),
                          tooltip: "Ajouter cette devise à ses favoris",
                        ),
                        onTap: () {
                          setState(() {
                            _favoriteCurrency = true;
                          });
                        })
                ]))
              ],
            )));
  }

  List<Widget> _getFirstDropdownList() {
    List<Widget> formWidget = new List();
    formWidget.add(new DropdownButton(
      items: currencyList.entries.map((item) {
        return DropdownMenuItem(
          child: Text(item.value + " (" + item.key + " )"),
          value: item.key.toString(),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _firstCurrencySelected = newVal;
        });
      },
      value: _firstCurrencySelected,
    ));
    return formWidget;
  }

  List<Widget> _getSecondDropdownList() {
    List<Widget> formWidget = new List();
    formWidget.add(new DropdownButton(
      items: currencyList.entries.map((item) {
        return DropdownMenuItem(
          child: Text(item.value + " (" + item.key + " )"),
          value: item.key.toString(),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _secondCurrencySelected = newVal;
        });
      },
      value: _secondCurrencySelected,
    ));
    return formWidget;
  }

  Future<dynamic> _getLettersCurrencyList() async {
    const String _baseUrl = "https://currency26.p.rapidapi.com/list";
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": "currency26.p.rapidapi.com",
      "x-rapidapi-key": Config.CURRENCY_APP_KEY,
    };
    final response = await http.get(_baseUrl, headers: _headers);
    var jsonResponse = jsonDecode(response.body);
    Map<dynamic, dynamic> currencyListResponse = jsonResponse;
    setState(() {
      print(currencyList);
      currencyList = currencyListResponse;
    });
  }

  Future<dynamic> _getConversionResponse() async {
    const String _baseUrl = "https://currency26.p.rapidapi.com/convert/";
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": "currency26.p.rapidapi.com",
      "x-rapidapi-key": Config.CURRENCY_APP_KEY,
    };
    var uri = (_baseUrl +
        _firstCurrencySelected +
        "/" +
        _secondCurrencySelected +
        "/" +
        myController.text);
    final response = await http.get(uri, headers: _headers);
    var result = json.decode(response.body);
    var resulat = result.values.toList().first;
    var resultat = resulat.toString();
    setState(() {
      currencyResult = resultat;
    });
  }

/* Widget _getConversionResponseText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text (currencyResult, style: TextStyle(
          fontSize: 40,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.indigo[700],)),
      ],
    );
  }*/
}
