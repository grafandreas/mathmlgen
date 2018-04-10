package org.grafandreas.mathmlgen.tests;



import static org.junit.jupiter.api.Assertions.assertEquals;

import org.grafandreas.mathmlgen.Generator;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import com.google.inject.Binder;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Module;
import com.google.inject.name.Names;

class GenTest {

	@BeforeAll
	static void setUpBeforeClass() throws Exception {
	}

	@BeforeEach
	void setUp() throws Exception {
	}

	@ParameterizedTest
	@CsvSource(value = { "xml/declare.xml, 'auto x = 12.0;'",
			"xml/polynom.xml, '(a + pow(x,  2)) * (b + x)'",
			"xml/polynom2.xml, 'a * pow(x,  2) + b * x",
			"xml/declare-matrix.xml, ''"})
	
	final void testGenerateString(String argument, String expected) {
	    Module m = new Module() {
			
			@Override
			public void configure(Binder arg0) {
				arg0.bind(String.class).annotatedWith(Names.named("configFile")).toInstance("xml/def-config.json");
				
			}
				
		};
			
		Injector injector = Guice.createInjector(m);
		Generator generator = injector.getInstance(Generator.class);
			
		String actual = generator.generate(argument) ;
		assertEquals(expected, actual);
	}

}
