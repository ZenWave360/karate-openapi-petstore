Feature: PetMock Mock

Background: 
* configure cors = true
* configure responseHeaders = { 'Content-Type': 'application/json' }
* def uuid = () => java.util.UUID.randomUUID() + '';
* def apis = {};
* def isInteger = (value) => parseInt(value) == value;
* def petRequestSchema =
"""
{
    "id": "##number",
    "name": "#string",
    "category": "##object",
    "category.id": "##number",
    "category.name": "##string",
    "photoUrls": "##array",
    "tags": "##array",
    "status": "##string"
}
"""

# Update an existing pet
@updatePet
Scenario:  methodIs('put') && pathMatches('/pet')
 * def validRequest = karate.match(request, petRequestSchema).pass
 * if (!validRequest) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('updatePet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Add a new pet to the store
@addPet
Scenario:  methodIs('post') && pathMatches('/pet')
 * def validRequest = karate.match(request, petRequestSchema).pass
 * if (!validRequest) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('addPet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Finds Pets by status
@findPetsByStatus
Scenario:  methodIs('get') && pathMatches('/pet/findByStatus')
 * def status = paramValue('status')
 * if (!['available', 'sold'].includes(status)) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('findPetsByStatus_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Finds Pets by tags
@findPetsByTags
Scenario:  methodIs('get') && pathMatches('/pet/findByTags')
 * if (!paramExists('tags')) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('findPetsByTags_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Find pet by ID
@getPetById
Scenario:  methodIs('get') && pathMatches('/pet/{petId}')
 * if (!isInteger(pathParams.petId)) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('getPetById_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Deletes a pet
@deletePet
Scenario:  methodIs('delete') && pathMatches('/pet/{petId}')
 * if (!isInteger(pathParams.petId)) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('deletePet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# uploads an image
@uploadFile
Scenario:  methodIs('post') && pathMatches('/pet/{petId}/uploadImage')
 * def validRequest = karate.match(request, petRequestSchema).pass
 * if (!validRequest) { karate.set('responseStatus', 400); karate.abort(); }
 * def responseFile = read('uploadFile_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

