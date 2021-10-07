Feature: Update an existing pet
	Update an existing pet by Id

Background:
* url baseUrl

Scenario Outline: Test updatePet for <status> status code

	* def args = read(<testDataFile>)
	* def result = call read('updatePet.feature@operation') args
	* match result.responseStatus == <status>
		Examples:
		| status | testDataFile |
		| 200    | 'test-data/updatePet_200.yml' |
		| 400    | 'test-data/updatePet_400.yml' |
		| 404    | 'test-data/updatePet_404.yml' |
    # | 405    | 'test-data/updatePet_405.yml' |


@ignore @inline
Scenario: explore updatePet inline
	You may use this test for quick API exploratorial purposes.
* def payload =
"""
{
  "statusCode": 200,
  "headers": {},
  "params": {},
  "body": {
    "id": 10,
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
* call read('updatePet.feature@operation') payload


@ignore @operation
Scenario: operation PetApi/updatePet
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
When method PUT

* def expectedStatusCode = args.statusCode || responseStatus
* match responseStatus == expectedStatusCode

* if (args.matchResponse === true) karate.call('updatePet.feature@validate')

@ignore @validate
Scenario: validates updatePet response

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
