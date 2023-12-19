# Riverpod Paginated Views

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

🤖 Generated via [Riverpod Core Brick][riverpod_core_brick_link]

An example repository meant to show how to handle complex pagination cases, with business logic tests.

---

## Usage 💯

For a clean run, remember, use:

```sh
flutter clean && flutter pub get  && dart run build_runner build -d
```

Wait until this process is done. It can take a minute~ish.

### Supported platforms
This application currently supports android, ios.

### Dev server

When you're ready to see this application in action (debug mode), you can run:

```sh
# Development
$ flutter run
```

...And look at this software go!

### Build

Building an application can be done through `flutter build`, but it's recommended to set up a CI/CD tool before releasing a staging or a production-ready executable.

---

## Internals ⚙️

A few notes about this application (feel free to customize for info, warnings and stuff).

### Architecture
This project uses [well-known Clean Architecture][clean-arch-link] principles, with
[a pinch of pragmatism][clean-arch-riverpod-repo-example-link].

### Libraries
Here's a quick recap of the libraries used in this project:
  - `riverpod` (with the `riverpod_hooks` variant), as state management / caching / DI solution
  - `flutter_hooks` to easily handle ephimeral state
  - `riverpod_generator` to supercharge `riverpod`
  - `riverpod_lint` for a set of great riverpod-related lints
  - `freezed`
  - `equatable` to help testability / ease of use  
  - `very_good_analysis` for a set of well-known lints

---

## Tests 🧪

To run this repo's tests, you can use:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "New Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:{{name.snakeCase()}}/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```


[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[riverpod_core_brick_link]: https://github.com/lucavenir/riverpod_core_brick
[clean-arch-link]: https://www.oreilly.com/library/view/clean-architecture-a/9780134494272/
[clean-arch-riverpod-repo-example-link]: https://github.com/lucavenir/riverpod_architecture_example
