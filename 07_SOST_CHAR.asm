; ************ DESCRIZIONE SOTTOPROGRAMMA ************

Il seguente sottoprogramma denominato SOST_CHAR riceve:
- nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa di caratteri
	codificati in codice ASCII. La stringa è terminata dal valore 0 (corrispondente al carattere NUL);
- nel registro R1 il codice ASCII di una lettera minuscola da eliminare (ricordando che le lettere minuscole
	hanno codifiche decimali da “a”=97 a “z”=122);
- nel registro R2 il codice ASCII di una lettera minuscola da inserire.
Il sottoprogramma modifica la stringa di caratteri, sostituendo alla lettera da eliminare la lettera da
inserire. Qualora la lettera eliminata sia MAIUSCOLA, anche la lettera inserita è MAIUSCOLA. 
Si ricorda che la differenza numerica fra la codifica ASCII di una lettera minuscola e quella della
corrispondente lettera maiuscola espressa in notazione decimale è pari a 32 (quindi per convertire una lettera
minuscola nella corrispondente maiuscola basta sottrarre 32 al codice della lettera minuscola).
Nonostante l'utilizzo di altri registri della CPU, il sottoprogramma restituisce 
il controllo al programma chiamante senza che tali registri risultino alterati.

************ ESEMPIO FUNZIONAMENTO SOTTOPROGRAMMA ************

INPUT
R0 punta alla zona di memoria contenente la stringa “La lapvde rvporta la data MCMXXV”,
R1 contiene il codice ASCII della lettera “v”
R2 contiene il codice ASCII della lettera “i”

OUTPUT
La stringa è diventata “La lapide riporta la data MCMXXI”.

; ******** PROGRAMMA TEST ************

.orig		x3000
		LEA	R0, stringa	; in R0 <- indirizzo inizio stringa (array)
		LD	R1, car_out	; in R1 <- ASCII carattere da eliminare
		LD	R2, car_in	; in R2 <- ASCII carattere da inserire

; ******** SOTTOPROGRAMMA ************

; SOST_CHAR				; nome sottoprogramma
		
		ST	R3, store3	; contenuto R3 -> cella indirizzo store 3
		ST	R4, store4	; contenuto R4 -> cella indirizzo store 3		
		ST	R5, store5	; contenuto R5 -> cella indirizzo store 3
		ST	R6, store6	; contenuto R6 -> cella indirizzo store 3
	
		LD	R5, minu_maiu	; in R5 <- differenza minuscole_maiuscole
		ADD	R5, R5, R1	; in R5 <- ASCII CARATTERE da eliminare
		NOT	R5,R5
		ADD	R5,R5,#1	; - CAR_out
		
		LD	R6, minu_maiu	; in R6 <- differenza minuscole_maiuscole
		ADD	R6, R6, R2	; in R5 <- ASCII CARATTERE da inserire
		
		NOT 	R1,R1
		ADD	R1,R1,#1	; - car_out
				
ciclo		LDR	R3,R0,#0	; in R3 <- ASCII carattere stringa ind in R0
		BRZ	fine		; se zero -> sequenza terminata -> fine
				
		ADD	R4,R3,R1	; in R4 <- confronto "car/CAR" stringa e car eliminare
		BRZ	minu_sost	; se zero -> caratteri uguali -> sostituire carattere
		ADD	R4,R3,R5	; in R4 <- confronto "car/CAR" stringa e CAR eliminare
		BRZ	MAIU_sost	; se zero -> CARATTERI uguali -> sostituire CARATTERE
		ADD	R0,R0,#1	; incremento carattere/CARATTERE indirizzato da R0
		BRNZP	ciclo		; ripetere ciclo sino a fine sequenza (zero)
		
minu_sost	STR	R2,R0,#0	; contenuto R2 -> in cella indirizzata R0 (sost car)
		ADD	R0,R0,#1	; incremento carattere/CARATTERE indirizzato da R0
		BRNZP	ciclo		; ripetere ciclo sino a fine sequenza (zero)

MAIU_sost	STR	R6,R0,#0	; contenuto R6 -> in cella indirizzata R0 (sost CAR)
		ADD	R0,R0,#1	; incremento carattere/CARATTERE indirizzato da R0
		BRNZP	ciclo		; ripetere ciclo sino a fine sequenza (zero)

fine		LD	R3, store3	; contenuto cella indirizzo store 3 -> in R3
		LD	R4, store4	; contenuto cella indirizzo store 4 -> in R4
		LD	R5, store5	; contenuto cella indirizzo store 5 -> in R5
		LD	R6, store6 	; contenuto cella indirizzo store 6 -> in R6		
		
; 		RET			; ritorno da sottoprogramma

; ********** VARIABILI **************

store3		.blkw	1		; riservo una cella memoria per contenuto R3
store4		.blkw	1		; riservo una cella memoria per contenuto R4
store5		.blkw	1		; riservo una cella memoria per contenuto R5
store6		.blkw	1		; riservo una cella memoria per contenuto R6

minu_maiu	.fill	#-32		; differenza ASCII tra minuscola e MAIUSCOLA

stringa		.stringz "La lapvde rvporta la data MCMXXV"

car_out		.fill	#118		; codice ASCII carattere "v"

car_in		.fill	#105		; codice ASCII carattere "V"

.end					; fine programma
