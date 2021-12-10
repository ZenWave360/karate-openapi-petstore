@openapi-file=petstore-openapi.yml
Feature: apis PetApi PetCRUD

Background:
* url baseUrl

@business-flow 
@operationId=addPet @operationId=getPetById @operationId=updatePet @operationId=deletePet
Scenario: apis PetApi PetCRUD

* def auth = { username: '', password: '' }

# addPet 
# Add a new pet to the store
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
  "status": "sold"
}
"""
When call read('classpath:apis/PetApi/addPet.feature@operation')
Then match responseStatus == 200
* def addPetResponse = response

# getPetById 
# Find pet by ID
Given def params = {"petId": #(addPetResponse.id)}
When call read('classpath:apis/PetApi/getPetById.feature@operation')
Then match responseStatus == 200
* def getPetByIdResponse = response

# updatePet 
# Update an existing pet
Given def body = getPetByIdResponse
And set body.name = 'updated name'
When call read('classpath:apis/PetApi/updatePet.feature@operation')
Then match responseStatus == 200
* def updatePetResponse = response
* match updatePetResponse.name == 'updated name'

# deletePet 
# Deletes a pet
Given def params = {"api_key":"fill some value","petId":#(addPetResponse.id)}
When call read('classpath:apis/PetApi/deletePet.feature@operation')
Then match responseStatus == 200
* def deletePetResponse = response

# getPetById 
# Find pet by ID
Given def params = {"petId": #(addPetResponse.id)}
When call read('classpath:apis/PetApi/getPetById.feature@operation')
Then match responseStatus == 404