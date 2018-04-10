package org.grafandreas.mathmlgen

import com.google.inject.Inject
import com.google.inject.Singleton
import com.google.inject.name.Named
import java.io.FileReader
import javax.json.Json
import javax.json.JsonObject

@Singleton
class Configuration {
	
	JsonObject jsons
	
	@Inject
	new( @Named("configFile") String configFile ) {
		val reader = Json.createReader(new FileReader(configFile));
		jsons = reader.readObject();
	}
	
	def public String prefix() {
		jsons.getString("math-lib")
		
	}
}