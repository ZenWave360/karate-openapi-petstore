@openapi-file=petstore-openapi.yml
Feature: Find pet by ID
	Returns a single pet

Background:
* url baseUrl

@operationId=getPetById
Scenario Outline: Test getPetById for <status> status code

	* def params = __row
	* def result = call read('getPetById.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <status>
		Examples:
		| status | petId | matchResponse |
		| 200    | 1     | true          |
		| 400    | A     | false         |
		| 404    | 0     | false         |


@operationId=getPetById
Scenario: explore getPetById inline
	You may use this test for quick API exploratorial purposes.
* def statusCode = 200
* def params = {"petId": 1}
* def matchResponse = true
* call read('getPetById.feature@operation') 


@ignore
@operation @operationId=getPetById @openapi-file=petstore-openapi.yml
Scenario: operation PetApi/getPetById
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
Given path '/pet/', args.params.petId
And headers headers
When method GET
# validate status code
* if (args.statusCode && responseStatus != args.statusCode) karate.fail(`status code was: ${responseStatus}, expected: ${args.statusCode}`)
# validate response body
* if (args.matchResponse === true) karate.call('getPetById.feature@validate')

@ignore @validate
Scenario: validates getPetById response

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
