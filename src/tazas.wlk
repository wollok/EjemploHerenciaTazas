class Recipiente{
	const capacidad = 250
	var cantidad = 0

	method estaLlena() {
	 	return cantidad >= capacidad
	}
	 
	method agregar(liquido){
	 	cantidad += liquido
	}
	
	method tomar(){
	 	if(cantidad <= 0) {
	 		throw new Exception(message= "El recipiente esta vacía")
	 	}
	 	cantidad -= 10
	 	cantidad = cantidad.max(0)
	}
	
	method realizarMerienda(){
		
		if(!self.estaLlena())
			self.agregar(250)
		5.times{x=>self.tomar()}
		self.vaciar()
	
	}
	
	method vaciar()
	
	
}

class Taza inherits Recipiente{
	var temperatura 
		
	method pasarElTiempo(){
		temperatura -= 1
	}
	
	method temperatura() = temperatura
		
	override 
	method estaLlena(){
		return cantidad > capacidad - 10
	}
	
	override method tomar(){
	 	super()
	 	self.pasarElTiempo()
	}
	
	override method vaciar(){
		cantidad = 0
		temperatura = 15
	}
	
	
}

class Mate inherits Taza{
	
	method cebar(){
		self.agregar(100)
	}
	method ronda(){
		//......
	}
	
	override method estaLlena(){
		return false
	}
}


class Vaso inherits Recipiente{
	var material
			
	method esFragil(){
		return material == "vidrio"
	}	
	
	method caer(){
		if (self.esFragil()){
			cantidad = 0
		}
	}
	override method vaciar(){
		if (!self.esFragil())
			cantidad = 0
		else
			cantidad = 1
	}
}

