import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:tatsam/constants.dart';
import 'package:tatsam/countries/bloc/country_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tatsam/countries/models/country.dart';
import 'package:tatsam/screens/favourites.dart';

class CountryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouritesPage()),
              );
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (_) => CountryBloc(httpClient: http.Client())..add(CountryOpened()),
        child: CountryList(),
      ),
    );
  }
}

class CountryList extends StatefulWidget {
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  final _scrollController = ScrollController();
  CountryBloc _countrybloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _countrybloc = context.read<CountryBloc>();
  }

  Widget getIcon(Country country) {
    final favCountriesBox = Hive.box(favoritesBox);
    if (favCountriesBox.containsKey(country.countryCode)) {
      return Icon(Icons.favorite, color: Colors.red);
    }
    return Icon(Icons.favorite_border);
  }

  void onFavoritePress(Country country) {
    final favCountriesBox = Hive.box(favoritesBox);
    if (favCountriesBox.containsKey(country.countryCode)) {
      favCountriesBox.delete(country.countryCode);
      return;
    }
    favCountriesBox.put(country.countryCode, country);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        switch (state.status) {
          case CountryStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case CountryStatus.noConnection:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                        'Please check your network connectivity. you can still view yoou favourite countries'),
                  ),
                  MaterialButton(
                    child: Text(
                      "Favourite Countries",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavouritesPage()),
                    ),
                  )
                ],
              ),
            );
          case CountryStatus.success:
            if (state.countries.isEmpty) {
              return const Center(child: Text('no countries'));
            }
            return _buildListView(state);
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ListView _buildListView(CountryState state) {
    final favCountriesBox = Hive.box(favoritesBox);
    print(favCountriesBox.keys);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return index >= state.countries.length
            ? BottomLoader()
            : ListTile(
                leading: CircleAvatar(
                  child: Text(state.countries[index].countryCode),
                ),
                onTap: () {
                  setState(() {
                    onFavoritePress(state.countries[index]);
                  });
                },
                title: Text(state.countries[index].countryName),
                subtitle: Text(state.countries[index].region),
                trailing: getIcon(state.countries[index]),
              );
      },
      itemCount: state.hasReachedMax ? state.countries.length : state.countries.length + 1,
      controller: _scrollController,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    Hive.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      print("reached bottom");
      _countrybloc.add(CountryFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll);
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
