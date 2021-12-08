@mock-validation @openapi-file=petstore-openapi.yml
Feature: Mock Validator Test

Background: 
* url baseUrl
* def auth = { username: '', password: '' }
* def authHeader = call read('classpath:karate-auth.js') auth
* configure headers = authHeader || {}

# Update an existing pet
@operationId=updatePet
Scenario: validate updatePet mock endpoint
Given def body =
"""
{
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
  "status": "available"
}
"""
Given path '/pet'
And request body
When method PUT
Then status 200

# Add a new pet to the store
@operationId=addPet
Scenario: validate addPet mock endpoint
Given def body =
"""
{
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
  "status": "available"
}
"""
Given path '/pet'
And request body
When method POST
Then status 200

# Finds Pets by status
@operationId=findPetsByStatus
Scenario: validate findPetsByStatus mock endpoint
Given def params = {"status":"available"}
Given path '/pet/findByStatus'
And param status = params.status
When method GET
Then status 200

# Finds Pets by tags
@operationId=findPetsByTags
Scenario: validate findPetsByTags mock endpoint
Given def params = {"tags":""}
Given path '/pet/findByTags'
And param tags = params.tags
When method GET
Then status 200

# Find pet by ID
@operationId=getPetById
Scenario: validate getPetById mock endpoint
Given def params = {"petId":1}
Given path '/pet/', params.petId
When method GET
Then status 200

# Deletes a pet
@operationId=deletePet
Scenario: validate deletePet mock endpoint
Given def params = {"api_key":"fill some value","petId":0}
Given path '/pet/', params.petId
When method DELETE
Then status 200

