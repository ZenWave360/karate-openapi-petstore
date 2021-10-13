Feature: Pet CRUD Test

Scenario: CRUD
# Crear Pet
* def pet = 
"""
{
  "id": #(Math.floor(Math.random() * 1000) + 1),
  "name": "perrito",
  "category": {
    "id": 1,
    "name": "Mascotas Peludas"
  },
  "photoUrls": [
    "http://images/tratra"
  ],
  "tags": [
    {
      "id": 0,
      "name": "perrito"
    }
  ],
  "status": "available"
}
"""
* def addPetResult = call read('PetApi/addPet.feature@operation') { body: #(pet) }

# Leer Pet creado
* def getPetResult = call read('PetApi/getPetById.feature@operation') { params: { petId: #(addPetResult.response.id) } }

# Modificando los datos del Pet
* copy createdPet = getPetResult.response
* set createdPet.tags[0].id = 10
* set createdPet.tags[0].name = 'dog'
* print createdPet

# Actualizar Pet
* def updatePetResult = call read('PetApi/updatePet.feature@operation') { body: #(createdPet) }
* print updatePetResult.response
* match updatePetResult.response.tags[0].id == 10
* match updatePetResult.response.tags[0].name == 'dog'

# Borrar el Pet 
* def deletePetResult = call read('PetApi/deletePet.feature@operation') { params: { petId: #(updatePetResult.response.id) } }
* match deletePetResult.responseStatus == 200

# Leer el Pet y ver que no esta
* def getPetResult2 = call read('PetApi/getPetById.feature@operation') { params: { petId: #(createdPet.id) } }
* match getPetResult2.responseStatus == 404