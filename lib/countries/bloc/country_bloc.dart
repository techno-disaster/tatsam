import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tatsam/countries/models/country.dart';

part 'country_event.dart';
part 'country_state.dart';

const _countryLimit = 20;

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc({@required this.httpClient}) : super(const CountryState());

  final http.Client httpClient;

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is CountryFetched) {
      yield await _mapCountryFetchedToState(state);
    }
    if (event is CountryOpened) {
      yield await _mapCountryOpenedToState(state);
    }
    if (event is CountryAddToFav) {
      yield await _mapAddCountryToFavToState(event, state);
    }
  }

  Future<CountryState> _mapAddCountryToFavToState(CountryAddToFav event, CountryState state) async {
    print(event.country.countryName);
    return state.copyWith(status: CountryStatus.success);
  }

  Future<CountryState> _mapCountryOpenedToState(CountryState state) async {
    try {
      final countries = await _fetchCountries();
      return state.copyWith(
        status: CountryStatus.success,
        countries: countries,
        hasReachedMax: _hasReachedMax(countries.length),
      );
    } on Exception catch (e) {
      print(e);
      if (e.toString() == "Exception: network_error") {
        return state.copyWith(status: CountryStatus.noConnection);
      }
      return state.copyWith(status: CountryStatus.failure);
    }
  }

  Future<CountryState> _mapCountryFetchedToState(CountryState state) async {
    if (state.hasReachedMax) {
      print("reached max");
      return state;
    }
    try {
      if (state.status == CountryStatus.initial) {
        final countries = await _fetchCountries();
        return state.copyWith(
          status: CountryStatus.success,
          countries: countries,
          hasReachedMax: _hasReachedMax(countries.length),
        );
      }
      final countries = await _fetchCountries(state.countries.length);
      return countries.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CountryStatus.success,
              countries: List.of(state.countries)..addAll(countries),
              hasReachedMax: _hasReachedMax(countries.length),
            );
    } on Exception catch (e) {
      print(e);
      if (e.toString() == "Exception: network_error") {
        return state.copyWith(status: CountryStatus.noConnection);
      }
      return state.copyWith(status: CountryStatus.failure);
    }
  }

  Future<List<Country>> _fetchCountries([int startIndex = 0]) async {
    List<Country> countries = [];
    Country country;
    try {
      final response = await httpClient.get(
        'https://api.first.org/data/v1/countries?offset=$startIndex&limit=$_countryLimit',
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = jsonResponse["data"] as Map;
        data.forEach((key, value) {
          country = Country(
            countryName: data[key]["country"],
            countryCode: key,
            region: data[key]["region"],
          );
          countries.add(country);
        });
      }
    } on SocketException {
      throw Exception("network_error");
    } catch (e) {
      throw Exception('error fetching posts');
    }
    return countries;
  }

  bool _hasReachedMax(int countryCount) {
    print("Loaded $countryCount countries in the latest req");
    return countryCount < _countryLimit ? true : false;
  }
}
