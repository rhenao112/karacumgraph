package com.sophossolutions.runners;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

public class PararellExecution {

	private static final String FORMAT_FILES = "json";
	private static final String PATH_REPORT = "target";
	private static final String NAME_REPORT = "Example Karate + GraphQL";

	@Test
	void testParallel() {
		Results results = Runner.path("classpath:com/sophossolutions/features/funtional_graphql.feature",
				"classpath:com/sophossolutions/features/validate_scheme_contract.feature").parallel(3);
		createCucumberReport(results.getReportDir());
		assertEquals(0, results.getFailCount(), results.getErrorMessages());
	}

	private static void createCucumberReport(String karateOutputPath) {

		Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] { FORMAT_FILES },
				Boolean.TRUE);
		List<String> jsonPaths = new ArrayList<String>(jsonFiles.size());
		jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
		Configuration config = new Configuration(new File(PATH_REPORT), NAME_REPORT);
		ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
		reportBuilder.generateReports();
	}
}

