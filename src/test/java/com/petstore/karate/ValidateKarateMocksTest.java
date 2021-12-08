package com.petstore.karate;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.RuntimeHook;
import com.intuit.karate.StringUtils;
import com.intuit.karate.cli.IdeMain;
import com.intuit.karate.core.ScenarioRuntime;
import com.intuit.karate.http.HttpRequest;
import com.intuit.karate.http.Response;

import org.junit.After;
import org.junit.Before;
import org.junit.jupiter.api.Test;

import io.github.apimock.MockServer;

public class ValidateKarateMocksTest {

    private String classpath = "classpath:";

    io.github.apimock.MockServer server;

    @Before
    public void setup() throws Exception {
        server = MockServer.builder()
                .openapi("petstore-openapi.yml")
                .features("classpath:mocks/PetMock.feature")
                .pathPrefix("api/v3")
                .http(0).build();
        System.setProperty("karate.server.port", server.getPort() + "");
    }

    @After
    public void tearDown() throws Exception {
        server.stop();
    }

    @Test
    public void validateKarateMocks() throws Exception {

        String karateEnv = defaultString(System.getProperty("karate.env"), "mock").toLowerCase();
        String launchCommand = defaultString(System.getProperty("KARATE_OPTIONS"), "-t @mock-validation " + classpath);

        com.intuit.karate.Main options = IdeMain.parseIdeCommandLine(launchCommand);

        Results results = Runner.path(Optional.ofNullable(options.getPaths()).orElse(Arrays.asList(classpath)))
                .hook(coverageRuntimeHook)
                .tags(options.getTags())
                .configDir(options.getConfigDir())
                .karateEnv(karateEnv)
                .outputHtmlReport(true)
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .parallel(options.getThreads());

        // here you can analyze/process coverage
        System.out.println("SUCCESS ENDPOINTS");
        System.out.println(StringUtils.join(httpCalls, "\n"));
        System.out.println("FAILED ENDPOINTS");
        System.out.println(StringUtils.join(failedHttpCalls, "\n"));
    }

    private String defaultString(String value, String defaultValue) {
        return value == null ? defaultValue : value;
    }

    List<String> httpCalls = new ArrayList<>();
    List<String> failedHttpCalls = new ArrayList<>();
    private RuntimeHook coverageRuntimeHook = new RuntimeHook() {

        List<String> scenarioHttpCalls = null;

        @Override
        public boolean beforeScenario(ScenarioRuntime sr) {
            scenarioHttpCalls = new ArrayList<>();
            return true;
        }

        @Override
        public void afterHttpCall(HttpRequest request, Response response, ScenarioRuntime sr) {
            scenarioHttpCalls.add(String.format("%s %s %s", request.getMethod(), request.getUrl(), response.getStatus()));
        }

        @Override
        public void afterScenario(ScenarioRuntime sr) {
            (sr.isFailed()? failedHttpCalls : httpCalls).addAll(scenarioHttpCalls);
        }
    };
}
