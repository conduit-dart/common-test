import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

class DbSettings {
  DbSettings(
      {required this.username,
      required this.password,
      required this.dbName,
      required this.hostname,
      required this.port});

  DbSettings.load() {
    _load();
  }

  static const filePath = '.settings.yaml';

  static const defaultUsername = 'conduit_test_user';
  static const defaultPassword = '34achfAdce';
  static const defaultDbName = 'conduit_test_db';
  static const defaultHost = 'localhost';
  static const defaultPort = 15432;

  static const keyPSQLUsername = 'POSTGRES_USER';
  static const keyPSQLPassword = 'POSTGRES_PASSWORD';
  static const keyPSQLDbName = 'POSTGRES_DB';
  static const keyPSQLPort = 'POSTGRES_PORT';
  static const keyPSQLHostname = 'POSTGRES_HOSTNAME';

  late String username;
  late String password;
  late String dbName;
  late String hostname;
  late int port;

  void createEnvironmentVariables() {
    env[keyPSQLHostname] = hostname;
    env[keyPSQLPort] = '$port';
    env[keyPSQLUsername] = username;
    env[keyPSQLPassword] = password;
    env[keyPSQLDbName] = dbName;
  }

  void _load() {
    var settings = SettingsYaml.load(pathToSettings: filePath);

    username = settings[keyPSQLUsername] as String? ?? defaultUsername;
    password = settings[keyPSQLPassword] as String? ?? defaultPassword;
    dbName = settings[keyPSQLDbName] as String? ?? defaultDbName;
    hostname = settings[keyPSQLHostname] as String? ?? defaultHost;
    port = settings[keyPSQLPort] as int? ?? defaultPort;
  }

  void save() {
    var settings = SettingsYaml.load(pathToSettings: filePath);

    settings[keyPSQLHostname] = hostname;
    settings[keyPSQLPort] = '$port';
    settings[keyPSQLUsername] = username;
    settings[keyPSQLPassword] = password;
    settings[keyPSQLDbName] = dbName;

    settings.save();
  }
}
