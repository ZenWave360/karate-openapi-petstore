package com.petstore.karate;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.cli.IdeMain;
import org.junit.jupiter.api.Assertions;
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

public class KarateRunnerTest {

    private String classpath = "classpath:apis/";

    @Test
    public void run() throws Exception {

        String karateEnv = defaultString(System.getProperty("karate.env"), "local").toLowerCase();
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

        moveJUnitReports(results.getReportDir(), "target/surefire-reports");

        Assertions.assertEquals(0, results.getFailCount());
    }
    
    public static void moveJUnitReports(String karateReportDir, String surefireReportDir) throws IOException {
        new File(surefireReportDir).mkdirs();
        Collection<File> xmlFiles = Files.find(Paths.get(karateReportDir), Integer.MAX_VALUE,
                (filePath, fileAttr) -> fileAttr.isRegularFile() && filePath.toString().endsWith(".xml"))
                .map(p -> p.toFile()).collect(Collectors.toList());

        xmlFiles.forEach((x) -> {
            try {
                Files.copy(x.toPath(), Paths.get(surefireReportDir, "/TEST-" + x.getName()), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException var3) {
                var3.printStackTrace();
            }

        });
    }
    
    private String defaultString(String value, String defaultValue) {
        return value == null ? defaultValue : value;
    }

}
