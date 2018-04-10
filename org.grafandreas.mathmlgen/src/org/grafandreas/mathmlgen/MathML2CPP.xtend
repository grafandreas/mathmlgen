package org.grafandreas.mathmlgen

import com.google.inject.Binder
import com.google.inject.Guice
import com.google.inject.Module
import com.google.inject.name.Names
import java.io.File
import javax.xml.parsers.DocumentBuilderFactory

class MathML2CPP {
	def static void main( String[] args) {

//	    System.out.println( document.getFirstChild().getTextContent() );
	    
	    val m = new Module() {
			
			override configure(Binder arg0) {
				
				arg0.bind(typeof(String)).annotatedWith(Names.named("configFile")).toInstance(args.get(1))
			}
			
		}
		
		val injector = Guice.createInjector(m);
		val generator = injector.getInstance(Generator)
			
		var res = generator.generate(args.get(0)) 
		
		
		println(res)
	}
}