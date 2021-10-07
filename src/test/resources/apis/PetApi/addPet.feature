Feature: Add a new pet to the store
	Add a new pet to the store

Background:
* url baseUrl

Scenario Outline: Test addPet for <status> status code

	* def args = read(<testDataFile>)
	* def result = call read('addPet.feature@operation') args
	* match result.responseStatus == <status>
		Examples:
		| status | testDataFile |
		| 200    | 'test-data/addPet_200.yml' |
		| 400    | 'test-data/addPet_400.yml' |


@ignore @inline
Scenario: explore addPet inline
	You may use this test for quick API exploratorial purposes.
* def payload =
"""
{
  "statusCode": 200,
  "headers": {},
  "params": {},
  "body": {
    "id": 0,
    "name": "doggie",
    "category": {
      "id": 1,
      "name": "Dogs"
    },
    "photoUrls": [
      "fill some value"
    ],
    "tags": [
      {
        "id": 0,
        "name": "fill some value"
      }
    ],
    "status": "pending"
  },
  "matchResponse": true
}
"""
* call read('addPet.feature@operation') payload


@ignore @operation
Scenario: operation PetApi/addPet
* def args = 
"""
{
    auth: #(karate.get('auth')), 
    headers: #(karate.get('headers')), 
    params: #(karate.get('params')), 
    body: #(karate.get('body')), 
    statusCode: #(karate.get('statusCode')), 
    matchResponse: #(karate.get('matchResponse'))
}
"""
* def authHeader = call read('classpath:karate-auth.js') args.auth
* def headers = karate.merge(args.headers || {}, authHeader || {})
Given path '/pet'
And headers headers
And request args.body
When method POST

* def expectedStatusCode = args.statusCode || responseStatus
* match responseStatus == expectedStatusCode

* if (args.matchResponse === true) karate.call('addPet.feature@validate')

@ignore @validate
Scenario: validates addPet response

* def responseMatch =
"""
{
  "id": "##number",
  "name": "#string",
  "category": {
    "id": "##number",
    "name": "##string"
  },
  "photoUrls": "#array",
  "tags": "##array",
  "status": "##string"
}
"""
* match  response contains responseMatch

# validate nested array: photoUrls
* def photoUrls_MatchesEach = "##string"
* def photoUrls_Response = response.photoUrls || []
* match each photoUrls_Response contains photoUrls_MatchesEach
# validate nested array: tags
* def tags_MatchesEach = {"id":"##number","name":"##string"}
* def tags_Response = response.tags || []
* match each tags_Response contains tags_MatchesEach
