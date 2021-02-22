;********** PROGRAMMA **********
.orig		x3000
		LEA	R0, arrayA	; carico in R0 l'inidirizzo di arrayA
		LEA	R1, arrayR	; carico in R1 l'indirizzo di arrayR

;********* SOTTOPROGRAMMA ********

; SOMMATORIA_ARRAY			; nome sottoprogramma
		
		ST	R2,store2	; scrivo il contenuto di R2 nella cella di indirizzo store2
		ST	R3,store3	; scrivo il contenuto di R2 nella cella di indirizzo store2
		
		AND	R3,R3,#0	; azzero il registro R3 (che verr� utilzzato per Sommatoria)

ciclo		LDR	R2,R0,#0	; metto in R2 il contenuto della cella di indirizzo R0 + #0 (arrayA)
		brz	fine		; se trovo uno zero esco (sequenza finita)
		brp	num1_pos	; se trovo un positivo salto a primo positivo
		brn	num1_neg	; se trovo un negativo salto a primo negativo

;primo_positivo	
num1_pos	ADD	R0,R0,#1	; incremento indirizzo arrayA (ind. presente in R0)
		AND	R3,R3,R3	; verifico il valore presente in R3 (Sommatoria)
		brp	conc_pos	; se positivo vado a concordi positivi
		brnz	sommo		; se negativo o zero non c'� rischio traboccamento
					; quindi effettuo la somma e scrivo in arrayR
;primo_negativo
num1_neg	ADD	R0,R0,#1	; incremento indirizzo arrayA contenuto in R0
		AND	R3,R3,R3	; verifico il valore presente in R3 (Sommatoria)
		brn	conc_neg	; se negativo vado a concordi negativi
		brzp	sommo		; se positivo o zero non c'� rischio traboccamento
					; quindi effettuo la somma e scrivo in arrayR

conc_neg	ADD	R3,R3,R2	; effettuo la sommatoria
		brnz	scrivo		; se ottengo un negativo o zero scrivo
		brp	trab		; se da somma due negativi ottengo un positivo ho traboccamento

conc_pos	ADD	R3,R3,R2	; effettuo la sommatoria
		brzp	scrivo		; se ottengo un positivo o zero scrivo
		brn	trab		; se da somma due positivi ottengo un negativo ho traboccamento

sommo		ADD	R3,R3,R2	; effettuo la sommatoria e poi scrivo
		brnzp	scrivo

trab		AND	R3,R3,#0	; azzero il il registro R3 (Sommatoria)
		brnzp	scrivo

scrivo		STR	R3,R1,#0	; scrivo nella cella di indirizzo contenuto in R1 il valore di R3
		ADD	R1,R1,#1	; incremento arrayR
		brnzp	ciclo		; rieseguo il ciclo

fine		LD	R2,store2	; riporto in R2 il contenuto della cella di indirizzo store2
		LD	R3,store3	; riporto in R3 il contenuto della cella di indirizzo store3
		
;		RET			; ritorno da sottoprogramma

;********* VARIABILI PROGRAMMA ********

arrayA		.fill	#-10
		.fill	#500
		.fill	#32766
		.fill	#-12
		.fill	#15
		.fill	#0

arrayR		.blkw	5

;********* VARIABILI SOTTOPROGRAMMA ********

store2		.blkw	1
store3		.blkw	1

.end					; fine programma