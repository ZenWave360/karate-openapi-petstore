Feature: Finds Pets by status
	Multiple status values can be provided with comma separated strings

Background:
* url baseUrl

Scenario Outline: Test findPetsByStatus for <status> status code

	* def params = __row
	* def result = call read('findPetsByStatus.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <statusCode>
		Examples:
		| statusCode | status   | matchResponse |
		| 200    | available    | true          |
	  | 200    | sold         | true          | 
		| 400    | availableXXX | false         |


@ignore @inline
Scenario: explore findPetsByStatus inline
	You may use this test for quick API exploratorial purposes.
* def statusCode = 200
* def params = {"status":"available"}
* def matchResponse = true
* call read('findPetsByStatus.feature@operation') 


@ignore @operation
Scenario: operation PetApi/findPetsByStatus
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
Given path '/pet/findByStatus'
And param status = args.params.status
And headers headers
When method GET

* def expectedStatusCode = args.statusCode || responseStatus
* match responseStatus == expectedStatusCode

* if (args.matchResponse === true) karate.call('findPetsByStatus.feature@validate')

@ignore @validate
Scenario: validates findPetsByStatus response

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
* match each response contains responseMatch

# validate nested array: photoUrls
* def photoUrls_MatchesEach = "##string"
* def photoUrls_Response = response.photoUrls || []
* match each photoUrls_Response contains photoUrls_MatchesEach
# validate nested array: tags
* def tags_MatchesEach = {"id":"##number","name":"##string"}
* def tags_Response = response.tags || []
* match each tags_Response contains tags_MatchesEach
