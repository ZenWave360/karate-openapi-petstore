@openapi-file=petstore-openapi.yml
Feature: Finds Pets by tags
	Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.

Background:
* url baseUrl

@operationId=findPetsByTags
Scenario Outline: Test findPetsByTags for <status> status code

	* def params = __row
	* def result = call read('findPetsByTags.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <status>
		Examples:
		| status | tags | matchResponse |
		| 200    | DOG  | true          |
		| 400    |      | false         |


@operationId=findPetsByTags
Scenario: explore findPetsByTags inline
	You may use this test for quick API exploratorial purposes.
* def statusCode = 200
* def params = {"tags":"DOG"}
* def matchResponse = true
* call read('findPetsByTags.feature@operation') 


@ignore
@operation @operationId=findPetsByTags @openapi-file=petstore-openapi.yml
Scenario: operation PetApi/findPetsByTags
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
Given path '/pet/findByTags'
And param tags = args.params.tags
And headers headers
When method GET
# validate status code
* if (args.statusCode && responseStatus != args.statusCode) karate.fail(`status code was: ${responseStatus}, expected: ${args.statusCode}`)
# validate response body
* if (args.matchResponse === true) karate.call('findPetsByTags.feature@validate')

@ignore @validate
Scenario: validates findPetsByTags response

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
