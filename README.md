# Users Management App

A production-ready Flutter users management app backed by [DummyJSON](https://dummyjson.com/users). It demonstrates Clean Architecture, MVVM, GetX reactive state management and navigation, GetIt dependency injection, Dio networking, the Repository Pattern, Freezed models, JSON serialization, pagination, local search, error handling, and unit tests.

## Features

- Paginated user list with `limit=20` and `skip`.
- Pull-to-refresh and guarded infinite scrolling.
- Local reactive search by first name, last name, username, or email.
- User details screen with contact, personal, address, and company sections.
- Password is never included in the model or displayed in the UI.
- Explicit loading, refreshing, empty, success, pagination, and error states.
- Centralized dependency registration and mockable data-source boundaries.

## Architecture

The project follows a feature-oriented Clean Architecture flow:

```text
UI (GetX Views)
      ↓
GetX Controller / ViewModel
      ↓
UseCase
      ↓
Repository interface
      ↓
Repository implementation
      ↓
Remote data source
      ↓
Dio
      ↓
DummyJSON API
```

### MVVM + Clean Architecture

- **View:** `UserListPage`, `UserDetailsPage`, and reusable widgets render state. They do not call Dio, repositories, or use cases directly.
- **ViewModel:** `UserController` is a `GetxController`. It owns observable state and user actions such as fetch, refresh, pagination, and search.
- **Domain:** `User`, `UsersPage`, `UserRepository`, and `GetUsers` contain framework-independent business contracts.
- **Data:** `UserModel` and `UsersResponseModel` represent API data. `UserRepositoryImpl` maps models to domain entities.
- **Core:** networking, errors, constants, routes, logging, and dependency configuration are shared infrastructure.

## Folder structure

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── routes/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bindings/
│   ├── controllers/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Main dependencies

- **GetX:** reactive observables with `Obx`, `GetxController`, bindings, and route navigation.
- **GetIt:** application-level service locator. Long-lived infrastructure is registered as lazy singletons; the feature controller is registered as a factory.
- **Dio:** configured HTTP client with base URL, timeouts, headers, debug logging, and status/error mapping.
- **Dartz:** `Either<Failure, T>` keeps failures inside the domain/data boundary rather than exposing Dio exceptions to presentation.
- **Freezed + json_serializable:** immutable API models and generated JSON parsing.
- **Internet Connection Checker Plus:** network availability check before a request.
- **Mocktail:** test doubles for repositories, data sources, and use cases.

## GetIt registration choices

- `Dio`, `InternetConnection`, `NetworkInfo`, remote data source, repository, and `GetUsers` use `registerLazySingleton` because they are stateless/shared services and should be created only when first needed.
- `UserController` uses `registerFactory` because each feature binding should receive a fresh controller lifecycle.
- GetX bindings obtain the controller from GetIt; UI classes never construct dependencies directly.

## API

```text
GET https://dummyjson.com/users?limit=20&skip=0
```

The app only models fields needed by the screens. The API's `password` field is intentionally absent from `UserModel`, `User`, and all widgets.

## Setup

From the project root:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

For continuous generated-code updates:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

If starting from a new directory, ensure the package name in `pubspec.yaml` is not `provider` or another dependency name. This project uses `users_management_app`.

## Tests

```bash
flutter test
```

The test suite covers:

1. `GetUsers` use case delegation.
2. `UserRepositoryImpl` connectivity, mapping, and failure conversion.
3. `UserController` loading, pagination state, and errors.
4. `UserModel` JSON parsing and password omission.

## Request flow

1. `main()` calls `configureDependencies()` and starts `GetMaterialApp`.
2. `/users` loads `UserBinding`, which obtains `UserController` from GetIt.
3. `UserController.onInit()` calls `fetchUsers()`.
4. The controller invokes `GetUsers` with `limit=20` and the current `skip`.
5. `GetUsers` delegates to the `UserRepository` interface.
6. `UserRepositoryImpl` checks `NetworkInfo`, calls `UserRemoteDataSource`, and maps `UserModel` to `User` entities.
7. `UserRemoteDataSourceImpl` calls the configured Dio instance.
8. Dio requests DummyJSON and maps HTTP/Dio failures to application exceptions.
9. The repository converts exceptions to `Failure` values in `Either<Failure, UsersPage>`.
10. The controller appends entities to its `RxList<User>` or sets `errorMessage`.
11. `Obx` observes the controller and rebuilds only the relevant UI.
12. Scrolling near the bottom invokes guarded pagination; pull-to-refresh resets the page while preserving the refresh interaction.

## Generation and build review

Generated files are intentionally not hand-written. They are produced from the `@freezed` and `fromJson` declarations by the command above:

```text
lib/data/models/user_model.freezed.dart
lib/data/models/user_model.g.dart
lib/data/models/users_response_model.freezed.dart
lib/data/models/users_response_model.g.dart
```

After generation, run `flutter analyze` and `flutter test` to validate the local Flutter SDK and generated code.
