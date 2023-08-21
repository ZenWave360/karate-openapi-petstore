package com.petstore.karate;

import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import com.intuit.karate.FileUtils;
import org.openapi4j.core.exception.ResolutionException;
import org.openapi4j.core.validation.ValidationException;
import org.openapi4j.operation.validator.model.Response;
import org.openapi4j.operation.validator.model.impl.Body;
import org.openapi4j.operation.validator.model.impl.DefaultResponse;
import org.openapi4j.operation.validator.validation.RequestValidator;
import org.openapi4j.parser.OpenApi3Parser;
import org.openapi4j.parser.model.v3.MediaType;
import org.openapi4j.parser.model.v3.OpenApi3;
import org.openapi4j.parser.model.v3.Operation;
import org.openapi4j.parser.model.v3.Path;
import net.minidev.json.JSONObject;
import org.openapi4j.schema.validator.ValidationContext;
import org.openapi4j.schema.validator.v3.ValidationOptions;

/**
 * OpenApi validator for Karate tests.
 * 
 * Config in karate-config.js:
 * 
 * <pre>
 * return {
 *   //...
 *   openApiValidator: Java.type('com.petstore.karate.OpenApiValidator')
 *     .fromClasspath('<openapi file>'),
 *   openApiValidator: Java.type('com.petstore.karate.OpenApiValidator')
 *     .fromClasspathInArtifactId('<artifactId>', '<openapi file>'),
 *   openApiValidator: Java.type('com.petstore.karate.OpenApiValidator')
 *     .fromURL('file:./target/tmp/openapi/rest/openapi-rest.yml'),
 * }
 * </pre>
 * 
 * Usage in karate features:
 * 
 * <pre>
 * * assert karate.get('openApiValidator').isValid(response, responseHeaders, '<operationId>', responseStatus)
 * </pre>
 * 
 * @author ivangsa@gmail.com
 *
 */
public class OpenApiValidator {

    private final OpenApi3 api;

    private final RequestValidator validator;

    public OpenApiValidator(final OpenApi3 api) {
        super();
        this.api = api;
        ValidationContext vdc = new ValidationContext<>(api.getContext());
        vdc.setOption(ValidationOptions.ADDITIONAL_PROPS_RESTRICT, true);
        vdc.setFastFail(false);
        this.validator = new RequestValidator(vdc, api);
    }

    public static OpenApiValidator fromClasspath(String filename) throws Exception {
        final URL url = OpenApiValidator.class.getClassLoader().getResource(filename);
        return fromURL(url);
    }

    public static OpenApiValidator fromClasspathInArtifactId(final String artifactId, String filename) throws Exception {
        final Pattern regex = Pattern.compile("\\/" + artifactId + "(\\/|-.+.jar)");
        final Enumeration<URL> urls = OpenApiValidator.class.getClassLoader().getResources(filename);
        while (urls.hasMoreElements()) {
            final URL url = urls.nextElement();
            if (regex.matcher(url.getFile()).find()) {
                return fromURL(url);
            }
        }
        throw new RuntimeException(
                "Resource 'rest/openapi-rest.yml' not found in classpath with artifactId " + artifactId);
    }

    public static OpenApiValidator fromURL(final URL url) {
        try {
            return new OpenApiValidator(new OpenApi3Parser().parse(url, false));
        } catch (ResolutionException | ValidationException e) {
            throw new RuntimeException(e);
        }
    }

    public static OpenApiValidator fromURL(final String url) throws MalformedURLException {
        return fromURL(new URL(url));
    }

    public static OpenApiValidator fromFile(final String url) throws MalformedURLException {
        return fromURL(new java.io.File(url).toURI().toURL());
    }

    public OpenApi3 getApi() {
        return api;
    }

    public boolean isValid(
            final Object karateResponse,
            final Map responseHeaders,
            final String operationId,
            final int status)
            throws ValidationException {
System.out.println("karateResponse: " + karateResponse);
        final Response response = new DefaultResponse.Builder(status)
            .headers(responseHeaders)
            .body(Body.from(this.getKarateResponseBody(karateResponse)))
            .build();
        final Path path = this.api.getPathItemByOperationId(operationId);
        final Operation operation = this.api.getOperationById(operationId);
        if (operation.getResponse(String.valueOf(status)) == null) {
            // response code is not defined
            System.out.println("Response code " + status + " is not defined for operation " + operationId);
            return false;
        }
        final Map<String, MediaType> mediaTypes = this.getMediaTypes(operation, response.getStatus());
        if ((mediaTypes == null) || mediaTypes.isEmpty()) {
            // ignore errors for codes with no specific response body in openapi.yml
            return true;
        }

        try {
            this.validator.validate(response, path, operation);
        } catch (ValidationException e) {
            e.printStackTrace();
            System.out.println(e);
            return false;
        }
        return true;
    }

    protected String getKarateResponseBody(final Object response) {
        return response instanceof JSONObject ? ((JSONObject) response).toJSONString()
                : response.toString();
    }

    protected Map<String, MediaType> getMediaTypes(final Operation operation, final int status) {
        org.openapi4j.parser.model.v3.Response response = operation.getResponse(String.valueOf(status));
        if (response.getRef() != null) {
            response = this.api.getComponents()
                .getResponse(response.getRef().substring(response.getRef().lastIndexOf('/') + 1));
        }
        return response.getContentMediaTypes();
    }

    public static void main(String[] args) throws Exception {
        String json = Files.readString(java.nio.file.Path.of("response.json"));
        OpenApiValidator validator = OpenApiValidator.fromFile("openapi-rest.yml");
        Map headers = new HashMap();
        headers.put("Content-Type", Arrays.asList("application/json; charset=utf-8"));
        boolean isValid = validator.isValid(json, headers, "operationId", 200);
        System.out.println("isValid " + isValid);
    }
}