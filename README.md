DogAPIApp README
==================

DogAPIApp is an application specificaly made to utilise and demo DogAPIPackage.

Prerequisites
-----

* Xcode 14.2

Architecture
------------

Simple approach to MVVM combining protocol oriented programming and to inject dependencies into the constructor to maximize the testability of the code.
Third party libraries are wrapped in repository-like classes, because the best approach to MVVM means that the only import in the view model files are only techology related, in other words we test for the repositories are called and how the returned data is used not if the third party works correctly.

Testing
-------

No specific Framework is used for unit testing (except of course XCTest).

I utilise [CombineTestExtensions](https://github.com/industrialbinaries/CombineTestExtensions) to test Combine @Published properties, the rest is tested based on things I have learned with experience.
