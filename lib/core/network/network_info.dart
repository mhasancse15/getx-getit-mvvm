import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

final class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectionChecker);

  final InternetConnection _connectionChecker;

  @override
  Future<bool> get isConnected => _connectionChecker.hasInternetAccess;
}
