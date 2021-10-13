@ignore
Feature:

Scenario: Search and Recursive call (native loop)
* def petsResults = call read('PetApi/findPetsByStatus.feature@operation') { "params": {"status": "available"}}
* def petIds = karate.map(petsResults.response, (pet) => { return { params: { petId: pet.id }} }).slice(0, 10)
* call read('RecurseAndConditional.feature@getOrDeleteConditional') petIds
* print 'after getting petIds', petIds.length

@ignore @getOrDeleteConditional
Scenario: Get Or Delete (native conditional)
* def conditionalScenario = (params.petId > 0)? 'getPetById.feature@operation' : 'deletePet.feature@operation'
* call read('PetApi/' + conditionalScenario) __arg

