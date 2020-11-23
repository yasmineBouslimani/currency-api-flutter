import 'package:flutter/material.dart';
import 'package:currency_api_flutter/domain/currency.dart';

class CurrencyList extends StatelessWidget {
  final List<Currency> currencies;
  final ValueChanged<Currency> onSelect;

  CurrencyList({@required this.currencies, @required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          for (var currency in currencies)
            ListTile(
              title: Text(currency.name),
              //  subtitle: Text(movie.year),
              trailing: IconButton(
                icon: Icon(Icons.star,
                    color: currency.favorite ? Colors.amber[600] : Colors.black),
              ),
              onTap: () => onSelect(currency),
            )
        ]));
  }
}
