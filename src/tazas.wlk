class Recipiente{
	const capacidad = 250
	var cantidad = 0

	method estaLleno() {
	 	return cantidad >= capacidad
	}
	 
	method agregar(liquido){
	 	cantidad += liquido
	}
	
	method tomar(){
	 	if(cantidad <= 0) {
	 		throw new Exception(message= "No hay suficiente líquido para tomar")
	 	}
	 	cantidad -= 10
	 	cantidad = cantidad.max(0)
	}
	
	method realizarMerienda(){
		
		if(!self.estaLleno())
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
	method estaLleno(){
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
	
	override method estaLleno(){
		return false
	}
}


class Vaso inherits Recipiente{
    const material = "vidrio"  //Salvo que se indique lo contrario al instanciar, los vasos son de vidrio 
			
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

object tazaVader inherits Taza(temperatura = 60,capacidad = 300) { 
  var property dibujo = "soy tu padre"
  
  method esDivertida() {
    return dibujo.contains("padre")
  }

	override method vaciar() {
		// podría hacer super() y algo más 
	}
	
}


const miTazaConDibujitos = new Taza(temperatura = 20)
