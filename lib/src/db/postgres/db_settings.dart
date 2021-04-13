import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

class DbSettings {
  DbSettings(
      {required this.username,
      required this.password,
      required this.dbName,
      required this.host,
      required this.port});

  DbSettings.load() {
    _load();
  }

  static const filePath = '.settings.yaml';

  static const defaultUsername = 'conduit_test_user';
  static const defaultPassword = 'conduit!';
  static const defaultDbName = 'conduit_test_db';
  static const defaultHost = 'localhost';
  static const defaultPort = 15432;

  static const keyPostgresUsername = 'POSTGRES_USER';
  static const keyPostgresPassword = 'POSTGRES_PASSWORD';
  static const keyPSQLDbName = 'POSTGRES_DB';
  static const keyPostgresPort = 'POSTGRES_PORT';
  static const keyPostgresHost = 'POSTGRES_HOST';

  late String username;
  late String password;
  late String dbName;
  late String host;
  late int port;

  void createEnvironmentVariables() {
    env[keyPostgresHost] = host;
    env[keyPostgresPort] = '$port';
    env[keyPostgresUsername] = username;
    env[keyPostgresPassword] = password;
    env[keyPSQLDbName] = dbName;

    print('Creating environment variables for db settings.');

    print('$keyPostgresHost ${env[keyPostgresHost]}');
    print('$keyPostgresPort = ${env[keyPostgresPort]}');
    print('$keyPostgresUsername = ${env[keyPostgresUsername]}');
    print('$keyPostgresPassword = ${env[keyPostgresPassword]}');
    print('$keyPSQLDbName = ${env[keyPSQLDbName]}');
    print('');
  }

  void _load() {
    final settings = SettingsYaml.load(pathToSettings: filePath);

    username = settings[keyPostgresUsername] as String? ?? defaultUsername;
    password = settings[keyPostgresPassword] as String? ?? defaultPassword;
    dbName = settings[keyPSQLDbName] as String? ?? defaultDbName;
    host = settings[keyPostgresHost] as String? ?? defaultHost;
    port = settings[keyPostgresPort] as int? ?? defaultPort;
  }

  void save() {
    final settings = SettingsYaml.load(pathToSettings: filePath);

    settings[keyPostgresHost] = host;
    settings[keyPostgresPort] = '$port';
    settings[keyPostgresUsername] = username;
    settings[keyPostgresPassword] = password;
    settings[keyPSQLDbName] = dbName;

    settings.save();
  }
}
