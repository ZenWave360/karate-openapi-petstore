# Karate OpenAPI PetStore Contract Testing Complete source code

This repo contains a complete Contract Testing solution for the online demo REST API at https://petstore3.swagger.io/

You can find very detailed instructions at:

- [From Manual to Contract Testing with KarateDSL and KarateIDE](https://medium.com/@ivangsa/from-manual-to-contract-testing-with-karatedsl-and-karateide-i-5884f1732680)
- [High Fidelity Stateful Mocks (Consumer Contracts) with OpenAPI and KarateDSL](https://medium.com/@ivangsa/high-fidelity-stateful-mocks-consumer-contracts-with-openapi-and-karatedsl-85a7f31cf84e)

## It uses:

- [KarateDSL](https://github.com/karatelabs/karate)
- [KarateDSL Mocks](https://github.com/karatelabs/karate/tree/master/karate-netty#server-life-cycle)
- [ZenWave APIMock](https://github.com/ZenWave360/zenwave-apimock)
- [org.openapi4j:openapi-operation-validator](https://www.openapi4j.org/operation-validator.html)

And [ZenWave KarateIDE VSCode extension](https://marketplace.visualstudio.com/items?itemName=KarateIDE.karate-ide): The best user experience for KarateDSL+OpenAPI... by far!!

## You may be interested in:

### Tests and Mocks

- Atomic and Data Driven Tests: https://github.com/ZenWave360/karate-openapi-petstore/tree/master/src/test/resources/apis/PetApi
- Business Flow Test (CRUD Pet): https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/resources/apis/PetApi/PetCRUD.feature
- Stateful Pet Mock: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/resources/mocks/PetMock.feature
- Mock initial DataSet is populated from: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/petstore-openapi.yml#L830
- Mock Validation Test: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/resources/mocks/mock-validation.feature

### Runners for CI/CD Test Automation

- Karate Tests Runner: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/KarateRunnerTest.java
- Karate Tests Coverage Hook: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/KarateRunnerTest.java#L77
- Mocks Validator Runner: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/VerifyMocksTest.java
- Mocks Validator Coverage Hook: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/VerifyMocksTest.java#L77

### Consumer Contract Testing and Java API

- Using Karate Mocks as Consumer Contracts in JUnit tests: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/PetstoreCRUDTest.java
- Karate Java API Example: https://github.com/ZenWave360/karate-openapi-petstore/blob/master/src/test/java/com/petstore/karate/PetDownloader.java

Best!!
