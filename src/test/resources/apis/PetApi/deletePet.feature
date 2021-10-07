Feature: Deletes a pet
	

Background:
* url baseUrl

Scenario Outline: Test deletePet for <status> status code

	* def params = __row
	* def result = call read('deletePet.feature@operation') { statusCode: #(+params.status), params: #(params), matchResponse: #(params.matchResponse) }
	* match result.responseStatus == <status>
		Examples:
		| status | api_key         | petId | matchResponse |
		| 200    | fill some value | 0     | true          |
		| 400    | fill some value | A     | false         |


@ignore @inline
Scenario: explore deletePet inline
	You may use this test for quick API exploratorial purposes.
* def statusCode = 200
* def params = {"api_key":"fill some value","petId":0}
* def matchResponse = true
* call read('deletePet.feature@operation') 


@ignore @operation
Scenario: operation PetApi/deletePet
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
When method DELETE

* def expectedStatusCode = args.statusCode || responseStatus
* match responseStatus == expectedStatusCode

