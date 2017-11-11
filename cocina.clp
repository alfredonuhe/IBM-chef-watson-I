;;-----------------------------------------------------------------------------------------------
;;Clases 

(defclass PETICION (is-a INITIAL-OBJECT)
(slot ingrediente_1
(type SYMBOL)
(default null))
(slot ingrediente_2
(type SYMBOL)
(default null))
(slot ingrediente_3
(type SYMBOL)
(default null))
(slot ingrediente_4
(type SYMBOL)
(default null))
(slot estilo
(type SYMBOL)
(default null))
)

(defclass BUSQUEDA (is-a INITIAL-OBJECT)
(slot id_receta
    (type INTEGER))
(slot ingrediente_1
(type SYMBOL)
(allowed-values no si)
(default no))
(slot ingrediente_2
(type SYMBOL)
(allowed-values no si)
(default no))
(slot ingrediente_3
(type SYMBOL)
(allowed-values no si)
(default no))
(slot ingrediente_4
(type SYMBOL)
(allowed-values no si)
(default no))
(slot estilo
(type SYMBOL)
(allowed-values no si)
(default no))
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
(defrule check-ingrediente-1
?peticion <-(object (is-a PETICION) (ingrediente_1 ?i1))
?ingrediente <-(object (is-a INGREDIENTE)(nombre ?i1)(id_receta ?idr))
?receta <-(object (is-a RECETA)(id_receta ?idr))
=> 
(make-instance of BUSQUEDA (id_receta ?idr)(ingrediente_1 si))
)

(defrule check-ingrediente-2
?peticion <-(object (is-a PETICION) (ingrediente_2 ?i2))
?ingrediente <-(object (is-a INGREDIENTE)(nombre ?i2)(id_receta ?idr))
?receta <-(object (is-a RECETA)(id_receta ?idr))
?busqueda <-(object (is-a BUSQUEDA)(id_receta ?idr)(ingrediente_1 si)(ingrediente_2 no))
=> 
(unmake-instance ?busqueda)
(make-instance of BUSQUEDA (id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si))
)

(defrule check-ingrediente-3
?peticion <-(object (is-a PETICION) (ingrediente_3 ?i3))
?ingrediente <-(object (is-a INGREDIENTE)(nombre ?i3)(id_receta ?idr))
?receta <-(object (is-a RECETA)(id_receta ?idr))
?busqueda <-(object (is-a BUSQUEDA)(id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 no))
=> 
(unmake-instance ?busqueda)
(make-instance of BUSQUEDA (id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si))
)

(defrule check-ingrediente-4
?peticion <-(object (is-a PETICION) (ingrediente_4 ?i4))
?ingrediente <-(object (is-a INGREDIENTE)(nombre ?i4)(id_receta ?idr))
?receta <-(object (is-a RECETA)(id_receta ?idr))
?busqueda <-(object (is-a BUSQUEDA)(id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si)(ingrediente_4 no))
=> 
(unmake-instance ?busqueda)
(make-instance of BUSQUEDA (id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si)(ingrediente_4 si))
)

(defrule check-estilo
?peticion <-(object (is-a PETICION) (estilo ?tipoe))
?estilo<-(object (is-a ESTILO)(id_receta ?idr)(tipo_estilo ?tipoe))
?receta <-(object (is-a RECETA)(id_receta ?idr))
?busqueda <-(object (is-a BUSQUEDA)(id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si)(ingrediente_4 si)
(estilo no))
=> 
(unmake-instance ?busqueda)
(make-instance of BUSQUEDA (id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si)(ingrediente_4 si)(estilo si))
)

(defrule resultado
?busqueda <-(object (is-a BUSQUEDA)(id_receta ?idr)(ingrediente_1 si)(ingrediente_2 si)(ingrediente_3 si)(ingrediente_4 si)(estilo si))
?receta <-(object (is-a RECETA)(id_receta ?idr)(nombre ?nombre))
=> 
(printout t ?nombre ctrl)
)

;;-----------------------------------------------------------------------------------------------
;;Instancias

(definstances recetas
(of RECETA (id_receta 0) (num_ingr 3) (nombre arroz a la cubana))
(of RECETA (id_receta 1) (num_ingr 4) (nombre bacalao abra))
(of RECETA (id_receta 2) (num_ingr 2) (nombre bocata de jamon))
(of RECETA (id_receta 3) (num_ingr 2) (nombre melon con jamon))
(of RECETA (id_receta 4) (num_ingr 0) (nombre pollo con manzana))
)

(definstances ingredientes
(of INGREDIENTE (id_ingrediente 0)	(nombre arroz)		(id_receta 0)	(cantidad 1000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 1)	(nombre bacalao)	(id_receta 1)	(cantidad 1000)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 2)	(nombre pan)		(id_receta 2)	(cantidad 500)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 3)	(nombre tomate)		(id_receta 0)	(cantidad 500)	(metrica_cantidad ml))
(of INGREDIENTE (id_ingrediente 4)	(nombre jamon)		(id_receta 2)	(cantidad 250)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 5)	(nombre lechuga)	(id_receta 1)	(cantidad 300)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 6)	(nombre huevo)		(id_receta 0)	(cantidad 200)	(metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 7)	(nombre aceitunas)	(id_receta 1)	(cantidad 50)	(metrica_cantidad gr))
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
(of ESTILO (id_receta 2)(tipo_estilo español))
(of ESTILO (id_receta 3)(tipo_estilo español))
(of ESTILO (id_receta 4)(tipo_estilo frances))
)

(definstances peticion
(of PETICION (ingrediente_1 bacalao)(ingrediente_2 aceitunas)(ingrediente_3)(ingrediente_4)(estilo))
)