package com.petstore.karate;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.RuntimeHook;
import com.intuit.karate.cli.IdeMain;
import com.intuit.karate.core.ScenarioRuntime;
import com.intuit.karate.http.HttpRequest;
import com.intuit.karate.http.Response;
import io.github.apimock.MockServer;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static com.intuit.karate.StringUtils.join;

public class VerifyMocksTest {

    static io.github.apimock.MockServer server;
    static Map<String, List> httpCallsMap = new HashMap<>();

    @BeforeClass
    public static void setup() throws Exception {
        server = MockServer.builder()
                .openapi("petstore-openapi.yml")
                .features("classpath:mocks/PetMock.feature")
                .pathPrefix("api/v3")
                .http(0).build();
        System.setProperty("karate.server.port", server.getPort() + "");
    }

    @AfterClass
    public static void tearDown() throws Exception {
        server.stop();

        // Here you can verify how your mock behaves compared to the live API and calculate the quality and coverage of your mocks
        System.out.println("Successful Http Calls to API Server:\n\t" + join(httpCallsMap.get("HttpCalls"), "\n\t"));
        System.out.println("Failed Http Calls to API Server:\n\t" + join(httpCallsMap.get("FailedHttpCalls"), "\n\t"));
        System.out.println("Successful Http Calls to Mock Server:\n\t" + join(httpCallsMap.get("mockHttpCalls"), "\n\t"));
        System.out.println("Failed Http Calls to Mock Server:\n\t" + join(httpCallsMap.get("mockFailedHttpCalls"), "\n\t"));
    }

    @Test
    public void verifyMockServer() throws Exception {
        verifyMocks("mock");
    }

    @Test
    public void verifyAPIServer() throws Exception {
        verifyMocks("");
    }

    public void verifyMocks(String karateEnv) throws Exception {

        CoverageRuntimeHook coverageRuntimeHook = new CoverageRuntimeHook();

        Results results = Runner.path(Arrays.asList("classpath:/mocks"))
                .hook(coverageRuntimeHook)
                .tags("@mock-validation")
                .karateEnv(karateEnv)
                .parallel(1);

        httpCallsMap.put(karateEnv + "HttpCalls", coverageRuntimeHook.httpCalls);
        httpCallsMap.put(karateEnv + "FailedHttpCalls", coverageRuntimeHook.failedHttpCalls);
    }

    /**
     * Accumulates successful and failed http calls.
     */
    private class CoverageRuntimeHook implements RuntimeHook {

        List<String> httpCalls = new ArrayList<>();
        List<String> failedHttpCalls  = new ArrayList<>();
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
