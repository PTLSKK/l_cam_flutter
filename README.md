# L-CAM

L-Cam is an flutter project for taking an picture automatically and send it to server

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Flutter SDK installed (1.12.13+hotfix.5)
* Visual Studio Code or Android Studio

## Running the tests

This application using an mockito for unit testing and Flutter Driver for Integration Testing

### Integration Testing

Integration tests work as a pair: first, deploy an instrumented application to a real device or emulator and then “drive” the application from a separate test suite, checking to make sure everything is correct along the way.

for run the test

```
flutter drive --target=test_driver/lcam_app.dart
```

### Unit Test

A unit test tests a single function, method, or class. The goal of a unit test is to verify the correctness of a unit of logic under a variety of conditions. External dependencies of the unit under test are generally mocked out. Unit tests generally don’t read from or write to disk, render to screen, or receive user actions from outside the process running the test.


```
dart test/api_test.dart
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Flutter](https://flutter.dev/) - The framework used

## Authors

* **PT.LSKK**

## License

This project is licensed under the PT.LSKK License
