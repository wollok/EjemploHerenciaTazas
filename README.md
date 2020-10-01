# Sobre tazas y otros recipientes

**Ejemplo para introducir Herencia**

### Algo que contiene bebidas calientes
Queremos representar muchos objetos similares que sirven para contener líquidos calientes, permiten tomar de ellos o agregar más cantidad. Tienen una cierta capacidad maxima, por lo que podemos saber cuándo están llenos.
También sabemos la temperatura que tiene y a medida que pasa el tiempo su temperatura desciende. 
A esta abstracción decidimos llamarla **Taza** y definir una clase para representarla. 

``` Wollok

class Taza {
  const capacidad = 250 
  var cantidad = 0
  var temperatura //Se debe inicializar al instanciar

  method estaLlena() {
    return cantidad >= capacidad
  }
  method agregar(liquido){
    cantidad += liquido
    // No se controla que la taza rebalse
  }
	
  method tomar(){
    cantidad -= 10  
    //Se considera que cada vez que se toma de a 10 unidades
    //No se controla que no haya suficiente líquido para tomar
  }
  
  method pasarElTiempo(){
    temperatura -= 1
  }
  
  method temperatura() = temperatura 
  // Podría haberse definido como property
	
  method pasarElTiempo(){
    temperatura -= 1
    // Se considera que se disminuye de a uno la temperatura
   }
}
```

### Algo para bebidas frías que puede resultar frágil
Aparecen otros elementos objetos que necesitamos modelar, que también permiten contener líquidos, poder ir agregrando y tomando de ellos, y saber si están llenos teniendo como referencia una capacidad máxima para cada uno.
Como se usan para líquidos fríos no nos interesa representar su temperatura, pero sí es importante conocer de que material están hechos, porque si son de vidrio resultan frágiles y se pueden caer perdiendo todo su contenido.

Si bien en un primer momento podría parecer que la abstraccion de **Taza** nos servía para representarlos (agregar, tomar, capacidad, etc.) vemos que hay caracteristicas definidas que no nos sirven (todo lo referido a temperatura) y hay nuevas características que la solucion anterior no contempla (fragilidad del material).
Utilizando nuevamente el concepto de clase, definimos una nueva a la que llamamos **Vaso**. 

Ya nos empieza a hacer un poco de ruido tener que "copiar y pegar" parte del código...

``` Wollok
class Vaso {
  const capacidad = 250 
  var cantidad = 0
  var material = "vidrio"  //Salvo que se indique lo contrario al instanciar, los vasos son de vidrio 
		
  method estaLleno() {
    return cantidad >= capacidad
  }
  method agregar(liquido){
    cantidad += liquido
    // No se controla que la taza rebalse
  }
	
  method tomar(){
    cantidad -= 10  
    //Se considera que cada vez que se toma de a 10 unidades
    //No se controla que no haya suficiente líquido para tomar
  }
  
  method esFragil(){
    return material == "vidrio"
  }	
  
  method caer(){
    if (self.esFragil()){
      cantidad = 0
    }
  }
}
```

### No se puede tomar si no hay líquido
Aparece un nuevo requerimiento que es el control de la cantidad restante a la hora de tomar. Cuando ya no hay liquido no se puede tomar y se debe lanzar una excepción.
Pero si tiene algo de líquido, aunque sea una cantidad menor que lo habitualmente se toma, se toma todo lo que queda. 

Y lo más importante: Nos aclaran que esto sucede tanto para los vasos como para las tazas.

La solución pasa por modificar el método tomar, haciendo algo así

```wollok
  method tomar(){
    if(cantidad <= 0) {
      throw new Exception(message= "No hay suficiente líquido para tomar")
    }
    cantidad -= 10
    cantidad = cantidad.max(0)
  }
```
¡Pero habría que hacer lo mismo tanto en Taza como en Vaso!

Ya había sido molesto inicialmente tener que definir dos veces buena parte del código. Ahora tener que modificar dos veces lo mismo es doblemente preocupante, no sólo por lo incómodo sino por la posibilidad que nos equivoquemos y quede distinto.

La solución consiste en incorporar el concepto de **herencia** y definir una nueva abstracción, una entidad más genérica que abarque tanto tazas como vasos. 
Elegimos el término **recipiente** para representar esta idea. Podríamos haber elegido un término más descriptivo como "recipiente que sirve para tomar", pero para que no sea tan extenso nos quedamos con el anterior.

Los atributos y métodos en común los definimos en la clase Recipiente y el cambio del método ´tomar()´ lo hacemos una sola vez.

``` wollok
class Recipiente{
  const capacidad = 250
  var cantidad = 0
  
  method estaLleno() {
    return cantidad >= capacidad  // Detalle: unificamos el género
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
```

Ahora, la clases Taza y Vaso *heredan* de la clase Recipiente y se define en ellas sólo lo diferente. 

```wollok
class Taza inherits Recipiente{
  var temperatura 
  
  method pasarElTiempo(){
    temperatura -= 1
  }
  
  method temperatura() = temperatura
}

class Vaso inhertis Recipiente{
  var material = "vidrio"  //Salvo que se indique lo contrario al instanciar, los vasos son de vidrio
  
  method esFragil(){
    return material == "vidrio"
  }
  
  method caer(){
    if (self.esFragil()){
      cantidad = 0
    }
  }
}
```

### ¡A tomar unos mates!

Surgen nuevos elementos a representar. Se trata de algo que contiene líquido y se toma de él. Cuando se quiere tomar y no hay líquido, debe controlarlo. Nos interesa representar su temperatura y sabemos que se enfría con el paso del tiempo.

Se le llama cebar a agregarle una cierta cantidad de líquido y se permite compartirlo en una ronda de amigos (Al menos, cuando no hay cuarentena...)

En términos del dominio lo denominaríamos "mate", pero ¿como lo representamos en nuestro modelo?.
En primer lugar, la definición de recipiente nos sirve, pero no es suficiente. Si seguimos analizando, vemos que la de Vaso no nos ayuda; la de Taza sí, todo lo que define nos viene bien, pero sigue habiendo cosas que faltan.

Como ninguna de las definiciones existentes se ajusta totalmente a lo que necesitamos, difinimos una nueva clase y la llamamos **Mate**, como nos imaginábmos. 

Lo interesante es utilizar el concepto de Herencia, para que la nueva clase tenga la definición mínima y *herede* lo más posible de las clases existentes. Por lo analizado anteriormente, la clase de la cual conviene que herede es Taza.
Es discutible si los términos elegidos son los más expresivos, tal vez decir que "un mate es como un taza que ..." no sea lo más exacto, pero si le tuvieramos que explicar a un extranjero qué es un mate tal vez la noción de taza nos ayude. 
Podría ser conveniente renombrar Taza por algo como "Recipiente para bebidas calientes" pero para simplificar lo dejamos así. 

```wollok
class Mate inherits Taza{
  
  method cebar(){
    self.agregar(100) // Asumimos que se ceba de a 100 unidades
  }
  
  method ronda(){
    // No tenemos el detalle de cómo es una ronda de mate. En otro momento se lo definirá.
  }
}
```
