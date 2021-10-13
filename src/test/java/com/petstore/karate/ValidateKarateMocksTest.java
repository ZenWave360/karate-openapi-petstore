package com.petstore.karate;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.cli.IdeMain;
import com.intuit.karate.core.MockServer;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.Collection;
import java.util.Optional;
import java.util.stream.Collectors;

public class ValidateKarateMocksTest {

    private String classpath = "classpath:apis/";

    static MockServer server;

    @BeforeAll
    static void beforeAll() {
        server = MockServer
                .feature("classpath:mocks/PetMock/PetMock.feature")
                .pathPrefix("api/v3")
                .http(3000).build();
        System.setProperty("karate.server.port", server.getPort() + "");
    }

    @Test
    public void run() throws Exception {

        String karateEnv = defaultString(System.getProperty("karate.env"), "mock").toLowerCase();
        String launchCommand = defaultString(System.getProperty("KARATE_OPTIONS"), "-t ~@ignore " + classpath);

        com.intuit.karate.Main options = IdeMain.parseIdeCommandLine(launchCommand);

        Results results = Runner.path(Optional.ofNullable(options.getPaths()).orElse(Arrays.asList(classpath)))
                .hooks(options.createHooks())
                .tags(options.getTags())
                .configDir(options.getConfigDir())
                .karateEnv(karateEnv)
                .outputHtmlReport(true)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .parallel(options.getThreads());

        Assertions.assertEquals(0, results.getFailCount());
    }

    private String defaultString(String value, String defaultValue) {
        return value == null ? defaultValue : value;
    }

}
