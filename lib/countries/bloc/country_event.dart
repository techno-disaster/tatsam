part of 'country_bloc.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class CountryOpened extends CountryEvent {}

class CountryFetched extends CountryEvent {}

class CountryAddToFav extends CountryEvent {
  final Country country;

  CountryAddToFav(this.country);
  @override
  List<Object> get props => [country];
}
