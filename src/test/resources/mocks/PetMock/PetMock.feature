Feature: PetMock Mock

Background: 
* configure cors = true
* configure responseHeaders = { 'Content-Type': 'application/json' }
* def uuid = () => java.util.UUID.randomUUID() + '';
* def apis = {};

# Update an existing pet
@updatePet
Scenario:  methodIs('put') && pathMatches('/pet')
 * def responseFile = read('updatePet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Add a new pet to the store
@addPet
Scenario:  methodIs('post') && pathMatches('/pet')
 * def responseFile = read('addPet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Finds Pets by status
@findPetsByStatus
Scenario:  methodIs('get') && pathMatches('/pet/findByStatus')
 * def responseFile = read('findPetsByStatus_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Finds Pets by tags
@findPetsByTags
Scenario:  methodIs('get') && pathMatches('/pet/findByTags')
 * def responseFile = read('findPetsByTags_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Find pet by ID
@getPetById
Scenario:  methodIs('get') && pathMatches('/pet/{petId}')
 * def responseFile = read('getPetById_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# Deletes a pet
@deletePet
Scenario:  methodIs('delete') && pathMatches('/pet/{petId}')
 * def responseFile = read('deletePet_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

# uploads an image
@uploadFile
Scenario:  methodIs('post') && pathMatches('/pet/{petId}/uploadImage')
 * def responseFile = read('uploadFile_200.yml')
 * def response = responseFile.response
 * def responseStatus = responseFile.responseStatus || 200

