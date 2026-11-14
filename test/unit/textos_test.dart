import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salud_mayores/l10n/textos.dart';

/// Claves de un fichero ARB (sin las de descripción, que empiezan por "@").
Map<String, String> _textos(File fichero) => {
  for (final MapEntry(:key, :value) in (jsonDecode(
    fichero.readAsStringSync(),
  ) as Map<String, Object?>).entries)
    if (!key.startsWith('@')) key: value! as String,
};

/// Nombres de los huecos de un texto: "{hora}", "{cantidad, plural, …}".
Set<String> _huecos(String texto) => {
  for (final m in RegExp(r'\{(\w+)[,}]').allMatches(texto)) m.group(1)!,
};

void main() {
  final plantilla = _textos(File('lib/l10n/app_es.arb'));
  final traducciones = [
    for (final f in Directory('lib/l10n').listSync())
      if (f is File &&
          f.path.endsWith('.arb') &&
          !f.path.endsWith('app_es.arb'))
        f,
  ];

  test('el castellano es el primer idioma: el que se usa si no hay '
      'traducción', () {
    expect(TextosApp.supportedLocales.first, const Locale('es'));
    expect(lookupTextosApp(const Locale('es')).appTitulo, 'Salud y Medicación');
  });

  test('cada texto de app_es.arb se usa en la app', () {
    final codigo = StringBuffer();
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is File && f.path.endsWith('.dart') && !f.path.contains('l10n')) {
        codigo.write(f.readAsStringSync());
      }
    }
    final sinUsar = [
      for (final clave in plantilla.keys)
        if (!RegExp('\\.$clave(?![A-Za-z0-9_])').hasMatch('$codigo')) clave,
    ];
    expect(sinUsar, isEmpty);
  });

  test('los idiomas de lib/l10n están declarados en Android y en iOS', () {
    final idiomas = {
      'es',
      for (final f in traducciones)
        RegExp(r'app_(\w+)\.arb$').firstMatch(f.path)!.group(1)!,
    };
    Set<String> encontrados(String texto, String patron) => {
      for (final m in RegExp(patron).allMatches(texto)) m.group(1)!,
    };

    // Para elegir el idioma solo para la app (Android 13+).
    final android = File('android/app/src/main/res/xml/locales_config.xml')
        .readAsStringSync();
    expect(encontrados(android, r'<locale android:name="(\w+)"'), idiomas);

    final ios = RegExp(
      r'<key>CFBundleLocalizations</key>\s*<array>(.*?)</array>',
      dotAll: true,
    ).firstMatch(File('ios/Runner/Info.plist').readAsStringSync())!.group(1)!;
    expect(encontrados(ios, r'<string>(\w+)</string>'), idiomas);

    // Los textos del widget que se ven antes de abrir la app.
    final widget = encontrados(
      File('android/app/src/main/res/values/strings.xml').readAsStringSync(),
      r'<string name="(\w+)"',
    );
    for (final idioma in idiomas.difference({'es'})) {
      final fichero = File(
        'android/app/src/main/res/values-$idioma/strings.xml',
      );
      expect(
        encontrados(fichero.readAsStringSync(), r'<string name="(\w+)"'),
        widget,
        reason: idioma,
      );
    }

    // Los textos de los permisos de iOS (cámara y fotos).
    final permisos = encontrados(
      File('ios/Runner/Info.plist').readAsStringSync(),
      r'<key>(NS\w+UsageDescription)</key>',
    );
    for (final idioma in idiomas.difference({'es'})) {
      final fichero = File('ios/Runner/$idioma.lproj/InfoPlist.strings');
      expect(
        encontrados(fichero.readAsStringSync(), r'"(\w+)" = "'),
        permisos,
        reason: idioma,
      );
      expect(
        File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync(),
        contains('path = $idioma.lproj/InfoPlist.strings;'),
        reason: idioma,
      );
    }
  });

  for (final fichero in traducciones) {
    test('${fichero.uri.pathSegments.last} tiene los mismos textos y huecos '
        'que app_es.arb', () {
      final traduccion = _textos(fichero);
      expect(traduccion.keys.toSet(), plantilla.keys.toSet());
      for (final MapEntry(:key, :value) in plantilla.entries) {
        expect(_huecos(traduccion[key]!), _huecos(value), reason: key);
      }
    });
  }
}
