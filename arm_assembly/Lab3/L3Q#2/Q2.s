; THE SOLUTION OF LAB 3 QUESTION #2

	AREA sortconst, CODE, READONLY
		
								; Name this block of code as sortconst			
	ENTRY						; Mark first instruction to execute
	
Start
        BL       Main             ; Branch to first subroutine
        BL       FinalTask        ; Branch to second subroutine

Stop
        MOV      R11, #0x18      ; angel_SWIreason_ReportException
        LDR      R12, =0x20026   ; ADP_Stopped_ApplicationExit
        SVC      #0x123456       ; ARM semihosting (formerly SWI)
		
Main

; It initializes registers R0-R2 with immediate values

	MOV R0, #50					; Set up parameters
	MOV R1, #35
	MOV R2, #10
	MOV R4, #0
	MOV R5, #0
	
; It sorts registers; at the end R0 will contain the smallest value and R2 will contain the biggest one

	CMP R0, R1
	BHI Higher1
	B Next
	
Higher1
	MOV R3, R0
	MOV R0, R1
	MOV R1, R3
	SUB R3, R3, R3
	
Next 
	CMP R1, R2
	BHI Higher2
	B Next1
	 
Higher2
	MOV R3, R1
	MOV R1, R2
	MOV R2, R3
	SUB R3, R3, R3
	
Next1 
	CMP R0, R1
	BHI Higher3
	BX LR

Higher3
	MOV R3, R0
	MOV R0, R1
	MOV R1, R3
	SUB R3, R3, R3
	BX LR
	
FinalTask
;This part of the code enables to check whether the two biggest elements are multipliers of the smallest one.

	;MOV R6, #35 :MOD: 10	; R6 will contain the remainder
	;CMP R6, #0
	;BEQ Division1
	;BHI Next2
	
Division1

	MOV R6, R1
	
	; This portion of code enables to divide R6 by R0 and the quetient will be on R4 
L1	
	SUBS R6, R6, R0		;subtract R0 from R6 and store result back in R6 setting flags	
	ADD R4, R4, #1		;add 1 to counter (R4), NOT setting flags
	CMP R6, R0
	BHS L1				;branch to start of loop on condition when R6 is still greater than or equal to R0.
		
Division2

	MOV R7, R2

	; This portion of code enables to divide R7 by R0 and the quetient will be on R5 while the remainder stays on R7
L2	
	SUBS R7, R7, R0		;subtracts R0 from R7 and stores result back in R7 setting flags	
	ADD R5, R5, #1		;add 1 to counter (R5), NOT setting flags
	CMP R7, R0
	BHS L2				;branch to start of loop on condition when R7 is still greater than or equal to R0. 

	BX LR

	END					; Mark end of file
		