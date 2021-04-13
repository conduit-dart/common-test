import 'dart:io';

import 'package:dcli/dcli.dart';

import '../db/postgres/db_settings.dart';

/// Docker functions
void installDocker() {
  if (which('docker').found) {
    print('Using an existing docker install.');
    return;
  }

  if (isAptInstalled()) {
    print('Installing docker daemon');
    'apt --assume-yes install dockerd'.start(privileged: true);
  } else {
    printerr(
        red('Docker is not installed. Please install docker and start again.'));
    exit(1);
  }
}

/// Docker-Compose functions
void installDockerCompose() {
  if (which('docker-compose').found) {
    print('Using an existing docker-compose install.');
    return;
  }

  if (isAptInstalled()) {
    print('Installing docker-compose');
    'apt --assume-yes install docker-compose'.start(privileged: true);
  } else {
    printerr(red(
        'Docker-Compose is not installed. Please install docker-compose and start again.'));
    exit(1);
  }
}

/// Postgres functions
void installPostgressDaemon() {
  if (isPostgresDaemonInstalled()) {
    print('Using existing postgress daemon.');
    return;
  }

  print('Installing postgres docker image');
  'docker pull postgres'.run;
}

void installPostgresClient() {
  if (isPostgresClientInstalled()) {
    print('Using existing postgress client.');
    return;
  }

  if (isAptInstalled()) {
    print('Installing postgres client');
    'apt  --assume-yes install postgresql-client'.start(privileged: true);
  } else {
    printerr(
        red('psql is not installed. Please install psql and start again.'));
    exit(1);
  }
}

bool isPostgresClientInstalled() => which('psql').found;

void startPostgresDaemon() {
  print('Starting docker postgres image');
  'docker-compose up -d'.run;
}

void stopPostgresDaemon() {
  print('Stoping docker postgres image');
  'docker-compose down -d'.run;
}

void configurePostgress(DbSettings dbSettings,
    {required bool useDockerContainer}) {
  if (!useDockerContainer) {
    print(
        'As you have selected to use your own postgres server we can automatically create the unit test db.');
    if (confirm(
        'Do you want the conduit test database ${dbSettings.dbName}  created?')) {
      /// create user
      "psql --host=${dbSettings.hostname} --port=${dbSettings.port} -c 'create user ${dbSettings.username} with createdb;' -U postgres"
          .run;

      /// set password
      '''psql --host=${dbSettings.hostname} --port=${dbSettings.port} -c 'alter user ${dbSettings.username} with password "${dbSettings.password}";' -U postgres'''
          .run;

      /// create db
      "psql ---host=${dbSettings.hostname} -port=${dbSettings.port} -c 'create database ${dbSettings.dbName};' -U postgres"
          .run;

      /// grante permissions
      env['PGPASSWORD'] = dbSettings.password;
      "psql --host=${dbSettings.hostname} --port=${dbSettings.port} -c 'grant all on database ${dbSettings.dbName} to ${dbSettings.username};' -U postgres "
          .run;
    }
  } else {
    print('Granting access to db');
    env['PGPASSWORD'] = dbSettings.password;
    "psql --host=${dbSettings.hostname} --port=${dbSettings.port} -c 'grant all on database ${dbSettings.dbName} to ${dbSettings.username};' -U ${dbSettings.username} ${dbSettings.dbName}"
        .run;
  }
}

bool isPostgresDaemonInstalled() {
  bool found = false;
  var images = 'docker images'.toList(skipLines: 1);

  for (var image in images) {
    image = image.replaceAll('  ', ' ');
    var parts = image.split(' ');
    if (parts.isNotEmpty && parts[0] == 'postgres') {
      found = true;
      break;
    }
  }
  return found;
}

bool isAptInstalled() => which('apt').notfound;
