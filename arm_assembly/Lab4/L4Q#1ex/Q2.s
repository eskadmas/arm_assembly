; THE SOLUTION OF LAB 4 - BUBBLE SORT

	AREA MyData, DATA, READWRITE
		
ORDERED_TABLE SPACE 400						; A suitable block of memory in data area
	
	AREA MyCode, CODE, READONLY
		
		ENTRY
	
START
		BL 		MAIN
	
STOP
        MOV      R11, #0x18      		; angel_SWIreason_ReportException
        LDR      R12, =0x20026   		; ADP_Stopped_ApplicationExit
        SVC      #0x123456      		; ARM semihosting (formerly SWI)
		
Price_list 
	
	DCD 0x010, 8, 0x007, 10, 0x006, 15, 0x047, 7, 0x00A, 5   ; These values are stored in memory and they can be addressed 
	DCD 0x012, 7, 0x016, 22, 0x017, 17, 0x018, 38, 0x01A, 22  ; with the label value «Price_list»	
	DCD 0x01B, 34, 0x01E, 11, 0x022, 3, 0x023, 9, 0x025, 40
	DCD 0x027, 12, 0x028, 11, 0x02C, 45, 0x02D, 10, 0x031, 40
	DCD 0x033, 45, 0x035, 9, 0x036, 11, 0x039, 12, 0x03C, 19
	DCD 0x03E, 1, 0x041, 20, 0x042, 30, 0x045, 12, 0x004, 20
	
MAIN

	LDR R0, =Price_list			; Load an address of the 1st element in Price_list table into - R0
	LDR R1, =ORDERED_TABLE		; Load the 1st address of memory block result
	MOV R2, #29					; There are 30 items. So, we have 29 consecutive pairs of them. So, pairs = 29
	MOV R3, #31	

Price_order

	SUB R3, R3, #1					; The number of elements compared in the inner loop
    MOV R4, #0						; R4 is a counter (like j in the C program)
	
	LDR R5, [R0, R4, LSL #3]		; Loads the 1st element to R5
	MOV R6, R4, LSL #1
	ADD R6, R6, #1
	LDR R7, [R0, R6, LSL #2]		; Loads the price of the 1st element to R7
	ADD R4, R4, #1
	
Inner_loop
	
	LDR R8, [R0, R4, LSL #3]		; Loads the 2nd element to R8
	MOV R9, R4, LSL #1
	ADD R9, R9, #1
	LDR R10, [R0, R9, LSL #2]   	; Loads the price of the 2nd element to R10
	
	CMP R5, R8
	BHI Label
	
; Store R5, R7, R8, and R10 to the consecutive memory addresses	

	SUB R4, R4, #1
	STR R5, [R1, R4, LSL #3]		; Stores the 1st element(i.e. R5) on the 1st address in result
	MOV R6, R4, LSL #1
	ADD R6, R6, #1	
	STR R7, [R1, R6, LSL #2]		; Stores the price of the 1st element next to it	
	ADD R4, R4, #1
	STR R8, [R1, R4, LSL #3]		; Stores the 2nd element(i.e. R8) on result
	MOV R9, R4, LSL #1
	ADD R9, R9, #1	
	STR R10, [R1, R9, LSL #2]
	ADD R6, R6, #1
	
	MOV R5, R8
	MOV R7, R10
	B Next
	
Label

	STR R5, [R1, R4, LSL #3]		; Stores the 1st element(i.e. R5) on the 2nd address
	STR R7, [R1, R9, LSL #2]
	SUB R4, R4, #1
	STR R8, [R1, R4, LSL #3]		; Stores the 2nd element(i.e. R8) on the 1st address
	STR R10, [R1, R6, LSL #2]
	ADD R4, R4, #1
	ADD R6, R6, #1
	
Next
	ADD R6, R6, #1
	ADD R4, R4, #1	
	CMP R4, R3
	BLO Inner_loop
	
	SUB R2, R2, #1
	LDR R0, =ORDERED_TABLE
	CMP R2, #0
	BHI Price_order
	
	BX LR

	END
	