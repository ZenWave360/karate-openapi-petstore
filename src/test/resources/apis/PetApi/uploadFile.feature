@ignore
Feature: uploads an image
	

Background:
* url baseUrl

Scenario Outline: Test uploadFile for <status> status code
  * configure charset = null
	* def body = read(<testDataFile>)
  * def params = { petId: <petId> }
  * def statusCode = <status>
  * def matchResponse = true
	* def result = call read('uploadFile.feature@operation')
	* match result.responseStatus == <status>
		Examples:
		| status | petId | testDataFile |
		| 200    | 0     |'test-data/karate-logo.png' |


@ignore @inline
Scenario: explore uploadFile inline
	You may use this test for quick API exploratorial purposes.
* def payload =
"""
{
  "statusCode": 200,
  "headers": {},
  "params": {
    "petId": 0,
    "additionalMetadata": "fill some value"
  },
  "body": "fill some value",
  "matchResponse": true
}
"""
* call read('uploadFile.feature@operation') payload


@ignore @operation
Scenario: operation PetApi/uploadFile
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
Given path '/pet/', args.params.petId, '/uploadImage'
And param additionalMetadata = args.params.additionalMetadata
And headers headers
And request args.body
When method POST

* def expectedStatusCode = args.statusCode || responseStatus
* match responseStatus == expectedStatusCode

* if (args.matchResponse === true) karate.call('uploadFile.feature@validate')

@ignore @validate
Scenario: validates uploadFile response

* def responseMatch =
"""
{
  "code": "##number",
  "type": "##string",
  "message": "##string"
}
"""
* match  response contains responseMatch

