; THE SOLUTION OF LAB 6 QUESTION #1

;Mode_ABT        EQU     0x17
	
	AREA MyData, DATA, READWRITE
		
MEM_B SPACE 10
	
	AREA MyCode, CODE, READONLY
		
		ENTRY
	;MAP  0xF800, 0xF8FF  READ WRITE  // allow R/W access to IO space
	
START

		BL		MAIN

SWI_Handler	
				STMFD 	SP!, {R0-R12, LR}
				LDR 	R9, [LR, #-4]
				BIC 	R10, R9, #0xff000000
				; test the identification code of the interrupt
				
				CMP 	R10, #0x10
				BNE 	second_case
				
				MOV R6, #0x7FFFFFFF

second_case
				CMP		R10, #0x20
				BNE		end_swi
				
				MOV R6, #0x80000000

end_swi			;LDMFD 	SP!, {R0-R12, PC}^
				B	L2	

literal_1 DCD 0x10, 0x70000000, 0xFFFFFFE0, 0x800000F0, 0x100EC023
literal_2 DCD 0x200, 0x12345678, 0xE00A1238, 0xF0004538, 0xE9800348
		
MAIN

	LDR R0, =literal_1		; The address of the 1st literal pool element is loaded into R0 
	LDR R1, =literal_2		; The address of the 2nd literal pool element is loaded into R1 
	LDR R2, =MEM_B			; The 1st memory address to store the sum of the corresponding elements in the two literal pools
	LDR R3, =0				; Counter Register
	LDR R6, =0				; Result Register
				
LOOP
	
	LDR R4, [R0, R3, LSL #2]		; The 1st element in the 1st literal pool
	LDR R5, [R1, R3, LSL #2]		; The 1st element in the 2nd literal pool
	ADD R6, R4, R5
	
; If R4 and R5 are positive and R6 is negative, set R6 = 0x7FFFFFFF 

	CMP R4, #0
	BMI L1					; Branch if R4 is negative 
	CMP R5, #0
	BMI L1					; Branch if R5 is negative 
	CMP R6, #0
	BPL L2					; Branch if R6 is positive or zero - Greater than or equal, or unordered
	
	;MOV R6, #0x7FFFFFFF	
	SWI #0x10				; There is an overflow case and this instruction calls SWI to set R6=#0x7FFFFFFF 
	
L1 
; If R4 and R5 are negative and R6 is possitive, set R6 = 0x80000000

	CMP R4, #0
	BPL L2					; Branch if R4 is positive or zero
	CMP R5, #0
	BPL L2					; Branch if R5 is positive or zero

	CMP R6, #0
	BMI L2
	
	;MOV R6, #0x80000000	
	SWI #0x20				; There is an overflow case and this instruction calls SWI to set R6=#0x80000000 
	
L2
	STR R6, [R2, R3, LSL #2]		; The sum is stored into the 1st memory address
	ADD	R3, R3, #1					; Increment the Counter Register (R3) by 1
	CMP R3, #5						; Increment R3 upto the number of literal pool elements
	BLO	LOOP						; The loop continues 
	
; The following instructions are used to stop the execution of the program

;Vectors     LDR     PC, PAbt_Addr			; prefetch abort
               
;PAbt_Addr   DCD     PAbt_Handler

PAbt_Handler  B     PAbt_Handler
        
	END                     		; Mark end of file
	
	
	
	
	