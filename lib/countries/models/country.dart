import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'country.g.dart';

@HiveType(typeId: 0)
class Country extends Equatable {
  @HiveField(0)
  final String countryCode;
  @HiveField(1)
  final String countryName;
  @HiveField(2)
  final String region;


  Country({
    @required this.countryCode,
    @required this.countryName,
    @required this.region,
  });

  @override
  List<Object> get props => [countryCode, countryName, region];
}
