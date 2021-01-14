import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tatsam/constants.dart';
import 'package:tatsam/countries/models/country.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final favCountriesBox = Hive.box(favoritesBox);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Countries"),
      ),
      body: ListView.builder(
        itemCount: favCountriesBox.length,
        itemBuilder: (context, index) {
          final country = favCountriesBox.getAt(index) as Country;
          return ListTile(
            leading: CircleAvatar(
              child: Text(country.countryCode),
            ),
            title: Text(country.countryName),
            subtitle: Text(country.region),
          );
        },
      ),
    );
  }
}
