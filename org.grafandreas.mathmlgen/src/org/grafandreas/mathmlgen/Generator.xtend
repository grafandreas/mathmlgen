package org.grafandreas.mathmlgen

import com.google.inject.Inject
import java.util.ArrayList
import javax.xml.parsers.DocumentBuilderFactory
import org.w3c.dom.Document
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.w3c.dom.NodeList
import org.w3c.dom.Text
import org.w3c.dom.Attr
import java.util.Collection
import java.util.List

class Generator {
	
	val inl_binary = #{ "plus", "times" }
	
	val op_prio = #{ "times" -> 2, "plus" -> 3}
	
	String bib
	
	@Inject
	Configuration config
	
	
	def toList(NodeList nl) {
		val res = new ArrayList<Node>
		
		for(var i = 0; i< nl.length; i++)
			res.add(nl.item(i))
			
		res
	}
	
	def precedence(Node e) {
		if(e instanceof Element) {
			var toCheck = e
			if(e.tagName == "apply")
				toCheck = e.childElements.head
				
			if(op_prio.containsKey(toCheck.tagName))
				op_prio.get(toCheck.tagName)
			else
				0
				
		}
		else 
			0
		
	}
	def childElements(Node n) {
		n.childNodes.toList.filter(Element)
	}
	
	def nextNonTextSibling(Node n) {
		var sibl = n.nextSibling
		while(sibl instanceof Text)
			sibl = sibl.nextSibling
			
		sibl
	}
	
	def <T> second(List<T> c) {
		c.get(1);
	}
	
	def <T> second(Iterable<T> c) {
		c.get(1);
	}
	
	def generate(String fileName) {
		val factory = DocumentBuilderFactory.newInstance();
	    val builder = factory.newDocumentBuilder();
	    val document = builder.parse( fileName );
	    generate(document)
	}
	
	def generate(Document doc) {
		this.bib = if( config.prefix.length > 0 ) config.prefix+ "::" else ""
		
		doc.childNodes.toList.map[process].join(";\n")
	}
	
	def dispatch process(Node n) '''
	'''
	
	def  dispatch CharSequence process(Element e) {
		println(e.tagName)
		println(e)
		switch(e.tagName) {
			case "math" : {e.childNodes.toList.filter(Element).head.process}
			case "apply" : e.childElements.head.process
			case "plus" : p_plus(e)
			case "times" : p_times(e)
			case "power" : p_pow(e)
			case "ci", case "cn" : p_ci(e)
			case "declare" : p_declare(e)
			case "matrix" : p_matrix(e)
			case "matrixrow" : p_matrixrow(e)
			default : e.childNodes.toList.filter(Element).head.process
		}
	}
	
	def p_plus(Element e) {
				var l = e.nextNonTextSibling.process
		var r = e.nextNonTextSibling.nextNonTextSibling.process
		
		if(e.nextNonTextSibling.precedence > e.precedence)
			l = '''(«l»)'''
			
		if(e.nextNonTextSibling.nextNonTextSibling.precedence > e.precedence)
			r = '''(«r»)'''	
			
		'''«l» + «r»'''
	}
	
	def p_times(Element e) {

		var l = e.nextNonTextSibling.process
		var r = e.nextNonTextSibling.nextNonTextSibling.process
		
		if(e.nextNonTextSibling.precedence > e.precedence)
			l = '''(«l»)'''
			
		if(e.nextNonTextSibling.nextNonTextSibling.precedence > e.precedence)
			r = '''(«r»)'''	
			
		'''«l» * «r»'''
	}
	
	def p_pow(Element e) {
		'''«bib»pow(«e.nextNonTextSibling.process»,  «e.nextNonTextSibling.nextNonTextSibling.process»)'''
	}
	
	def p_ci(Element e) {
		'''«e.textContent»'''
	}
	
	def p_declare(Element e) {
		val tn = e.attributes.getNamedItem('type')
		println(tn)
		if(tn instanceof Attr && (tn as Attr).value == 'matrix') '''
		MatrixXf «e.childElements.head.process»;
		«e.childElements.head.process» << «e.childElements.second.process»;
		'''
		else
		'''auto «e.childElements.head.process» = «e.childElements.last.process»;'''
	}
	
	def p_matrix(Element e) '''
		«FOR r : e.childElements.filter[tagName=='matrixrow']»
			«r.process»
		«ENDFOR»
	'''

		def p_matrixrow(Element e) '''
		«FOR r : e.childElements SEPARATOR ", "»«r.process»«ENDFOR»
	'''
	
}