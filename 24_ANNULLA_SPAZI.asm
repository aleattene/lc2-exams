; ************ DESCRIZIONE SOTTOPROGRAMMA ************

Il seguente sottoprogramma denominato ANNULLA_SPAZI riceve:
- nel registro R0 l’indirizzo della prima cella di una zona di memoria contenente una stringa 
	di caratteri codificati ASCII (un carattere per cella). 
	La stringa è terminata dal valore 0 (corrispondente al carattere NUL);
- nel registro R1 l’indirizzo della prima cella di una zona di memoria libera, di dimensioni 
	sufficienti per contenere la stringa di caratteri di cui sopra.
Il sottoprogramma inoltre:
- trascrive la stringa dalla zona di memoria puntata da R0 a quella puntata da R1, facendo in modo che
	non esistano spazi doppi o multipli fra le parole, né spazi iniziali o finali 
	(cioè prima della prima parola o dopo l’ultima parola). 
	La stringa trascritta deve essere terminata dal valore 0 (carattere NUL);
- restituisce nel registro R2 il numero totale di spazi eliminati.
Si ricorda che nel codice ASCII il carattere spazio ha codifica decimale 32 (esadecimale x20).
Nonostante l'utilizzo di altri registri della CPU, il sottoprogramma restituisce 
il controllo al programma chiamante senza che tali registri risultino alterati.

; ************ ESEMPIO FUNZIONAMENTO SOTTOPROGRAMMA ************

INPUT
R0 punta alla zona di memoria contenente la stringa “ Un esempio di frase con spazi multipli 
	tra le parole e spazi iniziali e finali inutili ”
R1 punta all’inizio di una zona di memoria libera

OUTPUT
R1 punta all’inizio della zona di memoria prima libera, che ora contiene la stringa “Un esempio 
	di frase con spazi multipli tra le parole e spazi iniziali e finali inutili”
R2 contiene il valore 12

; ********* PROGRAMMA TEST *************

.orig		x3000
		LEA	R0, stringaS	; in R0 <- indirizzo inizio stringaS (array)
		LEA	R1, stringaR	; in R1 <- indirizzo inizio stringaR (vuota)

; ********* SOTTOPROGRAMMA *************

; ANNULLA_SPAZI				; nome sottoprogramma

		ST	R3, store3	; contenuto R3 -> in cella indirizzo store3
		ST	R4, store4	; contenuto R4 -> in cella indirizzo store4
		ST	R5, store5	; contenuto R5 -> in cella indirizzo store5
		ST	R6, store6	; contenuto R6 -> in cella indirizzo store6

		LD	R2, spazio	; in R2 <- decimanele opposto ASCII "spazio"	
		AND	R5,R5,#0	; azzero contatore spazi inutili (da eliminare)
		AND	R6,R6,#0	; contatore "spazio_init" e "ASCII null (/0)"

ciclo		LDR	R3,R0,#0	; in R3 <- ASCII carat puntato da R0 (stringaS)
		BRZ	fine		; se zero sequenza (stringaS) finita -> fine
					; altrimenti....
		ADD	R4,R3,R2	; confronto carattere stringa con  spazio
		BRZ	ver_spazio	; se trovo uno spazio "analizzo" la tipologia
					; altrimenti.....

scrivi		STR	R3,R1,#0	; scrivo carattere cella stringaS in stringaR
		ADD	R0,R0,#1	; incremento cella puntata da R0 (stringa S)		
		ADD	R1,R1,#1	; incremento cella puntata da R1 (stringa R)
		BRNZP	ciclo		; continuo scansione stringa sino fine (/0)

ver_spazio	AND	R6,R6,R6	; verifico check spazio inziale
		BRZ	el_spazio	; se spazio inizio stringa lo elimino

		LDR	R4,R0,#1	; leggo carattere successivo stringaS
		BRZ	el_spazio	; se fine stringa (null /0) elimino spazio
		ADD	R4,R4,R2	; altrimenti confronto carattere - spazio
		BRZ	el_spazio	; se trovo un altro spazio lo elimino

		BRNP	scrivi		; altrimenti è uno spazio da lasciare...

el_spazio	ADD	R6,R6,#1	; incremento check spazio init (init stringaS)
		ADD	R5,R5,#1	; incremento contatore spazi inutili
		ADD	R0,R0,#1	; incremento cella puntata da R0 (stringaS)
		BRNZP	ciclo		; continuo scansione stringa sino fine (/0)
	
fine		AND	R6,R6,#0	; azzero contatore R6 -> per ASCII /0 stringaR
		STR	R6,R1,#0	; contenuto R6 -> in cella puntata da R1 (/0)
		ADD	R2,R5,#0	; in R2 <- valore R5 (contatore spazi inutili)

		LD	R3, store3	; contenuto cella indirizzo store3 -> in R3
		LD	R4, store4	; contenuto cella indirizzo store4 -> in R4
		LD	R5, store5	; contenuto cella indirizzo store5 -> in R5
		LD	R6, store6	; contenuto cella indirizzo store6 -> in R6

; 		RET			; ritorno da sottoprogramma

; ********* VAR / COST *************

store3		.blkw	1		; riservo una cella di memora per contenuto R3
store4		.blkw	1		; riservo una cella di memora per contenuto R4
store5		.blkw	1		; riservo una cella di memora per contenuto R5
store6		.blkw	1		; riservo una cella di memora per contenuto R6

stringaS	.stringz " Un esempio   di frase   con    spazi   multipli tra le   parole e spazi inizliali e finali inutili "

stringaR	.blkw	88		; riservo 88 celle memoria per stringaR

spazio		.fill	#-32 		; valore decimale opposto carat ASCII "spazio"

.end					; fine programma
