; Binary to ASCII conversion

.MODEL SMALL
.STACK

.DATA
ARRAY DB 8 DUP(?)
N1 DB 00H
N2 DB 00H

inputmsg DB 0DH, 0AH, "ENTER ANY BINARY NUMBER : $"
outputmsg DB 0DH, 0AH, "ASCII CHARACTER IS : $"

.CODE
START:
        MOV AX,@DATA
        MOV DS,AX
        MOV AH,09H
        MOV DX,OFFSET inputmsg            ; input message string to display on the stdout
        INT 21H

        MOV CX, 8                                        ; Counter of 8 for binary number with 8-bits
        MOV SI, 0                                         ; initial index 0

        READ:                                                ; reading the binary number and storing it in an array
                MOV AH, 01H                          ; read character from stdout interrupt
                INT 21H
                SUB AL, 30H                             ; as 30H has ASCII character 0 therefore subtracting 30H
                MOV ARRAY[SI], AL                 ; at current index storing the binary digit
                INC SI                                         ; moving to next index
                LOOP READ

        MOV N1, 1                                        ; initially 2^0 = 1
        MOV CX, 8                                        ; updating counter with 8 for another loop
        MOV BL, 2
        MOV DL, 0
        MOV SI, 7                                          ; rightmost bit index

        ASCII_CHAR:
                MOV AL, ARRAY[SI]                 ; copies binary in AL
                MUL N1                                     ; multiply AL with N1 {2^0, 2^1, 2^2, ... , 2^7}
                ADD DL, AL                               ; Add into data
                MOV AL, N1                             ; Moving N1 into AL
                MUL BL                                     ; AL gets multiplied with 2
                MOV N1, AL                             ; updating N1
                DEC SI                                       ; moving to next index
                LOOP ASCII_CHAR

        MOV N2, DL                                    ; storing ASCII char in N2 temporarily
        MOV AX, @DATA
        MOV DS, AX
        MOV AH, 09H                                 ; display string interrupt
        MOV DX, OFFSET outputmsg       ; move string stored in outputmsg
        INT 21H 
        MOV DL, N2
        MOV AH, 02H                                 ; write character to stdout (display character interrupt)
        INT 21H

        MOV AH, 4CH                                 ; Exit interrupt
        INT 21H
        END START
