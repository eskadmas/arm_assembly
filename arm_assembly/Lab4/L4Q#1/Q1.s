; THE SOLUTION OF LAB 4 QUESTION #1

	AREA MyData, DATA, READWRITE
		
;res SPACE 2000							; A suitable block of memory in data area

	AREA    MyCode, CODE, READONLY
	ENTRY
	
START
		BL		MAIN
	
STOP
        MOV      R11, #0x18      		; angel_SWIreason_ReportException
        LDR      R12, =0x20026   		; ADP_Stopped_ApplicationExit
        SVC      #0x123456      		; ARM semihosting (formerly SWI)

Price_list 

	DCD 0x004, 20, 0x006, 15, 0x007, 10, 0x00A, 5, 0x010, 8   ; These values are stored in memory and they can be addressed 
	DCD 0x012, 7, 0x016, 22, 0x017, 17, 0x018, 38, 0x01A, 22  ; with the label value «Price_list»	
	DCD 0x01B, 34, 0x01E, 11, 0x022, 3, 0x023, 9, 0x025, 40
	DCD 0x027, 12, 0x028, 11, 0x02C, 45, 0x02D, 10, 0x031, 40
	DCD 0x033, 45, 0x035, 9, 0x036, 11, 0x039, 12, 0x03C, 19
	DCD 0x03E, 1, 0x041, 20, 0x042, 30, 0x045, 12, 0x047, 7
		
Item_list DCD 0x022, 4, 0x006, 1, 0x03E, 10, 0x017, 2			; The list of items to buy

MAIN
	;LDR R2, [R1] ; Load R2 with contents of memory location pointed by contents of R1
	
	LDR R0, =Price_list			; An address of the 1st element in the Price_list table is loaded into R0
	LDR R1, =Item_list			; An address of the 1st element in the Item_list table is loaded into R1
	;LDR R2, =res
	MOV R5, #0					; Counter Register that counts the number of Item_list table elements

Outer
	MOV R3, #0					; First Index of Price_list, R3 will always contain the 1st index of a specific range
	MOV R4, #29					; Last Index of Price_list, R4 will always contain the last index of a specific range	
	LDR R7, [R1, R5, LSL #3]	; The 1st Item_code in the Item_list table, which will be searched in Price_list table
	
Inner
	ADD R6, R4, R3				; The sum of the 1st and the last Indexes
	MOV R6, R6, LSR #1			; R6 = R6/2, R6 will always contain the middle index of a specific range
	LDR R8, [R0, R6, LSL #3]	; The middle Item_code in the Price_list table is loaded into R8

	CMP R7, R8					; Comparing an Item_code of Item_list(it is in R7) with the meddle Item_code of the Price_list (it is in R8)
	BEQ L1						; Branch if Equal
	BLO L2						; Branch if Lower
	BHI L3						; Brach if Higher
	
L1
	MOV R12, R5, LSL #1
	ADD R12, R12, #1				; R12 is a pointer to acces the quantitiy of each item
	LDR R9, [R1, R12, LSL #2]		; The quantity of the 1st item
	MOV R6, R6, LSL #1				
	ADD R6, R6, #1					; Here, R6 is a pointer to access the price of an item
	LDR R11, [R0, R6, LSL #2]		; The price of the middle element of the Price_list
	MUL R12, R9, R11				; An expense of a given item
	ADD R10, R10, R12				; Add the expense to R10, and the total sum of expenses will be stored in R10
	B Final
	
L2
	SUB R6, R6, #1					; The new last index of an element
	MOV R4, R6						; Moves the new last index to R4
	LDR R8, [R0, R4, LSL #3]		; The new last element of the Price_list
	B Inner
	
L3
	ADD R6, R6, #1					; The new first index of an element	
	MOV R3, R6						; Moves the new first index to R3
	LDR R8, [R0, R3, LSL #3]		; The new first element of the Price_list
	B Inner
	
Final
	ADD R5, R5, #1
	CMP R5, #4						; R5 is a counter of the number of Item_list elements
	BLO Outer
	
	BX LR

	END