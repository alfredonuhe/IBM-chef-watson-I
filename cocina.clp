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
(slot contado
(type SYMBOL)
(allowed-values si no)
(default no))
)

(defclass RESULTADO (is-a INITIAL-OBJECT)
(slot id_receta
(type INTEGER))
(multislot ingredientes
(type SYMBOL))
(slot tipo_estilo
(type SYMBOL)
(default null))
(slot impreso
(type SYMBOL)
(allowed-values si no)
(default no))
(slot imprimir_paso
(type INTEGER))
)

(defclass RECETA (is-a INITIAL-OBJECT)
(slot id_receta
(type INTEGER))
(slot num_ingr
(type INTEGER))
(slot nombre
(type STRING))
(slot contado
(type SYMBOL)
(allowed-values si no)
(default no))
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
(slot nombre_ingrediente
(type SYMBOL))
)

(defclass CONTADOR (is-a INITIAL-OBJECT)
(slot total-ingredientes
(type INTEGER)
(default 0))
(slot total-recetas
(type INTEGER)
(default 0))
(slot orden
(type INTEGER)
(default 0)))

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

(defclass RESULTADO-INVENTADO (is-a RESULTADO))
(defclass RESULTADO-ENCONTRADO (is-a RESULTADO))

(defclass APERITIVO (is-a RECETA))
(defclass ENTRANTE (is-a RECETA))
(defclass POSTRE (is-a RECETA))
(defclass INFUSION (is-a RECETA))
(defclass VEGETAL (is-a INGREDIENTE))
(defclass ANIMAL (is-a INGREDIENTE))
(defclass MINERAL (is-a INGREDIENTE))
(defclass SINTETICO (is-a INGREDIENTE))
(defclass HONGOS (is-a INGREDIENTE))
(defclass ASIATICA (is-a ESTILO))
(defclass AMERICANA (is-a ESTILO))
(defclass AFRICANA (is-a ESTILO))
(defclass EUROPEA (is-a ESTILO))
(defclass OCEANICA (is-a ESTILO))


;;-----------------------------------------------------------------------------------------------
;;Reglas
;;FASE NUMERO 1
(defrule cuenta-recetas-ingredientes
(declare (salience 100))
?contador<-(object (is-a CONTADOR) (total-ingredientes ?tingr) (total-recetas ?trec))
?receta<-(object (is-a RECETA) (id_receta ?idr) (num_ingr ?numINGRE) (contado no))
=>
(modify-instance ?receta  (contado si))
(modify-instance ?contador (total-ingredientes (+ ?tingr ?numINGRE)) (total-recetas (+ ?trec 1)))
)

(defrule get-ingredientes
(declare (salience 100))
(object (is-a PETICION) (ingredientes $? ?i1 $?))
?ingrediente1 <-	(object (is-a INGREDIENTE) (id_ingrediente ?idi)(id_receta ?idr)(nombre ?i1))
?receta <-	(object (is-a RECETA) (id_receta ?idr))
=>
(make-instance of BUSQUEDAIN (id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1))
(printout t "procesado ingrediente: " ?i1 crlf)
)
(defrule get-estilo
(declare (salience 100))
(object (is-a PETICION) (tipo_estilo ?estl))
?estilo <-	(object (is-a ESTILO) (id_receta ?idr)(tipo_estilo ?estl))
?receta <-	(object (is-a RECETA) (id_receta ?idr))
=>
(make-instance of BUSQUEDAES (id_receta ?idr)(tipo_estilo ?estl))
(printout t "procesado estilo: " ?estl crlf)
)
;;FASE NUMERO 2
(defrule crear-resultado
(declare (salience 50))
(object (is-a BUSQUEDA) (id_receta ?idr))
(not (object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)))
=>
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr))
(printout t "resultado creado con id-receta: " ?idr crlf)
)

(defrule resultado-ingrediente
(declare (salience 25))
?b <-(object (is-a BUSQUEDAIN) (id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1) (contado no))
?r <-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(tipo_estilo ?estl))
=>
(unmake-instance  ?r)
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr)(ingredientes $?ingr ?i1)(tipo_estilo ?estl))
(modify-instance ?b (contado si))
(printout t "ingrediente " ?i1 " guardado en receta: " ?idr crlf)
)
(defrule resultado-estilo
(declare (salience 25))
?b	<-(object (is-a BUSQUEDAES) (id_receta ?idr)(tipo_estilo ?estl) (contado no))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr))
=>
(unmake-instance  ?r)
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr)(ingredientes $?ingr)(tipo_estilo ?estl))
(modify-instance ?b (contado si))
(printout t "estilo " ?estl " guardado en receta: " ?idr crlf)
)
;;Fase 3
(defrule crear-resultado-RecetaInventada
(declare (salience 20))
(not (object (is-a RESULTADO-INVENTADO)))
?contador<-(object (is-a CONTADOR) (total-ingredientes ?tingr) (total-recetas ?trec))
(not (object (is-a RESULTADO) (id_receta ?trec)))
=>
(make-instance of RESULTADO-INVENTADO (id_receta ?trec))
(make-instance of RECETA (id_receta ?trec) (nombre "receta invetada"))
(modify-instance ?contador (total-recetas (+ ?trec 1)))
(printout t "Creación de una receta inventada con id-receta: " ?trec crlf)
)

(defrule resultado-receta-ingredientes-pasos
(declare (salience 15))
?contador<-(object (is-a CONTADOR) (total-ingredientes ?tingr) (orden ?o))
(object (is-a INGREDIENTE) (nombre ?i1) (id_receta ?idr) (cantidad ?cant) (metrica_cantidad ?mcant))
(object (is-a PASO) (id_receta ?idr) (descripcion ?desc) (nombre_ingrediente ?i1))
?b <-(object (is-a BUSQUEDAIN) (id_receta ?idr)(nombre ?i1) (contado si))
?r <-(object (is-a RESULTADO-INVENTADO) (id_receta ?trec)(ingredientes $?ingr))
?rt <-(object (is-a RECETA) (id_receta ?trec) (num_ingr ?ningr))
(not (object (is-a RESULTADO-INVENTADO) (ingredientes $? ?i1 $?)))
=>
(modify-instance ?r (ingredientes $?ingr ?i1))
(make-instance of INGREDIENTE (id_ingrediente ?tingr) (nombre ?i1) (id_receta ?trec) (cantidad ?cant) (metrica_cantidad ?mcant))
(make-instance of PASO (id_receta ?trec) (orden ?o) (descripcion ?desc) (nombre_ingrediente ?i1))
(modify-instance ?contador (total-ingredientes (+ ?tingr 1)) (orden (+ ?o 1)))
(modify-instance ?rt (num_ingr (+ ?ningr 1)))
(printout t "ingrediente " ?i1 " guardado en receta: " ?trec crlf)
(printout t "cuyo paso nº " ?o " se realiza la accion de: " ?desc " sobre el alimento" ?i1 " para la receta "?trec crlf)
)

(defrule resultado-receta-estilo
(declare (salience 15))
?b <-(object (is-a BUSQUEDAES) (tipo_estilo ?estl))
?r <-(object (is-a RESULTADO-INVENTADO) (id_receta ?trec)(ingredientes $?ingr)(tipo_estilo ?estilo))
(test (eq ?estilo null))
=>
(modify-instance ?r (tipo_estilo ?estl))
(make-instance of ESTILO (id_receta ?trec) (tipo_estilo ?estl))
(printout t "estilo " ?estl " guardado en receta: " ?trec crlf)
)

;;Fase 4
(defrule imprimir-resultado-encontrado-pasos
(declare (salience 11))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(impreso si)(imprimir_paso ?orden))
(object (is-a PASO) (id_receta ?idr)(orden ?orden)(descripcion ?descripcion)(nombre_ingrediente ?nombre_ingrediente))
=>
(modify-instance ?r (imprimir_paso (+ 1 ?orden)))
(printout t "Paso " ?orden " : " ?descripcion " " ?nombre_ingrediente "." crlf)
)

(defrule imprimir-resultado-encontrado
(declare (salience 10))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(impreso no))
(object (is-a RECETA) (id_receta ?idr)(nombre ?nombre_receta))
(object (is-a ESTILO) (id_receta ?idr)(tipo_estilo ?estl))
=>
(modify-instance ?r (impreso si))
(printout t crlf)
(printout t "Receta: " ?nombre_receta crlf)
(printout t "Ingredientes encontrados: " $?ingr crlf)
(printout t "Estilo: " ?estl crlf)
(printout t "Pasos: " crlf)
)

;;Fase 5
(defrule imprimir-resultado-inventado-pasos
(declare (salience 9))
?r	<-(object (is-a RESULTADO-INVENTADO) (id_receta ?idr)(ingredientes $?ingr)(impreso si)(imprimir_paso ?orden))
(object (is-a PASO) (id_receta ?idr)(orden ?orden)(descripcion ?descripcion)(nombre_ingrediente ?nombre_ingrediente))
=>
(modify-instance ?r (imprimir_paso (+ 1 ?orden)))
(printout t "Paso " ?orden " : " ?descripcion " " ?nombre_ingrediente "." crlf)
)

(defrule imprimir-resultado-inventado
(declare (salience 8))
?r	<-(object (is-a RESULTADO-INVENTADO) (id_receta ?idr)(ingredientes $?ingr)(impreso no))
(object (is-a RECETA) (id_receta ?idr)(nombre ?nombre_receta))
(object (is-a ESTILO) (id_receta ?idr)(tipo_estilo ?estl))
=>
(modify-instance ?r (impreso si))
(printout t crlf)
(printout t "Receta: " ?nombre_receta crlf)
(printout t "Ingredientes: " $?ingr crlf)
(printout t "Estilo: " ?estl crlf)
(printout t "Pasos: " crlf)
)

;;-----------------------------------------------------------------------------------------------
;;Instancias
(definstances recetas
(of RECETA (id_receta 0) (num_ingr 3) (nombre "arroz a la cubana"))
(of RECETA (id_receta 1) (num_ingr 4) (nombre "bacalao abra"))
(of RECETA (id_receta 2) (num_ingr 2) (nombre "bocata de jamon"))
(of RECETA (id_receta 3) (num_ingr 2) (nombre "melon con jamon"))
(of RECETA (id_receta 4) (num_ingr 3) (nombre "pollo con manzana"))
)
(definstances ingredientes
(of INGREDIENTE (id_ingrediente 0) (nombre arroz) (id_receta 0) (cantidad 1000) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 1) (nombre bacalao) (id_receta 1) (cantidad 1000) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 2) (nombre pan) (id_receta 2) (cantidad 500) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 3) (nombre tomate) (id_receta 0) (cantidad 500) (metrica_cantidad ml))
(of INGREDIENTE (id_ingrediente 4) (nombre jamon) (id_receta 2) (cantidad 250) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 5) (nombre lechuga) (id_receta 1) (cantidad 300) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 6) (nombre huevo) (id_receta 0) (cantidad 200) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 7) (nombre aceituna) (id_receta 1) (cantidad 50) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 8) (nombre melon) (id_receta 3) (cantidad 2000) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 9) (nombre pollo) (id_receta 4) (cantidad 5000) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 10) (nombre jamon) (id_receta 3) (cantidad 700) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 11) (nombre huevo) (id_receta 1) (cantidad 200) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 12) (nombre manzana) (id_receta 4) (cantidad 200) (metrica_cantidad gr))
(of INGREDIENTE (id_ingrediente 13) (nombre cebolla) (id_receta 4) (cantidad 550) (metrica_cantidad gr))
)

(definstances pasos
(of PASO (id_receta 0) (orden 0) (descripcion cuece) (nombre_ingrediente arroz))
(of PASO (id_receta 0) (orden 1) (descripcion agrega) (nombre_ingrediente tomate))
(of PASO (id_receta 0) (orden 2) (descripcion rehoga) (nombre_ingrediente arroz))
(of PASO (id_receta 0) (orden 3) (descripcion frie) (nombre_ingrediente huevo))
(of PASO (id_receta 0) (orden 4) (descripcion junta) (nombre_ingrediente arroz))
(of PASO (id_receta 1) (orden 0) (descripcion frie) (nombre_ingrediente bacalao))
(of PASO (id_receta 1) (orden 1) (descripcion anyade) (nombre_ingrediente lechuga))
(of PASO (id_receta 1) (orden 2) (descripcion corta) (nombre_ingrediente aceituna))
(of PASO (id_receta 1) (orden 3) (descripcion anyade) (nombre_ingrediente aceituna))
(of PASO (id_receta 1) (orden 4) (descripcion junta) (nombre_ingrediente bacalao))
)

(definstances estilos
(of ESTILO (id_receta 0)(tipo_estilo cubano))
(of ESTILO (id_receta 1)(tipo_estilo portugues))
(of ESTILO (id_receta 2)(tipo_estilo espanol))
(of ESTILO (id_receta 3)(tipo_estilo espanol))
(of ESTILO (id_receta 4)(tipo_estilo frances))
)

(definstances cuentaIngredientesRecetas
(of CONTADOR (total-ingredientes 0) (total-recetas 0)))

(definstances peticion
(of PETICION (ingredientes aceituna bacalao huevo lechuga)(tipo_estilo cubano))
)

