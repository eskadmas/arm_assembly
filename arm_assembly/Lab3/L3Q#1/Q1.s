; THE SOLUTION OF LAB3 QUESTION #1

	AREA cmpop, CODE, READONLY
		
								; Name this block of code as cmpop
	ENTRY						; Mark first instruction to execute
	
Start
		BL Task1				; Branch to first subroutine
		BL Task2				; Branch to second subroutine
Stop
        MOV      R0, #0x18      ; angel_SWIreason_ReportException
        LDR      R1, =0x20026   ; ADP_Stopped_ApplicationExit
        SVC      #0x123456      ; ARM semihosting (formerly SWI)

Task1

		MOV R0, #200			; Set up parameters
		MOV R1, #5
		MOV R2, #9
		MOV R3, #100
		MOV R4, #6
		MOV R5, #6
		MOV R6, #20
		MOV R7, #10
		
		BX LR
		
Task2	
		CMP R0, R1				; CMP instruction subtracts the value of R1 from R0, but does not place the result in any register
		BEQ Equal				; If R0 = R1, it jumps to the label Equal
		ADD R8, R0, R1			; Add R0 and R1 and puts the result in R8
		;UDIV R8, R8, #2		; R8 = R8/2
		MOV R8, R8, LSR #1		; R8 = R8/2
		B	CMP2
		
Equal
		MUL R8, R0, R1			; R8 = R0 * R1

CMP2	CMP R2, R3				; CMP instruction subtracts the value of R3 from R2, but does not place the result in any register
		BEQ Equal1				; If R2 = R3, it jumps to the label Equal1
		ADD R9, R2, R3			; Add R2 and R3 and puts the result in R9
		;UDIV R9, R9, #2		; R9 = R9/2
		MOV R9, R9, LSR #1		; R9 = R9/2
		B	CMP3
		
Equal1
		MUL R9, R2, R3			; R9 = R2 * R3
		
CMP3	CMP R4, R5				; CMP instruction subtracts the value of R5 from R4, but does not place the result in any register
		BEQ Equal2				; If R4 = R5, it jumps to the label Equal2
		ADD R10, R4, R5			; Add R4 and R5 and puts the result in R10
		;UDIV R10, R10, #2		; R10 = R10/2
		MOV R10, R10, LSR #1	; R10 = R10/2
		B	CMP4
		
Equal2
		MUL R10, R4, R5			; R10 = R4 * R5
		
CMP4	CMP R6, R7				; CMP instruction subtracts the value of R7 from R6, but does not place the result in any register
		BEQ Equal3				; If R6 = R7, it jumps to the label Equal3
		ADD R11, R6, R7			; Add R6 and R7 and puts the result in R11
		;UDIV r11, r11, #2		; R11 = R11/2
		MOV R11, R11, LSR #1	; R11 = R11/2	
		BX LR
		
Equal3
		MUL R11, R6, R7			; R11 = R6 * R7
		
		BX LR

		END						; Mark end of file
			