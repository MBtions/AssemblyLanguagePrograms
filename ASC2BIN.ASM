; ASCII to Binary conversion

.MODEL SMALL
.STACK 100H

.DATA
inputmsg DB "ENTER ANY ASCII CHARACTER : $"
outputmsg DB 0AH, 0DH, "BINARY EQUIVALENT IS : $"

.CODE

START:
        MOV AX, @DATA
        MOV DS, AX
        MOV DX, OFFSET inputmsg
        MOV AH, 09H                                ; write string to stdout interrupt (display string interrupt)
        INT 21H

        MOV AH, 01H                                ; read character from stdin
        INT 21H                         
        MOV BL, AL                                    ; Moving the character to data register
        MOV DL, BL
        
        MOV AH, 09H                                ; interrupt to display string to stdout
        MOV DX, OFFSET outputmsg      ; string value stored
        INT 21H                                           ; interrupt handled

        MOV CX, 8                                      ; counter of 8 for loop to display 8-bits

        BIN_CONV:
                SHL BL, 1                                 ; shift to left by 1 place
                JC PRINTONE                          ; jump if carry
                
                PRINTZERO:
                        MOV DL, 30H                 ; Moving binary 0 to data
                        JMP PRINT                      ; Print 0 
	PRINTONE:
                        	MOV DL, 31H        ; Moving binary 1 to data
                PRINT:
                        MOV AH, 02H               ; Print character interrupt
                        INT 21H
        LOOP BIN_CONV

MOV AH,4CH                                       ; Exit interrupt
INT 21H
END START
