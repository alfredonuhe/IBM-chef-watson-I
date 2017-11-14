;;-----------------------------------------------------------------------------------------------
;;Clases 

(defclass PETICION (is-a INITIAL-OBJECT)
	(multislot ingredientes
		(type SYMBOL))
	(slot tipo_estilo
		(type SYMBOL)
		(default null))
)

(defclass BUSQUEDA (is-a INITIAL-OBJECT)
	(slot id_receta
		(type INTEGER))
)

(defclass RESULTADO (is-a INITIAL-OBJECT)
	(slot id_receta
		(type INTEGER))
	(multislot ingredientes
		(type SYMBOL))
	(slot tipo_estilo
		(type SYMBOL)
		(default null))
)

(defclass RECETA (is-a INITIAL-OBJECT)
	(slot id_receta
	     	(type INTEGER))
	(slot num_ingr
	   	 (type INTEGER))
	(slot nombre
    		(type STRING))
)

(defclass INGREDIENTE (is-a INITIAL-OBJECT)
	(slot id_ingrediente
		(type INTEGER))
	(slot nombre
		 (type SYMBOL))
	(slot id_receta
		 (type INTEGER))
	(slot cantidad
	 	 (type INTEGER))
	(slot metrica_cantidad
	  	 (type SYMBOL)
   		 (allowed-values gr ml))
)
(defclass ESTILO (is-a INITIAL-OBJECT)
	(slot id_receta
	    (type INTEGER))
	(slot tipo_estilo
	    (type SYMBOL))
)
(defclass PASO (is-a INITIAL-OBJECT)
	(slot id_receta
	    (type INTEGER))
	(slot orden
	    (type INTEGER))
	(slot descripcion
	    (type STRING))
)

(defclass BUSQUEDAIN (is-a BUSQUEDA)
	(slot id_ingrediente
		(type INTEGER))
	(slot nombre
		(type SYMBOL))
)

(defclass BUSQUEDAES (is-a BUSQUEDA)
	(slot tipo_estilo
		(type SYMBOL))
)

(defclass APERITIVO (is-a RECETA))
(defclass ENTRANTE  (is-a RECETA))
(defclass POSTRE    (is-a RECETA))
(defclass INFUSION  (is-a RECETA))
(defclass VEGETAL   (is-a INGREDIENTE))
(defclass ANIMAL    (is-a INGREDIENTE))
(defclass MINERAL   (is-a INGREDIENTE))
(defclass SINTETICO (is-a INGREDIENTE))
(defclass HONGOS    (is-a INGREDIENTE))
(defclass ASIATICA  (is-a ESTILO))
(defclass AMERICANA (is-a ESTILO))
(defclass AFRICANA  (is-a ESTILO))
(defclass EUROPEA   (is-a ESTILO))
(defclass OCEANICA  (is-a ESTILO))

;;-----------------------------------------------------------------------------------------------
;;Reglas 
(defrule get-ingredientes
(declare (salience 100))
					(object (is-a PETICION) 		(ingredientes $? ?i1 $?))
?ingrediente1 <-	(object (is-a INGREDIENTE) 	(id_ingrediente ?idi)(id_receta ?idr)(nombre ?i1))
?receta <-			(object (is-a RECETA) 			(id_receta ?idr))
=> 
(make-instance of BUSQUEDAIN (id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1))
(printout t "procesado ingrediente: " ?i1 crlf)
)

(defrule get-estilo
(declare (salience 100))
			(object (is-a PETICION) 		(tipo_estilo ?estl))
?estilo <-	(object (is-a ESTILO) 			(id_receta ?idr)(tipo_estilo ?estl))
?receta <-	(object (is-a RECETA) 			(id_receta ?idr))
=> 
(make-instance of BUSQUEDAES (id_receta ?idr)(tipo_estilo ?estl))
(printout t "procesado estilo: " ?estl crlf)
)

(defrule crear-resultado
(declare (salience 50))
(object (is-a BUSQUEDA) 		(id_receta ?idr))
(not (object (is-a RESULTADO) 		(id_receta ?idr)))
=> 
(make-instance of RESULTADO (id_receta ?idr))
(printout t "resultado creado con id-receta: " ?idr crlf)
)

(defrule resultado-ingrediente
(declare (salience 25))
?b 	<-(object (is-a BUSQUEDAIN) 		(id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1))
?r 	<-(object (is-a RESULTADO) 		(id_receta ?idr)(ingredientes $?ingr)(tipo_estilo ?estl))
=> 
(unmake-instance ?b ?r)
(make-instance of RESULTADO (id_receta ?idr)(ingredientes $?ingr ?i1)(tipo_estilo ?estl))
(printout t "ingrediente " ?i1 " guardado en receta: " ?idr crlf)
)

(defrule resultado-estilo
(declare (salience 25))
?b	<-(object (is-a BUSQUEDAES) 		(id_receta ?idr)(tipo_estilo ?estl))
?r	<-(object (is-a RESULTADO) 		(id_receta ?idr)(ingredientes $?ingr))
=> 
(unmake-instance ?b ?r)
(make-instance of RESULTADO (id_receta ?idr)(ingredientes $?ingr)(tipo_estilo ?estl))
(printout t "estilo " ?estl " guardado en receta: " ?idr crlf)
)


;;-----------------------------------------------------------------------------------------------
;;Instancias

(definstances recetas
(of RECETA (id_receta 0) (num_ingr 3) (nombre "arroz a la cubana"))
(of RECETA (id_receta 1) (num_ingr 4) (nombre "bacalao abra"))
(of RECETA (id_receta 2) (num_ingr 2) (nombre "bocata de jamon"))
(of RECETA (id_receta 3) (num_ingr 2) (nombre "melon con jamon"))
(of RECETA (id_receta 4) (num_ingr 0) (nombre "pollo con manzana"))
)

(definstances ingredientes
(of INGREDIENTE (id_ingrediente 0)	(nombre arroz)		(id_receta 0)	(cantidad 1000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 1)	(nombre bacalao)	(id_receta 1)	(cantidad 1000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 2)	(nombre pan)		(id_receta 2)	(cantidad 500)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 3)	(nombre tomate)		(id_receta 0)	(cantidad 500)	(metrica_cantidad ml))
(of INGREDIENTE (id_ingrediente 4)	(nombre jamon)		(id_receta 2)	(cantidad 250)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 5)	(nombre lechuga)	(id_receta 1)	(cantidad 300)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 6)	(nombre huevo)		(id_receta 0)	(cantidad 200)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 7)	(nombre aceituna)	(id_receta 1)	(cantidad 50)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 8)	(nombre melon)		(id_receta 3)	(cantidad 2000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 9)	(nombre pollo)		(id_receta 4)	(cantidad 5000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 10)	(nombre jamon)		(id_receta 3)	(cantidad 700)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 11)	(nombre huevo)		(id_receta 1)	(cantidad 200)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 12)	(nombre manzana)	(id_receta 4)	(cantidad 200)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 13)	(nombre cebolla)	(id_receta 4)	(cantidad 550)	(metrica_cantidad gr))
)

(definstances estilos
(of ESTILO (id_receta 0)(tipo_estilo cubano))
(of ESTILO (id_receta 1)(tipo_estilo portugues))
(of ESTILO (id_receta 2)(tipo_estilo espanol))
(of ESTILO (id_receta 3)(tipo_estilo espanol))
(of ESTILO (id_receta 4)(tipo_estilo frances))
)

(definstances peticion
(of PETICION (ingredientes aceituna bacalao huevo)(tipo_estilo cubano))
)
