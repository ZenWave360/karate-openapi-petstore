package com.petstore.karate;

import com.petstore.karate.client.api.PetApi;
import com.petstore.karate.client.model.CategoryDto;
import com.petstore.karate.client.model.PetDto;
import com.petstore.karate.client.model.TagDto;
import io.github.apimock.MockServer;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.web.client.HttpClientErrorException;

import java.util.Arrays;

public class PetstoreCRUDTest {

    io.github.apimock.MockServer server;

    @Before
    public void setup() throws Exception {
        server = MockServer.builder()
                .openapi("petstore-openapi.yml")
                .features("classpath:mocks/PetMock.feature")
                .pathPrefix("api/v3")
                .http(0).build();
    }

    @Test
    public void testCrudPet() {
        PetApi petApiClient = new PetApi();
        petApiClient.getApiClient().setBasePath("http://localhost:" + server.getPort() + "/api/v3");

        PetDto pet = new PetDto();
        pet.setName("Name");
        pet.setStatus(PetDto.StatusEnum.AVAILABLE);
        pet.setTags(Arrays.asList(new TagDto().id(0L).name("dog")));
        pet.setCategory(new CategoryDto().id(0L).name("dogs"));

        // addPet
        PetDto created = petApiClient.addPet(pet);
        Assert.assertNotNull(created);
        Assert.assertNotNull(created.getId());

        PetDto found = petApiClient.getPetById(created.getId());
        Assert.assertNotNull(found);

        // updatePet
        created.setName("Updated Name");
        PetDto updated = petApiClient.updatePet(created);
        Assert.assertEquals("Updated Name", updated.getName());

        // deletePet
        petApiClient.deletePet(created.getId(), null);

        try {
            PetDto notfound = petApiClient.getPetById(created.getId());
            Assert.fail("Pet was not deleted");
        } catch (Exception e) {
            Assert.assertTrue(e instanceof HttpClientErrorException.NotFound);
        }
    }

    @After
    public void tearDown() throws Exception {
        server.stop();
    }

}
