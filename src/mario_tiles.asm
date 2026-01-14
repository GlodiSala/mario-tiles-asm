.INCLUDE "m328pdef.inc" ; Load definitions for ATmega328P microcontroller

.macro CHECK_SWITCH
    SBRS R0,0
    RJMP main           
.endmacro
.macro CHECK_KEYBOARD
	Step1:
    LDI R16, 0b00001111  ; Pull-up resistor first so port D then set the input with port D
    OUT PORTD, R16
    LDI R16, 0b11110000 
    OUT DDRD, R16   ; LDS doesn't work directly on these registers
	NOP
	NOP
    IN R16, PIND
    MOV R1, R16
    CPI R16, 0b00001111
    BRNE Step2
    CLT
	CHECK_SWITCH
	EOR R2,R2
	RJMP end
Step2:
    LDI R16, 0b11110000
    OUT PORTD, R16
    LDI R16, 0b00001111
    OUT DDRD, R16  
	NOP
	NOP
    IN R2, PIND
	EOR R2, R1  
	end:
.endmacro

.macro LOAD_CHARACTER
Character1:	
    LDI YL, 0x00     ; Initialize Y pointer to 0x100
    LDI YH, 0x01
    ; Loop through characters
    LDI R16, 1       ; Initialize character index to 1
CharacterLoop:
    CP R27, R16     ; Compare character index with R27
    BRNE NextCharacter  ; If not equal, move to the next character
    ; Load character address into R26 from memory pointed by Y
    LD R26, Y+
    ; Jump to LoadCharacter
    JMP LoadChar
NextCharacter:
    INC R16          ; Increment character index
	INC YL
	CPI R16,11
	BREQ NewValue
    CPI R16, 17      ; Check if all characters have been checked
    BRNE CharacterLoop  ; If not, loop to the next character
NewValue:
	LDI YL, 0x10     ; Initialize Y pointer to 0x100
    LDI YH, 0x01
	RJMP CharacterLoop

	LoadChar:; Code to load and display the character from the selected table
	LDI R20, 0
    ADD ZL, R26
    ADC ZH, R20
    ADD ZL, R26
    ADC ZH, R20
.endmacro

.macro SCREEN1
	LDI R23,20				;free
	STS 0x0103,R23
	LDI R23,68    	
	STS 0x0104,R23
	LDI R23,16
	STS 0x0105,R23
	STS 0x0106,R23
	LDI R23, 144
	STS 0x0107,R23    
	STS 0x0101, R23
	STS 0x0102, R23
	STS 0x0109,R23
	STS 0x0110,R23
	
	LDI R23, 44 			;level
    STS 0x0111,R23
	LDI R23, 16
    STS 0x0112,R23
	STS 0x0114,R23
	LDI R23, 84
    STS 0x0113,R23
	LDI R23, 44 			;level
    STS 0x0115,R23

	;BST R22,0			;TEST FOR THE REGISTER OF THE MOUSE POSITION R22
	;BRTS Souris2
	SBRC R22,0
	rjmp Souris2

	LDI R23, 148 			;ARROW
	STS 0x0100,R23
	LDI R23, 144			;NOTHING
	STS 0x0108,R23   
	JMP end
	Souris2:
	LDI R23, 148 			;ARROW
	STS 0x0108,R23
	LDI R23, 144			;NOTHING
	STS 0x0100,R23
	end:
.endmacro

.macro SCREEN2
LDI R23,20				;free
		STS 0x0103,R23
		LDI R23,68    	
		STS 0x0104,R23
		LDI R23,16
		STS 0x0105,R23
		STS 0x0106,R23
		LDI R23, 144
		STS 0x0107,R23    
		STS 0x0101, R23
		STS 0x0102, R23
		STS 0x0109,R23
		STS 0x0110,R23
		STS 0x0100,R23
		STS 0x0108, R23

		LDI R23, 20 			;level
		STS 0x0111,R23
		LDI R23, 68
		STS 0x0112,R23
		STS 0x0114,R23
		LDI R23, 16
		STS 0x0113,R23
		LDI R23, 16 			;level
		STS 0x0115,R23
.endmacro
.macro SCREEN3
		LDI R23, 144 
		STS 0x0101, R23
		STS 0x0102, R23
		STS 0x0103,R23
		STS 0x0104,R23
		STS 0x0105,R23
		STS 0x0106, R23
		STS 0x0107,R23   
		STS 0x0108,R23   
		STS 0x0109,R23   

		STS 0x0110,R23   
		STS 0x0111,R23   
		STS 0x0112,R23   
		STS 0x0113,R23   
		STS 0x0114,R23   
		STS 0x0115,R23   
		STS 0x0116,R23   

.endmacro
.macro SCREEN4
	LDI R23,60
	STS 0x101,R23 ;P
	LDI R23,68
	STS 0x102,R23 ;R
	LDI R23,16      
	STS 0x103,R23 ; E
	LDI R23,72    ;S
	STS 0x104,R23    
	STS 0x105,R23 ;S
	
	LDI R23,152
	STS 0x0108,R23
	
	LDI R23,152   
	STS 0x0115,R23   

	LDI R23,144
	STS 0x0100,R23  
	STS 0x0110,R23   
	STS 0x0111,R23   
	STS 0x0112,R23   
	STS 0x0113,R23   
	STS 0x0114,R23   


	MOV R23, R1                 ; Copy R1 to R23
    CPI R23, KEY_7              ; Compare R23 with KEY_7
    BREQ Carac7Found            ; If equal, jump to Carac7Found
    CPI R23, KEY_8              ; Compare R23 with KEY_8
    BREQ Carac8Found            ; If equal, jump to Carac8Found
    CPI R23, KEY_9              ; Compare R23 with KEY_9
    BREQ Carac9Found            ; If equal, jump to Carac9Found
    CPI R23, KEY_F              ; Compare R23 with KEY_F
    BREQ CaracFFound            ; If equal, jump to CaracFFound
    CPI R23, KEY_4              ; Compare R23 with KEY_4
    BREQ Carac4Found            ; If equal, jump to Carac4Found
    CPI R23, KEY_5              ; Compare R23 with KEY_5
    BREQ Carac5Found            ; If equal, jump to Carac5Found
    CPI R23, KEY_6              ; Compare R23 with KEY_6
    BREQ Carac6Found            ; If equal, jump to Carac6Found
    CPI R23, KEY_E              ; Compare R23 with KEY_E
    BREQ CaracEFound            ; If equal, jump to CaracEFound
    CPI R23, KEY_1              ; Compare R23 with KEY_1
    BREQ Carac1Found            ; If equal, jump to Carac1Found
    CPI R23, KEY_2              ; Compare R23 with KEY_2
    BREQ Carac2Found            ; If equal, jump to Carac2Found
    CPI R23, KEY_3              ; Compare R23 with KEY_3
    BREQ Carac3Found            ; If equal, jump to Carac3Found
    CPI R23, KEY_D              ; Compare R23 with KEY_D
    BREQ CaracDFound            ; If equal, jump to CaracDFound
    CPI R23, KEY_A              ; Compare R23 with KEY_A
    BREQ CaracAFound            ; If equal, jump to CaracAFound
    CPI R23, KEY_0              ; Compare R23 with KEY_0
    BREQ Carac0Found            ; If equal, jump to Carac0Found
    CPI R23, KEY_B              ; Compare R23 with KEY_B
    BREQ CaracBFound            ; If equal, jump to CaracBFound
    CPI R23, KEY_C              ; Compare R23 with KEY_C
    BREQ CaracCFound            ; If equal, jump to CaracCFound
    LDI R23, 144                ; Otherwise, set R23 to default value
Carac7Found:
    LDI R23, 132
    RJMP EndKeyCheck
Carac8Found:
    LDI R23, 136
    RJMP EndKeyCheck
Carac9Found:
    LDI R23, 140
    RJMP EndKeyCheck
CaracFFound:
    LDI R23, 20
    RJMP EndKeyCheck
Carac4Found:
    LDI R23, 120
    RJMP EndKeyCheck
Carac5Found:
    LDI R23, 124
    RJMP EndKeyCheck
Carac6Found:
    LDI R23, 128
    RJMP EndKeyCheck
CaracEFound:
    LDI R23, 16
    RJMP EndKeyCheck
Carac1Found:
    LDI R23, 108
    RJMP EndKeyCheck
Carac2Found:
    LDI R23, 112
    RJMP EndKeyCheck
Carac3Found:
    LDI R23, 116
    RJMP EndKeyCheck
CaracDFound:
    LDI R23, 12
    RJMP EndKeyCheck
CaracAFound:
    LDI R23, 0
    RJMP EndKeyCheck
Carac0Found:
    LDI R23, 104
    RJMP EndKeyCheck
CaracBFound:
    LDI R23, 4
    RJMP EndKeyCheck
CaracCFound:
    LDI R23, 8
    RJMP EndKeyCheck
EndKeyCheck:
STS 0x0107, R23             ; Store R23 to memory address 0x0100
.endmacro
.macro SCREEN_GAMEOVER
	LDI R23,24
	STS 0x100,R23 ;G
	LDI R23,0
	STS 0x101,R23 ;A
	LDI R23,48      
	STS 0x102,R23 ; M
	LDI R23,16    
	STS 0x103,R23  ; E
	STS 0x106,R23 
	LDI R23,56 
	STS 0x104,R23 ; O
	LDI R23,84
	STS 0x105,R23 ;V
	LDI R23,68 ; R
	STS 0x107,R23

	LDI R23,144
	STS 0x0108,R23 
	STS 0x0109,R23 
	STS 0x0110,R23   
	STS 0x0111,R23   
	STS 0x0112,R23   
	STS 0x0113,R23   
	STS 0x0114,R23  
	STS 0x0115,R23

.endmacro
.macro SCREEN6
	LDI R23,72				;score
	STS 0x0100,R23

	LDI R23,4    	
	STS 0x0101,R23

	LDI R23,56
	STS 0x0102,R23

	LDI R23,68
	STS 0x0103,R23

	LDI R23,16
	STS 0x0104,R23

	LDI R23,144
	STS 0x0105,R23
	STS 0x0106,R23
	STS 0x0107,R23
	STS 0x0111,R23
	STS 0x0112,R23
	STS 0x0113,R23
	STS 0x0114,R23
	STS 0x0115,R23
	STS 0x0116,R23
	
	MOV R23,R6
	
	; display the score with r6
	CPI R23,100
	BRGE centaine
	jmp pascentaine
	centaine:
	LDI R23,108
	STS 0x0108, R23
	MOV R23,R6
	SUBI R23,100
	MOV R6,R23
	jmp dizaine
	pascentaine:LDI R23,104
	STS 0x0108, R23

	dizaine:
	MOV R23,R6
	MOV R24,R23

	CPI R23,10
	BRGE d1
	LDI R23,104
	STS 0x0109,R23
	jmp endo
	
	d1:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d2
	LDI R23,108
	STS 0x0109,R23
	jmp endo

	d2:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d3

	LDI R23,112
	STS 0x0109,R23
	jmp endo

	d3:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d4

	LDI R23,116
	STS 0x0109,R23
	jmp endo

		d4:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d5
	LDI R23,120
	STS 0x0109,R23
	jmp endo

	d5:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d6
	LDI R23,124
	STS 0x0109,R23
	jmp endo

	d6:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d7
	LDI R23,128
	STS 0x0109,R23
	jmp endo

	d7:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d8
	LDI R23,132
	STS 0x0109,R23
	jmp endo

	d8:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE d9
	LDI R23,136
	STS 0x0109,R23
	jmp endo

	d9:
	subi R24,10
	mov R23,R24
	CPI R23,10
	BRGE endo
	LDI R23,140
	STS 0x0109,R23
	jmp endo




	endo:
	mov R23,R24
	CPI R23,1
	BRGE u1
	LDI R23,104
	STS 0x0110,R23
	jmp end


	u1:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u2
	LDI R23,108
	STS 0x0110,R23
	jmp end

	u2:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u3
	LDI R23,112
	STS 0x0110,R23
	jmp end

	u3:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u4
	LDI R23,116
	STS 0x0110,R23
	jmp end

	u4:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u5
	LDI R23,120
	STS 0x0110,R23
	jmp end

	u5:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u6
	LDI R23,124
	STS 0x0110,R23
	jmp end

	u6:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u7
	LDI R23,128
	STS 0x0110,R23
	jmp end

	u7:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u8
	LDI R23,132
	STS 0x0110,R23
	jmp end

	u8:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE u9
	LDI R23,136
	STS 0x0110,R23
	jmp end

	u9:
	subi R24,1
	mov R23,R24
	CPI R23,1
	BRGE end
	LDI R23,140
	STS 0x0110,R23
	jmp end


	end:
	LDI R24,0

.endmacro
.macro SCREEN7
		LDI R23,28				;High
		STS 0x0100,R23

		LDI R23,32    	
		STS 0x0101,R23

		LDI R23,24
		STS 0x0102,R23

		LDI R23,28
		STS 0x0103,R23

		

		LDI R23,72				;score
		STS 0x0108,R23

		LDI R23,4    	
		STS 0x0109,R23

		LDI R23,56
		STS 0x0110,R23

		LDI R23,68
		STS 0x0111,R23

		LDI R23,16
		STS 0x0112,R23

		LDI R23, 144 
		STS 0x0113, R23
		STS 0x0114, R23
		STS 0x0115,R23
		STS 0x0116,R23
		STS 0x0104,R23
	 STS 0x0105,R23
	  STS 0x0106,R23
	   STS 0x0107,R23
.endmacro
.CSEG
; General formula for OCR (output compare register) computation:

; Constants for notes frequencies

.equ E4 = (0xFF - (62500 / 329))
.equ F4 = (0xFF - (62500 / 349))
.equ Fs4 = (0xFF - (62500 / 370))
.equ G4 = (0xFF - (62500 / 392))
.equ Gs4 = (0xFF - (62500 / 415))
.equ A4 = (0xFF - (62500 / 440))
.equ As4 = (0xFF - (62500 / 466))
.equ B4 = (0xFF - (62500 / 494))
.equ C5 = (0xFF - (62500 / 523))
.equ Cs5 = (0xFF - (62500 / 554))
.equ D5 = (0xFF - (62500 / 587))
.equ Ds5 = (0xFF - (62500 / 622))
.equ E5 = (0xFF - (62500 / 659))
.equ F5 = (0xFF - (62500 / 698))
.equ Fs5 = (0xFF - (62500 / 740))
.equ G5 = (0xFF - (62500 / 784))
.equ Gs5 = (0xFF - (62500 / 831))
.equ A5 = (0xFF - (62500 / 880))
.equ As5 = (0xFF - (62500 / 932))
.equ B5 = (0xFF - (62500 / 988))
.equ C6 = (0xFF - (62500 / 1047))
.equ Cs6 = (0xFF - (62500 / 1109))
.equ D6 = (0xFF - (62500 / 1175))
.equ Ds6 = (0xFF - (62500 / 1245))
.equ E6 = (0xFF - (62500 / 1319))
.equ F6 = (0xFF - (62500 / 1397))
.equ Fs6 = (0xFF - (62500 / 1480))
.equ G6 = (0xFF - (62500 / 1568))
.equ Gs6 = (0xFF - (62500 / 1661))
.equ A6 = (0xFF - (62500 / 1760))
.equ As6 = (0xFF - (62500 / 1865))
.equ B6 = (0xFF - (62500 / 1976))
.equ C7 = (0xFF - (62500 / 2093))




;Constant for SW
; Define constants for each key
.equ KEY_7 = 0b01110111 ; Constant for key 7
.equ KEY_8 = 0b01111011 ; Constant for key 8
.equ KEY_9 = 0b01111101 ; Constant for key 9
.equ KEY_F = 0b01111110 ; Constant for key F
.equ KEY_4 = 0b10110111 ; Constant for key 4
.equ KEY_5 = 0b10111011 ; Constant for key 5
.equ KEY_6 = 0b10111101 ; Constant for key 6
.equ KEY_E = 0b10111110 ; Constant for key E
.equ KEY_1 = 0b11010111 ; Constant for key 1
.equ KEY_2 = 0b11011011 ; Constant for key 2
.equ KEY_3 = 0b11011101 ; Constant for key 3
.equ KEY_D = 0b11011110 ; Constant for key D
.equ KEY_A = 0b11100111 ; Constant for key A
.equ KEY_0 = 0b11101011 ; Constant for key 0
.equ KEY_B = 0b11101101 ; Constant for key B
.equ KEY_C = 0b11101110 ; Constant for key C



.ORG 0x0000
RJMP init  ; Jump to initialization routine

.ORG 0x0006 ; pg 62 datasheet (FLASH) 
RJMP SW_ISR ; Jump to interrupt service routine



.ORG 0x0012  ; pg 62 datasheet (FLASH) 
RJMP Timer2_ISR  ; Jump to Timer interrupt service routine

.ORG 0x0020
RJMP Timer0_ISR  ; Jump to Timer0 interrupt service routine
 .ORG 0x002A
 RJMP ADC_ISR


init:
	 ; Configure input pin PB0 (Switch)
    CBI DDRB, PB0  ; Set PB0 as input
    SBI PORTB, PB0 ; Enable the pull-up resistor on PB0
    ; Configure output pin PC2-PC3 (LEDs)
	SBI DDRC,2  ; Set PC2 as output
    SBI PORTC,2 ; Set PC2 high (LED1)
    SBI DDRC, PC3  ; Set PC3 as output
    SBI PORTC, PC3 ; Set PC3 output high (Vcc)
	; Configure output pin PB1 buzzer
    SBI DDRB,1  ; Set PB1 as output for the buzzer
    CBI PORTB,1 ; Set PB1 low

    ; Enable Pin Change Interrupt on PCINT0 (PB0)
    LDI R16, (1<<PCIE0) ; Load PCIE0 bit into R16
    STS PCICR, R16      ; Enable Pin Change Interrupt for PCINT7..0
    LDI R16, (1<<PCINT0)|(1<<PCINT2) ; Load PCINT0 bit into R16
    STS PCMSK0, R16      ; Enable Pin Change Interrupt for PCINT0 (PB0)


	 ; Configure Timer0 in Normal Mode with 256 prescaler
    LDI R16, 0b00000100   ; Load immediate value into R16 (prescaler 256)
    OUT TCCR0B, R16       ; Set prescaler for Timer0
    ; Configure Timer0 Overflow interrupt
    LDI R16, (1<<TOIE0)   ; Load immediate value into R16 to enable Timer0 Overflow interrupt
    STS TIMSK0, R16       ; Enable Timer0 Overflow interrupt

	; Configure Timer2 in Normal Mode with 1024 prescaler
	LDI R16, (1<<CS22)|(1<<CS21)|(1<<CS20)   ; Set prescaler for Timer2 (1024)
	STS TCCR2B, R16                          ; Set prescaler for Timer2
	; Configure Timer2 Overflow interrupt
	LDI R16, (1<<TOIE2)                      ; Enable Timer2 Overflow interrupt
	STS TIMSK2, R16                          ; Enable Timer2 Overflow interrupt


	LDI R16, 0b01100001
	STS ADMUX, R16                          ; page 250 
	LDI R16, 0b11111110  ; Set prescaler for Timer2 (1024)
	STS ADCSRA, R16  
	LDI R16, (0<<PRADC) ;unab
	STS PRR, R16
	LDI R16, (1<<ADTS2)|(0<<ADTS1)|(0<<ADTS1)    ;Auto trigger on overflow of timer zero
	STS ADCSRB,R16

    SEI ; Enable global interrupts

	LDI R23,0
	MOV R6,R23
	
	SBI PORTB, 3
    SBI DDRB, 3
    SBI PORTB, 4
    SBI DDRB, 4
    SBI PORTB, 5
    SBI DDRB, 5

    LDI R16, 0b10000000    ; Initialize once the row value
	MOV R10,R16
    LDI R25, 0
	CBI DDRC,0 
	SBI PORTC,0 
	CBI DDRC,1
	SBI PORTC,1 
	CBI DDRB, 2 
    SBI PORTB, 2 


	LDI R24,1
	LDI R21,1
	LDI R16,1
	MOV R11,R16

	LDI R16,0
	MOV R6,R16
	IN R0, PINB
	RJMP Send1Row

main: 
	; The system is off
	CLT
	SBRC R0,0
	RJMP SW_ON
	SBI PORTC, PC3 ; Turn off the lower LED
	SBI PORTC, PC2 ; Turn off the lower LED

	LDI R21,1
	LDI R23,0b00000001
	MOV R15,R23
	LDI R23,0
	MOV R12,R23

	LDI R16,1
	RJMP main
SW_ON: 
CBI PORTC, PC3 ; Turn on the lower LED

	CPI R21,1
	BRNE Send1Row  ;We look if we need the arrow on the screen (screen 1 is when we need the arrow) SO if the joystick and the pb2 are needed


	
JoystickTest:	
	MOV R23,R9
	CPI R23,200

	BRge openled 
	;BST R0,	0							;We use T to store the register 0 is the left joystick
	;BST R7,	1								; 1 is the top joystick
	;BRTC openled

	SBI PORTC,2 

	rjmp continue
	openled:
	CBI PORTC,2 


	continue:;BRTS NoChange
	MOV R23,R9
	CPI R23,200

	BRge updown 

	
	rjmp NoChange

	updown:
	CPI R24,1
	BREQ Send1Row
	LDI R24,1				;	SIGNAL A CHANGE IN THE SCREEN STATE
	LDI R23,1
	ADD R22,R23					;	SIGNALS WE NEED TO CHANGE THE JOYSTICK POSITION
	RJMP Send1Row

NoChange:
	
	SBRS R15,0 
	LDI R24,0
	LDI R23,0
	MOV R15,R23

	jmp Send1Row


Send1Row:
    Charge:
	CPI R25, -1
	BREQ RESET
	RJMP ShiftRows
	RESET: LDI R25,7	 
ShiftRows:
    LDI R27, 16          ;													;111 HERE IS ONE ITERATION FOR THE 
    ShiftLoopOuter:
        CLC
        LDI R19, 5          ;												; 111     Here we PUT 5   IMPORTANT  HERE WE SELECT WHICH ROW WE CHOOSE THERE ARE 16 ROWS OF 5 BITS SO IT GIVES 80 BITS 
		AFFICHAGE:
		LDI ZL, low(CharTable<<1)    ; Load table pointer
		LDI ZH, high(CharTable<<1)
		LDI R20,0
		;CP R24,R20								; HERE WE CHECK IF THERE IS A CHANGE IN THE SCREEN IF SO WE GO AND CHANGE THE SCREEN ELSE WE SKIP
		;BREQ Skip								; HERE WE GO AN CHANGE THE SCREEN
		RJMP CheckScreenState
		Skip: RJMP characters
		CheckScreenState:
		; SELECTION OF THE RIGHT SCREEN TO DISPLAY 
		CPI R21, 1			;CHECK IF SCREEN STATE IS ONE SO I ORDER TO DISPLAY THE MENU R21
		BRNE Ecran2   
		SCREEN1	   
		RJMP characters
		Ecran2:
		CPI R21, 2			;CHECK IF SCREEN STATE IS ONE SO I ORDER TO DISPLAY THE MENU R21
		BRNE Ecran3  
		SCREEN2
		RJMP characters
		Ecran3:
		CPI R21,3
		BRNE Ecran4
		SCREEN3
		RJMP characters
		Ecran4:
		CPI R21,4
		BREQ ecran4ok
		RJMP Ecran5
		ecran4ok:
		SCREEN4
		RJMP characters
		Ecran5:
		CPI R21,5
		BRNE Ecran6
		SCREEN_GAMEOVER
		jmp characters
		Ecran6:
		CPI R21,6
		BREQ Ecran6ici
		jmp Ecran7
		Ecran6ici:
		SCREEN6
		jmp characters

		Ecran7:
		SCREEN7
		jmp characters

		;LOAD THE RIGH DATA PER BLOCK SCREEN
		characters:
		LOAD_CHARACTER
		ExecuteAffichage:														;111 AFFICHAGE 
		Load:
		LDI R26, 0
		LPM R26, Z            ; Load R17 from table								111	HERE WE LOAD THE LINE CORRESPONDING TO WHAT WE WANT IN THE MEMORY 		
		Add ZL, R25             ; Point to the second entry in the table
		LPM R26, Z            ; Load R17 from table
    ShiftLoopInner:
        CBI PORTB, 3          ; Initialize PB=0
        ROR R26                ; Rotate left through carry (ROL)
        BRCC CarryIs1         ; Skip next line if C=0 -> PB=0
        SBI PORTB, 3          ; If C=1 -> PB=1
    CarryIs1:
        CBI PORTB, 5
        SBI PORTB, 5            ; Create rising edge of PB5 to shift
        DEC R19
        BRNE ShiftLoopInner           ; ROL and shift 5 times						111 UP UNTIL HERE WE LOAD THE 5 BITS OF THE ROW IN THE SHIFT REGISTER (5 CAUSE IT LONG OF 5 BITS WITH THE ROWS) AND WE USE REGISTER 19 TO STORE 5 SO THAT WE LOAD BIT PER BIT 5 BITS OF THE CHARACTER
    DEC R27																			; 111 HERE FOR THE 16 TIMES WE DO THE LOOP
    BRNE ShiftLoopOuters            ; ROL and shift 8 times
	RJMP Shift
	ShiftLoopOuters : RJMP ShiftLoopOuter
    Shift:LDI R27,8          ; Need to shift 8 times
    CLC
    ShiftLoopLast:
        CBI PORTB, 3          ; Initialize PB=0
        ROR R10                ; Rotate left through carry (ROL)              ;222 THE ROW VALUE R16 WAS INITIALIZED BEFORE WE JUST DO IT ONCE
        BRCC CarryIs0         ; Skip next line if C=0 -> PB=0
        SBI PORTB, 3          ; If C=1 -> PB=1
    CarryIs0:
        CBI PORTB, 5
        SBI PORTB, 5            ; Create rising edge of PB5 to shift
        DEC R27
        BRNE ShiftLoopLast           ; ROL and shift 8 times
    SBI PINB, 4																	;222 HERE WE FINISHED SENDING WHICH LINE WE NEED
    ; Delay
    LDI R19, 0xFF														;333 HERE WE PUT A DELAY SO IT DOESN'T SWITCH TOO FAST
    Delay11:
        DEC R19
        BRNE Delay11      ; ROL and shift 8 times
    SBI PINB, 4
	DEC R25
    TST R10 ; Test RX for being non-zero
    BRNE Remain ; Send next row (7->6->5->4->3->2->1)   TST IF R16 IS 0 IF IF NOT 0 THEN NOT EQUAL SO BRNE IS CAST
	ROL R10
	MOV R23,R12
	CPI R23,0
	BREQ suiteici
	CPI R23,2
	BREQ gotomario
	CPI R23,4
	BREQ gogameover
	
	INC R12
	jmp Send1Row
	Remain:jmp main
/*	MOV R23,R12
	CPI R23,2
	BREQ gotomario2*/

/*	MOV R23,R12
	CPI R23,2
	BREQ gotomario3*/
	suiteici:

	CPI R21,1
	BREQ remain
	CPI R21,2
	BREQ gotofree
	CPI R21,3
    BREQ golevel1
	CPI R21,4
	BREQ gotomario
	CPI R21,5
	BREQ gogameover
	CPI R21,6
	BREQ goscore
	CPI R21,7
	BREQ gonouveauscore

	gotofree:jmp free_mode
	golevel1:jmp loadlevel1
	gotomario:jmp backmario
	gogameover: jmp backgameover
	goscore: jmp score
	gonouveauscore: jmp nouveauscoreasuite
/*	gotomario2:jmp backmario2*/
/*	gotomario3:jmp backmario3*/

free_mode:
keyboard:
	CHECK_KEYBOARD       ; XOR input states to determine key pressed
	MOV R16,R2

    ; Check for each key using defined constants
	CPI R16, KEY_7 ; Compare with key 7
	BREQ SW7 ; Branch if equal to key 7
	CPI R16, KEY_8 ; Compare with key 8
	BREQ SW8 ; Branch if equal to key 8
	CPI R16, KEY_9 ; Compare with key 9
	BREQ SW9 ; Branch if equal to key 9
	CPI R16, KEY_F ; Compare with key F
	BREQ SWF ; Branch if equal to key F
	CPI R16, KEY_4 ; Compare with key 4
	BREQ SW4 ; Branch if equal to key 4
	CPI R16, KEY_5 ; Compare with key 5
	BREQ SW5 ; Branch if equal to key 5
	CPI R16, KEY_6 ; Compare with key 6
	BREQ SW6 ; Branch if equal to key 6
	CPI R16, KEY_E ; Compare with key E
	BREQ SWE ; Branch if equal to key E
	CPI R16, KEY_1 ; Compare with key 1
	BREQ SW1 ; Branch if equal to key 1
	CPI R16, KEY_2 ; Compare with key 2
	BREQ SW2 ; Branch if equal to key 2
	CPI R16, KEY_3 ; Compare with key 3
	BREQ SW3 ; Branch if equal to key 3
	CPI R16, KEY_D ; Compare with key D
	BREQ SWD ; Branch if equal to key D
	CPI R16, KEY_A ; Compare with key A
	BREQ SWA ; Branch if equal to key A
	CPI R16, KEY_0 ; Compare with key 0
	BREQ SW0 ; Branch if equal to key 0
	CPI R16, KEY_B ; Compare with key B
	BREQ SWB ; Branch if equal to key B
	CPI R16, KEY_C ; Compare with key C
    BREQ SWC
	RJMP main
	SW7:
	SET
	LDI R18,C5
	RJMP keyboard
	SW8:
	SET
	LDI R18,Cs5
	RJMP keyboard
	SW9:
	SET
	LDI R18,D5
	RJMP keyboard
	SWF:
	SET
	LDI R18,Ds5
	RJMP keyboard
	SW4:
	SET
	LDI R18,E5
	RJMP keyboard
	SW5:
	SET
	LDI R18,F5
	RJMP keyboard
	SW6:
	SET
	LDI R18,Fs5
	RJMP keyboard
	SWE:
	SET
	LDI R18,G5
	RJMP keyboard
	SW1:
	SET
	LDI R18,Gs5
    RJMP keyboard
	SW2:
	SET
	LDI R18,A5
	RJMP keyboard
	SW3:
	SET
	LDI R18,As5
	RJMP keyboard
	SWD:
	SET
	LDI R18,B5
	RJMP keyboard
	SWA:
	SET
	LDI R18,C6
	RJMP keyboard
	SW0:
	SET
	LDI R18,Cs6
	RJMP keyboard
	SWB:
	SET
	LDI R18,D6
	RJMP keyboard
	SWC:
	SET
	LDI R18,E6
	RJMP keyboard



loadGameWin:
;READ THE SOUND OF THE WIN THEME
LDI ZL,low(GG<<1)
LDI ZH,high(GG<<1)

GoodGame:
CHECK_SWITCH
LPM R18,Z+
CPI R18,0
BREQ endw
SET
LPM R16,Z+
EOR R3,R3
EOR R4,R4
delay01: CP R4,R16
BREQ stop01
RJMP delay01
stop01: CLT
EOR R3,R3
EOR R4,R4
LDI R16,1
delay02: CP R16,R3
BRNE delay02
RJMP GoodGame
endw:
return:
;HIGH SCORE SCREEN
LDI R23, 0					;
STS EEARH, R23 
STS EEARL, R23 
LDI R23, (1<<EERE)
STS EECR,R23
LDS R23,EEDR
CP R23, R6
BRLO nouveauscore
jmp suiteeee

nouveauscore:

EOR R5,R5
LDI R21,7
avantnouveauscore:
LDI R23,0
MOV R12,R23
jmp Send1Row
nouveauscoreasuite:
LDI R23,2
CP R5,R23
Brlo avantnouveauscore
nouveauscoreaffiche:
LDI R21,6
LDI R23,0
MOV R12,R23
LDI R24,1
LDI R21,1
MOV R15,R24
EOR R12,R12

LDI R23, 0
STS EEARH, R23 
STS EEARL, R23 
MOV R23,R6
STS EEDR, R23
LDI R23, (0<<EEPM1)||(0<<EEPM0)||(1<<EEMPE)||(0<<EEPE)
STS EECR,R23
nop
nop
nop
nop
nop
LDI R23, (1<<EEPE)
STS EECR,R23

suiteeee:






EOR R5,R5
LDI R21,6
avantscore:
LDI R23,0
MOV R12,R23
jmp Send1Row
score:
LDI R23,5
CP R5,R23
brlO avantscore

LDI R24,1
LDI R21,1
MOV R15,R24
EOR R12,R12
RJMP main
loadGameWin1:jmp loadGameWin

;GAME MARIO
loadlevel1:
LDI ZL,low(Theme_Mario<<1)
LDI ZH,high(Theme_Mario<<1)
EOR R6,R6
EOR R5,R5
LDI R21,4
LDI R24,1
level1:
	CHECK_KEYBOARD
	LPM R1,Z ; THE KEY THAT HAS TO BE PRESSED
	LDI R16,0
	CP R1,R16 ; If it is zero, it's not a key, but a pause
	BREQ play2

	LDI R16,0xFF
	CP R1,R16
	BREQ loadGameWin1

	;SAVE  Z
	MOV R13,R30;;;;;;;;;;;
	MOV R14,R31;;;;;;;;;;;;;;;;

	//jmp affiche2
	Returnaffiche2:
	;LOAD  Z
	LDI R23,1
	MOV R12,R23
	jmp Send1Row
	backmario:;;;;;;;;;;;;;;;;
	MOV R30,R13
	MOV R31,R14;;;;;;;;

    CP R1, R2 ; Check for key that is pressed
    BREQ play
	LDI R16,0
	CP R2,R16
	BRNE loadGameOver; NOT RIGHT, GAME OVER
	LDI R16,3
	CP R5,R16
	BREQ loadGameOver ; MORE THAN 3 SECONDS, GAME OVER
	RJMP level1
	play:
	INC R6
	SET



	play2:
	LPM R16,Z+
	LPM R18,Z+
	LPM R16,Z+
	EOR R3,R3
	EOR R4,R4
	delay1: CP R4,R16
	BREQ stop1
	RJMP delay1
	stop1: CLT
	EOR R3,R3
	EOR R4,R4
	LDI R16,1
	delay2: CP R16,R3
	BREQ leveel1
	RJMP delay2
	leveel1: EOR R5,R5
	jmp level1
	endd: RJMP return

	loadGameOver:
	LDI r21,5
	LDI r24,1
	LDI ZL,low(Game_Over<<1)
	LDI ZH,high(Game_Over<<1)
	GameOver:
	CHECK_SWITCH
	LDI R23,3
	MOV R12,R23

	MOV R13,R30;;;;;;;;;;;
	MOV R14,R31;;;;;;;;;;;;;;;;
	jmp Send1Row
	backgameover: ;;;;;;;;;;;;;;;;
	MOV R30,R13
	MOV R31,R14;;;;;;;;

	LPM R18,Z+
	CPI R18,-1
	BREQ endd
	

	SET
	LPM R16,Z+
	EOR R3,R3
	EOR R4,R4
	delay0: CP R4,R16
	BREQ stop0
	RJMP delay0
	stop0: CLT
	EOR R3,R3
	EOR R4,R4
	LDI R16,1
	delay00: CP R16,R3
	BRNE delay00
	RJMP GameOver





	

	CharTable:
	.db 0b00100, 0b01010, 0b10001, 0b11111, 0b10001, 0b10001, 0b10001, 0b00000 ;A0
	.db 0b11110, 0b10001, 0b10001, 0b11110, 0b10001, 0b10001, 0b11110, 0b00000 ;B1
	.db 0b11111, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b11111, 0b00000;c2
	.db 0b11110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b11110, 0b00000;d3
	.db 0b11111, 0b10000, 0b10000, 0b11110, 0b10000, 0b10000, 0b11111, 0b00000;e4
	.db 0b11111, 0b10000, 0b10000, 0b11110, 0b10000, 0b10000, 0b10000, 0b00000;f5
	.db 0b11111, 0b10000, 0b10000, 0b10011, 0b10001, 0b10001, 0b11111, 0b00000;g6
	.db 0b10001, 0b10001, 0b10001, 0b11111, 0b10001, 0b10001, 0b10001, 0b00000;h7
	.db 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b11111, 0b00000;i8
	.db 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b11000, 0b00000;j9
	.db 0b10001, 0b10010, 0b10100, 0b11000, 0b10100, 0b10010, 0b10001, 0b00000;k10
	.db 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b11111, 0b00000;l11
	.db 0b10001, 0b11011, 0b10101, 0b10101, 0b10001, 0b10001, 0b10001, 0b00000;m12
	.db 0b10001, 0b11001, 0b10101, 0b10011, 0b10001, 0b10001, 0b10001, 0b00000;n13
	.db 0b01110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110, 0b00000;o14
	.db 0b11110, 0b10001, 0b10001, 0b11110, 0b10000, 0b10000, 0b10000, 0b00000;p15
	.db 0b01110, 0b10001, 0b10001, 0b10001, 0b10101, 0b10010, 0b01101, 0b00000;q16
	.db 0b11110, 0b10001, 0b10001, 0b11110, 0b10100, 0b10010, 0b10001, 0b00000;r17
	.db 0b01110, 0b10001, 0b10000, 0b01110, 0b00001, 0b10001, 0b01110, 0b00000;;s18
	.db 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000;t19
	.db 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110, 0b00000;u20
	.db 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01010, 0b00100, 0b00000;v21
	.db 0b10001, 0b10001, 0b10101, 0b10101, 0b10101, 0b10101, 0b01010, 0b00000;w22
	.db 0b10001, 0b10001, 0b01010, 0b00100, 0b01010, 0b10001, 0b10001, 0b00000;x23
	.db 0b10001, 0b10001, 0b01010, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000;y24
	.db 0b11111, 0b00001, 0b00010, 0b00100, 0b01000, 0b10000, 0b11111, 0b00000;z25
	.db 0b01110, 0b10001, 0b10011, 0b10101, 0b11001, 0b10001, 0b01110, 0b00000;0 26
	.db 0b00010, 0b00110, 0b00010, 0b00010, 0b00010, 0b00010, 0b00111, 0b00000;1 27
	.db 0b00110, 0b01001, 0b00001, 0b00010, 0b00100, 0b01000, 0b11111, 0b00000;2 28
	.db 0b11110, 0b00001, 0b00010, 0b00100, 0b00010, 0b00001, 0b11110, 0b00000;3 29
	.db 0b00010, 0b00110, 0b01010, 0b10010, 0b11111, 0b00010, 0b00010, 0b00000;4 30
	.db 0b11111, 0b10000, 0b11110, 0b00001, 0b00001, 0b10001, 0b01110, 0b00000;5  31
	.db 0b00010, 0b00100, 0b01000, 0b11100, 0b10010, 0b10001, 0b01110, 0b00000;6  32
	.db 0b11111, 0b00001, 0b00010, 0b00010, 0b00100, 0b00100, 0b00100, 0b00000;7  33
	.db 0b01110, 0b10001, 0b10001, 0b01110, 0b10001, 0b10001, 0b01110, 0b00000;8  34
	.db 0b01110, 0b10001, 0b10001, 0b01111, 0b00001, 0b00010, 0b01100, 0b00000;9  35
	.db 0000000, 0000000, 0000000, 0000000, 0000000, 0000000, 0000000, 0000000;36  NO CHACACTER
	.db 0b10000, 0b11000, 0b11100, 0b11110, 0b11100, 0b11000, 0b10000, 0b00000;37 ARROW 
	.db 0b00000, 0b01010, 0b11111, 0b01110, 0b11011, 0b10001, 0b01110, 0b00000; 38 TOAD

	Theme_Mario:
	.db KEY_7,E6,2, KEY_7,E6,2, 0,-1
	.db 2, KEY_7,E6,2, 0,-1,2, KEY_8
	.db C6,2,KEY_8,E6,4, KEY_9,G6,4
	.db 0,-1,4, KEY_5,G5,4,0,-1 ;theme1
	.db 4, KEY_6,C6,4, 0,-1,2, KEY_6
	.db G5,4,0,-1,2, KEY_C,E5,4
	.db 0,-1,2, KEY_A,A5,4, KEY_C,B5
	.db 4, KEY_C,As5,2, KEY_B,A5,4, KEY_B
	.db G5,3,KEY_1,E6,3, KEY_D,G6,2
	.db KEY_2,A6,4, KEY_4,F6,2, KEY_6,G6
	.db 2,0,-1,2,KEY_E,E6,4, KEY_E
	.db C6,2, KEY_7, D6,2,KEY_7,B5,4;repetition
	.db 0,-1,2,KEY_7,C6,4, 0,-1
	.db 2,KEY_7,G5,4,0,-1,2, KEY_7
	.db E5,4,0,-1,2, KEY_7,A5,4
	.db KEY_7,B5,4,KEY_7,As5,2,KEY_7,A5
	.db 4,KEY_7,G5,3,KEY_7,E6,3, KEY_7
	.db G6,2,KEY_7,A6,4, KEY_7,F6,2
	.db KEY_7,G6,2,0,-1,2,KEY_7,E6 
	.db 4,KEY_7,C6,2, KEY_7, D6,2,KEY_7
	.db B5,4,0,-1,6,KEY_7,G6,2 ; end
	.db KEY_7,Fs6,2,KEY_7,F6,2,KEY_7,Ds6;theme2
	.db 4,KEY_7,E6,2,0,-1,2,KEY_7
	.db Gs5,2,KEY_7,A5,2,KEY_7,C6,2
	.db 0,-1,2,KEY_7,A5,2,KEY_7,C6
	.db 2,KEY_7,D6,2,0,-1,4,KEY_7
	.db G6,2,KEY_7,Fs6,2,KEY_7,F6,2
	.db KEY_7,Ds6,4,KEY_7,E6,2,0,-1
	.db 2,KEY_7,C7,4,KEY_7,C7,2,KEY_7
	.db C7,4,0,-1,8,KEY_7,G6,2
	.db KEY_7,Fs6,2,KEY_7,F6,2,KEY_7,Ds6
	.db 4,KEY_7,E6,2,0,-1,2,KEY_7
	.db Gs5,2,KEY_7,A5,2,KEY_7,C6,2
	.db 0,-1,2,KEY_7,A5,2,KEY_7,C6
	.db 2,KEY_7,D6,2,0,-1,4,KEY_7
	.db Ds6,4,-0,-1,2,KEY_7,D6,4 ;repetition
	.db 0,-1,2,KEY_7,C6,4,0,-1
	.db 8,0,-1,8,KEY_7,G6,2,KEY_7
	.db Fs6,2,KEY_7,F6,2,KEY_7
	.db Ds6,4,KEY_7,E6,2,0,-1,2
	.db KEY_7,Gs5,2,KEY_7,A5,2,KEY_7,C6
	.db 2,0,-1,2,KEY_7,A5,2,KEY_7
	.db C6,2,KEY_7,D6,2,0,-1,4
	.db KEY_7,G6,2,KEY_7,Fs6,2,KEY_7,F6
	.db 2,KEY_7,Ds6,4,KEY_7,E6,2,0
	.db -1,2,KEY_7,C7,4,KEY_7,C7,2
	.db KEY_7,C7,4,0,-1,8,KEY_7,G6
	.db 2,KEY_7,Fs6,2,KEY_7,F6,2,KEY_7
	.db Ds6,4,KEY_7,E6,2,0,-1,2
	.db KEY_7,Gs5,2,KEY_7,A5,2,KEY_7,C6
	.db 2,0,-1,2,KEY_7,A5,2,KEY_7
	.db C6,2,KEY_7,D6,2,0,-1,4 
	.db KEY_7,Ds6,4,-0,-1,2,KEY_7,D6
	.db 4,0,-1,2,KEY_7,C6,4,0 ; end
	.db -1,4,0,-1,8,KEY_8,C6,2 ; theme 3 
	.db KEY_8,C6,2,0,-1,2,KEY_8,C6
	.db 2, 0,-1,2, KEY_8,C6,2, KEY_8
	.db D6,4,KEY_8,E6,2, KEY_8,C6,2
	.db 0,-1,2, KEY_8,A5,2,KEY_8,G5
	.db 8,KEY_8,C6,2,KEY_8,C6,2,0
	.db -1,2,KEY_8,C6,2,0,-1,2
	.db KEY_8,C6,2, KEY_8,D6,2,KEY_8,E6
	.db 2,0,-1,8,0,-1,8,KEY_8 ; end
	.db C6,2,KEY_8,C6,2,0,-1,2; theme 3 
	.db KEY_8,C6,2, 0,-1,2, KEY_8,C6
	.db 2, KEY_8,D6,4,KEY_8,E6,2,KEY_8
	.db C6,2,0,-1,2, KEY_8,A5,2
	.db KEY_8,G5,8,KEY_8,E6,2, KEY_8,E6
	.db 2, 0,-1,2, KEY_8,E6,2, 0
	.db -1,2, KEY_8,C6,2,KEY_8,E6,4
	.db KEY_8,G6,4, 0,-1,4, KEY_8,G5; end
	.db 4,0,-1,2,KEY_7,C6,4, 0 ; theme1
	.db -1,2, KEY_7,G5,4,0,-1,2
	.db KEY_7,E5,4,0,-1,2, KEY_7,A5
	.db 4,KEY_7,B5,4, KEY_7,As5,2, KEY_7
	.db A5,4, KEY_7,G5,3,KEY_7,E6,3
	.db KEY_7,G6,2,KEY_7,A6,4, KEY_7,F6
	.db 2,KEY_7,G6,2,0,-1,2,KEY_7
	.db E6,4, KEY_7,C6,2, KEY_7, D6,2;repetition
	.db KEY_7,B5,4,0,-1,2,KEY_7,C6
	.db 4,0,-1,2,KEY_7,G5,4,0
	.db -1,2, KEY_7,E5,4,0,-1,2
	.db KEY_7,A5,4,KEY_7,B5,4,KEY_7,As5
	.db 2,KEY_7,A5,4,KEY_7,G5,3,KEY_7
	.db E6,3, KEY_7,G6,2,KEY_7,A6,4
	.db KEY_7,F6,2,KEY_7,G6,2,0,-1
	.db 2,KEY_7,E6,4,KEY_7,C6,2, KEY_7
	.db D6,2,KEY_7,B5,4,0,-1,2 ;end 
	.db KEY_4,E6,2, KEY_4,C6,4, KEY_4,G5
	.db 2, 0,-1,4, KEY_4,Gs5,4, KEY_4
	.db A5,2, KEY_4,F6,4, KEY_4,F6,2
	.db KEY_4,A5,4, 0,-1,4,KEY_4,B5
	.db 3, KEY_4,A6,2,KEY_4,A6,3, KEY_4
	.db A6,3, KEY_4,G6,2, KEY_4,F6,3
	.db KEY_4,E6,2,KEY_4,C6,4,KEY_4,A5
	.db 2, KEY_4,G5,4, 0,-1,4,KEY_4
	.db E6,2, KEY_4,C6,4, KEY_4
	.db G5,2, 0,-1,4, KEY_4,Gs5,4
	.db KEY_4,A5,2, KEY_4,F6,4, KEY_4,F6
	.db 2,KEY_4,A5,4, 0,-1,4, KEY_4
	.db B5,2, KEY_4,F6,4, KEY_4,F6,2
	.db KEY_4,F6,3, KEY_4,E6,2, KEY_4,D6
	.db 3,KEY_4,G5,2, KEY_4,E5,4, KEY_4
	.db E5,2, KEY_4,C5,4, 0,-1,4 
	.db KEY_4,E6,2, KEY_4,C6,4, KEY_4,G5 ; repetition
	.db 2, 0,-1,4, KEY_4,Gs5,4, KEY_4
	.db A5,2, KEY_4,F6,4, KEY_4,F6,2
	.db KEY_4,A5,4, 0,-1,4,KEY_4,B5
	.db 3, KEY_4,A6,2,KEY_4,A6,3, KEY_4
	.db A6,3, KEY_4,G6,2, KEY_4,F6,3
	.db KEY_4,E6,2,KEY_4,C6,4,KEY_4,A5
	.db 2, KEY_4,G5,4, 0,-1,4,KEY_4
	.db E6,2, KEY_4,C6,4, KEY_4
	.db G5,2, 0,-1,4, KEY_4,Gs5,4
	.db KEY_4,A5,2, KEY_4,F6,4, KEY_4,F6
	.db 2,KEY_4,A5,4, 0,-1,4, KEY_4
	.db B5,2, KEY_4,F6,4, KEY_4,F6,2
	.db KEY_4,F6,3, KEY_4,E6,2, KEY_4,D6
	.db 3,KEY_4,G5,2, KEY_4,E5,4, KEY_4
	.db E5,2, KEY_4,C5,4, 0,-1,4 ;end
	.db KEY_C,C6,4, 0,-1,2, KEY_C,G5
	.db 4,0,-1,2, KEY_C,E5,4, KEY_C
	.db A5,3, KEY_C,B5,2, KEY_C,A5,3 ;*/
	.db KEY_C,GS5,3, KEY_C,AS5,2, KEY_C,GS5
	.db 3, KEY_C,E5,2, KEY_C,D5,2, KEY_C
	.db E5,9, 0,-1,1,0xFF,0xFF,0xFF

	GAME_OVER:
	.db Fs5,2,Fs5,2,G5,2,Fs5,1
	.db E5,1,D5,2,E5,2,D5,2
	.db C5,2,B4,2,D5,2,B4,2
	.db C5,2,A4,2,B4,2,G4,2
	.db A4,2,E5,4,E5,2,Fs5,4
	.db G5,4,Fs5,4,G5,4,Fs5,2
	.db E5,8,E5,4,E5,2,Fs5,4
	.db G5,4,Fs5,2,E5,9,-1,0

	GG:
	.db G5,8,-1,4,G5,1,A5,1
	.db B5,1,C6,1,D6,4,-1,4
	.db F6,3,E6,2,F6,3,G6,8
	.db F5,3,E5,2,F5,3,G5,8
	.db -1,8,0,0,0,0,0,0

SW_ISR:
	IN R11,SREG

    IN R0, PINB ; Read PINB into register R0 to check if the button is pressed

	
	;BRTC ChangeScreen
	SBRS R0,2
	rjmp ChangeScreen
	rjmp arret
	ChangeScreen:
	CPI R21,1
	BRNE resete 

	LDI R23,0b00000001
	AND R23,R22
	ADD R21,R23
	LDI R23,1
	ADD R21,R23
	LDI R23,0				;I changed R21
	LDI R24,1
	OUT SREG,R11
	jmp arret
	resete:
	LDI R24,1
	LDI R21,1
	LDI R23,0b00000001
	MOV R15,R23
	LDI R23,0
	MOV R12,R23

	LDI R16,1
	arret:
	RETI

Timer2_ISR:
	IN R11,SREG
	LDI R17, 100     ; constant timer of 10ms
    STS TCNT2, R17   ; Load the value into TCNT2
	LDI R17,10
	INC R3		
	CP R17,R3
	BREQ ms
	OUT SREG,R11
	RETI
	ms: EOR R3,R3 ;centiseconds
	INC R4
	CP R17,R4
	BREQ s
	OUT SREG,R11
	RETI
	s: EOR R4,R4 ;deci seconds
	LDI R17,60
	INC R5
	CP R17,R5
	BREQ minute
	OUT SREG,R11
	RETI
	minute: EOR R5,R5 ;seconds
	OUT SREG,R11
	RETI

Timer0_ISR:
    BRTS KeyPressed
    RETI
KeyPressed:
	OUT TCNT0,R18
    SBI PINB, 1  ; SBI PINB,1 is better than SBI PORTB,1 because it toggles
    RETI

 ADC_ISR:
 	IN R11,SREG

	LDS R9,ADCH
	;CBI PORTC, PC2
	;CPI R17,0



	end:
		OUT SREG,R11
 RETI