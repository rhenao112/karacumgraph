package com.sophossolutions.runners;

import com.intuit.karate.junit5.Karate;

public class SingleExecution {

	@Karate.Test
	Karate testParallelKarate() {
		return Karate.run("classpath:com/sophossolutions/features/full_validate_graphql.feature");
	}

}
