package org.grafandreas.mathmlgen.tests

import static org.junit.jupiter.api.Assertions.assertEquals
import java.util.ArrayList
import java.util.List
import org.grafandreas.mathmlgen.Generator
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.Arguments
import org.junit.jupiter.params.provider.CsvSource
import org.junit.jupiter.params.provider.MethodSource
import com.google.inject.Binder
import com.google.inject.Guice
import com.google.inject.Injector
import com.google.inject.Module
import com.google.inject.name.Names

class GenTest {
	@BeforeAll def static package void setUpBeforeClass() throws Exception {
	}

	@BeforeEach def package void setUp() throws Exception {
	}

	
//	 @CsvSource(value=#["xml/declare.xml, 'auto x = 12.0;'",
//		"xml/polynom.xml, '(a + pow(x,  2)) * (b + x)'", "xml/polynom2.xml, 'a * pow(x,  2) + b * x",
//		"xml/declare-matrix.xml, ''"])
		

		 def static List<Arguments> paramMethod() {
			var  res = #[
				Arguments.of("xml/declare.xml", 'auto x = 12.0;'),
				Arguments.of("xml/polynom.xml", '(a + pow(x,  2)) * (b + x)'),
				Arguments.of("xml/polynom2.xml", 'a * pow(x,  2) + b * x'),
				Arguments.of("xml/declare-matrix.xml", 
'''MatrixXf A;
A << 1, 0, 0
0, 1, 0
0, 0, 1
;
'''.toString),
				Arguments.of("xml/declare-multi.xml", 
'''auto x = 1.0;
auto y = 2.0;'''.toString
				)
			]
			
			res
			
		}
	@ParameterizedTest
		@MethodSource(value=#["paramMethod"]) 
		def final package void testGenerateString(String argument,
			String expected) {
			var Module m = [Binder arg0|
				arg0.bind(String).annotatedWith(Names.named("configFile")).toInstance("xml/def-config.json")
			]
			var Injector injector = Guice.createInjector(m)
			var Generator generator = injector.getInstance(Generator)
			var String actual = generator.generate(argument)
			assertEquals(expected, actual)
		}
	}
	