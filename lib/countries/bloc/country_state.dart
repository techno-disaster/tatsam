part of 'country_bloc.dart';

enum CountryStatus { initial, success, failure, noConnection }

class CountryState extends Equatable {
  const CountryState({
    this.status = CountryStatus.initial,
    this.countries = const <Country>[],
    this.hasReachedMax = false,
  });

  final CountryStatus status;
  final List<Country> countries;
  final bool hasReachedMax;

  CountryState copyWith({
    CountryStatus status,
    List<Country> countries,
    bool hasReachedMax,
  }) {
    return CountryState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, countries, hasReachedMax];

  @override
  String toString() =>
      'CountrySuccess { Length : ${countries.length}, hasReachedMax: $hasReachedMax }';
}

