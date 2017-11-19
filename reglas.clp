;;Reglas
(defrule imprimir-fichero
(declare (salience 101))
=>
(set-strategy random)
(dribble-on salida.txt)
)
;;FASE NUMERO 1
(defrule cuenta-recetas-ingredientes
(declare (salience 100))
?contador<-(object (is-a CONTADOR) (total-ingredientes ?tingr) (total-recetas ?trec))
?receta<-(object (is-a RECETA) (id_receta ?idr) (num_ingr ?numINGRE) (contado no))
=>
(modify-instance ?receta  (contado si))
(modify-instance ?contador (total-ingredientes (+ ?tingr ?numINGRE)) (total-recetas (+ ?trec 1)))
)



(defrule procesa-ingredientes-peticion
(declare (salience 100))
(object (is-a PETICION) (ingredientes $? ?i1 $?))
?ingrediente1 <-	(object (is-a INGREDIENTE) (id_ingrediente ?idi)(id_receta ?idr)(nombre ?i1))
?receta <-	(object (is-a RECETA) (id_receta ?idr))
(not (object (is-a RECETA) (id_receta ?idr) (nombre "receta inventada")))
=>
(make-instance of BUSQUEDAIN (id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1))
(printout t "Ingrediente procesado: " ?i1 " en la receta con id: " ?idr crlf)
)
(defrule procesa-estilo-peticion
(declare (salience 100))
(object (is-a PETICION) (nombre_estilo ?estl))
?estilo <-	(object (is-a ESTILO) (id_receta ?idr)(nombre_estilo ?estl))
?receta <-	(object (is-a RECETA) (id_receta ?idr))
(not (object (is-a RECETA) (id_receta ?idr) (nombre "receta inventada")))
=>
(make-instance of BUSQUEDAES (id_receta ?idr)(nombre_estilo ?estl))
(printout t "Estilo procesado: " ?estl crlf)
)

(defrule procesa-ingredientes-peticion-vacia
(declare (salience 99))
(not (object (is-a BUSQUEDAIN)))
(not (object (is-a BUSQUEDAES)))
=>
(printout t "Peticion vacia, anyade algun elemento a la peticion " crlf)
(dribble-off)
(halt)
)


;;FASE NUMERO 2
(defrule crear-resultado-encontrado
(declare (salience 98))
(object (is-a BUSQUEDA) (id_receta ?idr))
(not (object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)))
(not (object (is-a RECETA) (id_receta ?idr) (nombre "receta inventada")))
=>
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr))
(printout t "Resultado creado con id-receta: " ?idr crlf)
)

(defrule ingrediente-resultado-encontrado
(declare (salience 98))
?b <-(object (is-a BUSQUEDAIN) (id_receta ?idr)(id_ingrediente ?idi)(nombre ?i1) (contado no))
?r <-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(nombre_estilo ?estl))
=>
(unmake-instance  ?r)
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr)(ingredientes $?ingr ?i1)(nombre_estilo ?estl))
(modify-instance ?b (contado si))
(printout t "Ingrediente " ?i1 " guardado en resultado con id: " ?idr crlf)
)
(defrule estilo-resultado-encontrado
(declare (salience 98))
?b	<-(object (is-a BUSQUEDAES) (id_receta ?idr)(nombre_estilo ?estl) (contado no))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr))
=>
(unmake-instance  ?r)
(make-instance of RESULTADO-ENCONTRADO (id_receta ?idr)(ingredientes $?ingr)(nombre_estilo ?estl))
(modify-instance ?b (contado si))
(printout t "Estilo " ?estl " guardado en resultado con id: " ?idr crlf)
)
;;Fase 3
(defrule crear-resultado-inventado
(declare (salience 97))
(not (object (is-a RESULTADO-INVENTADO)))
?contador<-(object (is-a CONTADOR) (total-ingredientes ?tingr) (total-recetas ?trec))
(not (object (is-a RESULTADO) (id_receta ?trec)))
=>
(make-instance of RESULTADO-INVENTADO (id_receta ?trec))
(make-instance of RECETA (id_receta ?trec) (nombre "receta inventada"))
(modify-instance ?contador (total-recetas (+ ?trec 1)))
(printout t "Receta creada con id: " ?trec crlf)
(printout t "Resultado inventado creado con id-receta: " ?trec crlf)
)

(defrule ingrediente-paso-resultado-inventado
(declare (salience 96))
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
(printout t "Ingrediente " ?i1 " guardado en resultado inventado con id: " ?trec crlf)
(printout t "Paso nº " ?o " con descripcion: " ?desc " guardado en resultado inventado con id: " ?trec  crlf)
)

(defrule estilo-resultado-inventado
(declare (salience 96))
?b <-(object (is-a BUSQUEDAES) (nombre_estilo ?estl))
?r <-(object (is-a RESULTADO-INVENTADO) (id_receta ?trec)(ingredientes $?ingr)(nombre_estilo ?estilo))
(object (is-a BUSQUEDAIN))
(test (eq ?estilo null))
=>
(modify-instance ?r (nombre_estilo ?estl))
(make-instance of ESTILO (id_receta ?trec) (nombre_estilo ?estl))
(printout t "Estilo " ?estl " guardado en resultado inventado con id: " ?trec crlf)
)

;;Fase 4
(defrule imprimir-resultado-encontrado-pasos
(declare (salience 95))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(impreso si)(imprimir_paso ?orden))
(object (is-a PASO) (id_receta ?idr)(orden ?orden)(descripcion ?descripcion)(nombre_ingrediente ?nombre_ingrediente))
=>
(modify-instance ?r (imprimir_paso (+ 1 ?orden)))
(printout t "Paso " ?orden " : " ?descripcion " " ?nombre_ingrediente "." crlf)
)

(defrule imprimir-resultado-encontrado
(declare (salience 94))
?r	<-(object (is-a RESULTADO-ENCONTRADO) (id_receta ?idr)(ingredientes $?ingr)(impreso no))
(object (is-a RECETA) (id_receta ?idr)(nombre ?nombre_receta))
(object (is-a ESTILO) (id_receta ?idr)(nombre_estilo ?estl))
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
(declare (salience 93))
?r	<-(object (is-a RESULTADO-INVENTADO) (id_receta ?idr)(ingredientes $?ingr)(impreso si)(imprimir_paso ?orden))
(object (is-a PASO) (id_receta ?idr)(orden ?orden)(descripcion ?descripcion)(nombre_ingrediente ?nombre_ingrediente))
=>
(modify-instance ?r (imprimir_paso (+ 1 ?orden)))
(printout t "Paso " ?orden " : " ?descripcion " " ?nombre_ingrediente "." crlf)
)

(defrule imprimir-resultado-inventado
(declare (salience 92))
?r	<-(object (is-a RESULTADO-INVENTADO) (id_receta ?idr)(ingredientes $?ingr)(impreso no))
(object (is-a RECETA) (id_receta ?idr)(nombre ?nombre_receta))
(object (is-a ESTILO) (id_receta ?idr)(nombre_estilo ?estl))
=>
(modify-instance ?r (impreso si))
(printout t crlf)
(printout t "Receta: " ?nombre_receta crlf)
(printout t "Ingredientes: " $?ingr crlf)
(printout t "Estilo: " ?estl crlf)
(printout t "Pasos: " crlf)
)

(defrule acabar-imprimir-fichero
(declare (salience 91))
=>
(dribble-off)
(halt)
)
