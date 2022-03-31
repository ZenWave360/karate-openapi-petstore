package com.petstore.karate;

import com.intuit.karate.Http;
import com.intuit.karate.Json;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * This is an example about how to use Karate Java API to pre-fetch test data from a remote API to a json file that can be used as a local data-store in your API tests.
 * <p>
 * This helps solving the hard problem of everchanging data in testing evironments, where entities came and go as they change state...
 *
 * @author ivangsd
 */
public class PetDownloader {

    private final String baseUrl;

    public PetDownloader(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    /**
     * This method downloads from remote API to a json file: 3 Dogs available, 3 Dogs sold, 3 Lions available and 3 Lions sold.
     *
     * @param targetJsonFile File to write downloaded pet objects as a json array.
     */
    public void fetchPets(File targetJsonFile) throws IOException {
        Json availablePets = Http.to(baseUrl + "/pet/findByStatus?status=available").get().json();
        List<Object> availableDogs = availablePets.get("$.[?(@.category.name==\"Dogs\")]");
        List<Object> availableLions = availablePets.get("$.[?(@.category.name==\"Lions\")]");

        Json soldPets = Http.to(baseUrl + "/pet/findByStatus?status=sold").get().json();
        List<Object> soldDogs = availablePets.get("$.[?(@.category.name==\"Dogs\")]");
        List<Object> soldLions = availablePets.get("$.[?(@.category.name==\"Lions\")]");

        List<Object> localDataStore = new ArrayList<>();
        localDataStore.addAll(availableDogs.subList(0, Math.max(3, availableLions.size())));
        localDataStore.addAll(soldDogs.subList(0, Math.max(3, soldLions.size())));

        String json = Json.of(localDataStore).toStringPretty();
        Files.write(Paths.get(targetJsonFile.toURI()), json.getBytes(StandardCharsets.UTF_8));
    }

    public static void main(String[] args) throws IOException {
        String baseUrl = "https://petstore3.swagger.io/api/v3";
        File targetJsonFile = new File("target/LocalPetDataStore.json");
        new PetDownloader(baseUrl).fetchPets(targetJsonFile);
    }
}
