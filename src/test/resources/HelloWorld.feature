Feature: Hello World Karate

Scenario: Hello World Karate
Given url 'https://petstore3.swagger.io/api/v3/pet/0'
When method get
Then status 200
* print response

