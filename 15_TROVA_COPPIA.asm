; ************ DESCRIZIONE SOTTOPROGRAMMA ************

Il seguente sottoprogramma denominato TROVA_COPPIA riceve:
- nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa di caratteri
	codificati ASCII (un carattere per cella). La stringa è terminata dal valore 0;
- nei registri R1 e R2 una coppia di caratteri codificati ASCII.
Il sottoprogramma inoltre, restituisce nel registro R0 un numero intero che indica da quale carattere della stringa
inizia la prima occorrenza della coppia di caratteri ricevuti in R1 e R2. Qualora la coppia di caratteri non
compaia nella stringa, il sottoprogramma restituisce in R0 il valore zero.
Nonostante l'utilizzo di altri registri della CPU, il sottoprogramma restituisce 
il controllo al programma chiamante senza che tali registri risultino alterati.

; ************ ESEMPI FUNZIONAMENTO SOTTOPROGRAMMA ************

INPUT 1			 			OUTPUT 1
R0 	indirizzo stringa “ciao mamma” 		R0	6 	la prima “ma” di “mamma” inizia al 6° carattere
R1 		109 (car. “m”)
R2 		 97 (car. “a”)

INPUT 2			 			OUTPUT 2
R0 	indirizzo stringa “ciao papà” 		R0 	0 	la stringa “ciao papà” non contiene la coppia “ma”
R1 		109 (car. “m”)
R2 		 97 (car. “a”)

; ****** PROGRAMMA TEST	*********

.orig		x3000
		LEA	R0, stringaS	; in R0 <- indirizzo inizio stringaS (array)
		LD	R1, car_m	; in R1 <- codifica ASCII primo carat "m"
		LD	R2, car_a	; in R2 <- codifica ASCII secondo carat "a"	

; ****** SOTTOPROGRAMMA	**********

; TROVA_COPPIA
		ST	R3,store3	; contenuto R3 -> in cella indirizzo store3	
		ST	R4,store4	; contenuto R4 -> in cella indirizzo store4
		ST	R5,store5	; contenuto R5 -> in cella indirizzo store5				
		
		AND	R4,R4,#0	; contatore "posizione" carattere stringaS

		NOT 	R1,R1
		ADD	R1,R1,#1	; -R1 ( - m)

		NOT	R2,R2
		ADD	R2,R2,#1	; -R2 ( - a)
				
ciclo		ADD	R4,R4,#1	; incremento "posizione" carattere stringaS
		LDR	R3,R0,#0	; carratere stringa
		BRZ	coppia_no	; se zero -> stringaS terminata -> coppia_no
					; altrimenti....
		
		ADD	R3,R3,R1	; confronto "carattere stringa/primo carattere"
		BRZ	primo_si	; se zero "car uguali" -> verificare secondo
					; altrimenti....
		
		ADD	R0,R0,#1	; incremento cella (car) puntata da R0
		BRNZP	ciclo		; e scansiono stringaS sino fine array car (/0)

primo_si	LDR	R5,R0,#1	; in R5 <- cod ASCCI car successivo stringaS
		BRZ	coppia_no	; se zero -> stringaS terminata -> coppia_no
					; altrimenti....

		ADD	R5,R5,R2	; confronto "carattere stringa/secondo carattere"
		BRZ	coppia_si	; se zero "car uguali" -> coppia trovata (prima)
					; altrimenti....

		BRNP	ciclo		; scansiono stringaS sino fine array car (/0)

coppia_no	AND	R0,R0,#0	; in R0 <- valore output zero (come da specifica)
		BRNZP	fine		

coppia_si	ADD	R0,R4,#0	; coppia trovata -> in R0 prima occorrenza

fine		LD	R3,store3	; contenuto cella indirizzo store3 -> in R3	
		LD	R4,store4	; contenuto cella indirizzo store4 -> in R4
		LD	R5,store5	; contenuto cella indirizzo store5 -> in R5

; ******* VAR / COST ***********

store3 		.blkw	1		; riservo una cella memoria per contenuto R3
store4		.blkw	1		; riservo una cella memoria per contenuto R4
store5		.blkw	1		; riservo una cella memoria per contenuto R5

stringaS
;		.stringz "ciao mamma"
		.stringz "ciao papà"

car_m		.fill	#109		
car_a		.fill	#97

.end					; fine programma test
