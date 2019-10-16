;THE SOLUTION OF LAB3 QUESTION #3

	AREA MyData, DATA, READWRITE
		
mem_block SPACE 100					; A suitable block of memory in data area

	AREA Loadcon, CODE, READONLY
		
        ENTRY						; Mark first instruction to execute
		
Start
        BL       MAIN				; Branch to first subroutine	
		
Stop
        MOV      R9, #0x18			; angel_SWIreason_ReportException
        LDR      R10, =0x20026		; ADP_Stopped_ApplicationExit
        SVC      #0x123456			; ARM semihosting (formerly SWI)
	
		; The literal pool with 8 constants
		
literal_list	DCD		100, 80, 50, 40, 29, 20, 10, 9
	
MAIN

	LDR R0, =literal_list		; The address of the 1st element of the literal pool is loaded into R0 
	LDR R1, =0					; Counter Register to get each literal_list value  
	
	; Loading the values to registers
		
	LDR R2, [R0, R1, LSL #2]	; Loads the 1st element of the literal pool into R2
	ADD R1, R1, #1				; Increments the Counter Register (R1) by 1 
	LDR R3, [R0, R1, LSL #2]	; Loads the 2nd element of the literal pool into R3
	
	CMP R2, R3					; Compares the value of the 1st element to the 2nd element
	BLS ASCENDING				; If R2 <= R3, it jumps to ascending
	BHI DESCENDING				; If R2 > R3, it jumps to descending
	
; If the sequence is an increasing one, the program computes the mean value
	
ASCENDING 

	ADD R5, R2, R3				; R5 will contain the sum of the literal pool values
	ADD R1, R1, #1				; Increments the Counter Register (R1) by 1 

L1
	LDR R4, [R0, R1, LSL #2]	; A literal pool elements are loaded into R4 through a loop
				
	CMP R4, R3					; Compares each consecutive values, to check the sequence is still ascending
	BLO NON_MONOTONIC			; The loop branches when an ascending can't continue

; Sum the values and put the result on R5

	ADD R5, R5, R4				; Adds each value to R5, inorder to get the sum of all of the literal pool values
	MOV R3, R4
	
	ADD R1, R1, #1
	CMP R1, #8					; Checks whether the counter reaches to the number of literal pool elements
	BLO L1						; Branch if it is lower
	
	; Computing the mean (Divide the result of the sum by the number of elements i.e. 8)

	MOV R6, R5, LSR #3 			; Shifts R5 right by 3 bits (divide R5 by 8) and put the result in R6
	
	BX LR						; Branch and link
	
;if the sequence is a decreasing one, the program computes the largest absolute difference between two consecutive numbers

DESCENDING
	
	LDR R11, =mem_block				; The 1st address of a mem_block is loaded into R11
	LDR R12, =0						; Counter Register (R12) to access mem_block addresses 
	
	SUB R5, R2, R3					; R5 = R2 - R3
	STR R5, [R11, R12, LSL #2]		; The difference is stored into the 1st memory address
	ADD R1, R1, #1
	
L2
	LDR R4, [R0, R1, LSL #2]		; A literal pool elements are loaded into R4 through a loop
	
	CMP R4, R3						; Compares each consecutive values, to check the sequence is still descending
	BHI NON_MONOTONIC				; Branches to NON_MONOTONIC if the current element is greater than the previous one 
	
	SUB R5, R3, R4					; Subtracts each consecutive literal pool elements, R5 = R3 - R4
	ADD R12, R12, #1				; Increments the Counter Register (R12) by 1 
	STR R5, [R11, R12, LSL #2]		; The difference is stored into the memory addresses of mem_block
	
	MOV R3, R4						; Moves R4 to R3
	
	ADD R1, R1, #1
	CMP R1, #8						; Compares R1 with 8
	BLO L2							; Branches to L2 if R1 < 8

	SUB R12, R12, R12				; Free R12 inorder to use it in the next task
	LDR R6, [R11, R12, LSL #2]		; The 1st element in the mem_block is loaded to R6
	ADD R12, R12, #1				; Increments the Counter Register (R12) by 1
	
L3
	LDR R7, [R11, R12, LSL #2]		; The 2nd element in the mem_block is loaded to R7
	
;At the end R6 will contain the largest difference between any of the two consecutive mem_block values. 

	CMP R6, R7
	BHS NEXT			; Branch if R6 >= R7
	MOV R6, R7			; At the end of this loop, R6 will contain the largest difference

NEXT

	ADD R12, R12, #1
	CMP R12, #7			; mem_block has 7 values
	BLO L3				

	BX LR
	
; If the literal pool values are niether ascending nor descending, this block of code will be executed 

NON_MONOTONIC			

; This is to find the maximum value of the literal_list

	SUB R1, R1, R1				; Free the counter register of literal_list 			
	LDR R2, [R0, R1, LSL #2]	; Loads the 1st element of the literal_list to R2
	ADD R1, R1, #1
	
L4
	LDR R3, [R0, R1, LSL #2]	
	
	CMP R2, R3
	BHS NEXT1
	MOV R2, R3					; At the end of this loop, R2 will contain the maximum value

NEXT1
	
	ADD R1, R1, #1
	CMP R1, #8
	BLO L4

; This is to find the minimum value of the literal_list

	SUB R1, R1, R1
	LDR R4, [R0, R1, LSL #2]
	ADD R1, R1, #1
	
L5
	LDR R5, [R0, R1, LSL #2]
	
	CMP R4, R5
	BLS NEXT2
	MOV R4, R5				; At the end of this loop, R4 will contain the minimum value

NEXT2
	
	ADD R1, R1, #1
	CMP R1, #8
	BLO L5
	
	BX LR	

    END       