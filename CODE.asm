PORTA EQU 00H
PORTB EQU 02H
PORTC EQU 04H
CONTROL_REG EQU 06H

;---------------------
;The default password
;---------------------
MOV [0004H],'1'      ;
MOV [0005H],'1'      ;
MOV [0006H],'1'      ;
MOV [0007H],'1'      ;
;---------------------                   
;DI ---> refer to row of keypad.
;SI ---> refer to number of digit in password.
;BX ---> refer to number of trys.
;DX ---> refer to flag of validity of password.
;-------------------------
;Configration mode of PPI
;-------------------------
MOV AL,88H  
OUT CONTROL_REG,AL 
;------------------------------
;Initialization of LCD 
;------------------------------
MOV AL,30H 
OUT PORTA,AL

CALL ENABLEOFCOMMAND

CALL DELAY
;-----------------------
MOV AL,30H 
OUT PORTA,AL

CALL ENABLEOFCOMMAND

CALL DELAY 
;-----------------------
MOV AL,30H 
OUT PORTA,AL 

CALL ENABLEOFCOMMAND

CALL DELAY 
;---------------------------------------
;To oprate LCD in 8-BIT and 2-LINE mode
;---------------------------------------
MOV AL,38H  
OUT PORTA,AL

CALL ENABLEOFCOMMAND 
;-------------------------
;To turn on cursor of LCD
;-------------------------   
MOV AL,0EH
OUT PORTA,AL 

CALL ENABLEOFCOMMAND
;-------------------------------
;To print "* PASSWORD *" on LCD.
;-------------------------------
;STR0 DB 'PASSWORD'
CALL PRINTPASSWORD 
;----------------------------------------------
;To set cursor in second line and seventh place.
;----------------------------------------------    
MOV AL,0C6H 
OUT PORTA,AL
CALL ENABLEOFCOMMAND 
;---------------------------------------------------------------------------
;The keypad
;---------------------------------------------------------------------------
MOV BX,03H
MOV DX,00H
MOV SI,00H
RESTART:



ROW0:
MOV DI,04H
MOV AL,11111110B
  
ROW1:
OUT PORTC,AL 
CALL CHECK
ROL AL,1
DEC DI 
JNZ ROW1

JMP ROW0

ERROR:
CALL ERRORPROC
INF:
JMP INF
;---------------------------------------------------------------------------
CHECK PROC NEAR
    PUSH AX
      
    IN AL,PORTC
    AND AL,11110000B
    
    CMP AL,01110000B
    JZ C0 
    CMP AL,10110000B
    JZ C1 
    CMP AL,11010000B
    JZ C2 
    CMP AL,11100000B
    JZ C3
    E:
    POP AX 
    RET
    ;----------------
    ;COLUME 0
    C0:
    ;ROW 0
    CMP DI,04H
    JZ C0R0
    ;ROW 1
    CMP DI,03H
    JZ C0R1
    ;ROW 2
    CMP DI,02H
    JZ C0R2
    ;ROW 3
    CMP DI,01H
    JZ C0R3
    JMP E
    ;----------------
    ;COLUME 1
    C1:
    ;ROW 0
    CMP DI,4 
    JZ C1R0
    ;ROW 1
    CMP DI,3
    JZ C1R1
    ;ROW 2
    CMP DI,2
    JZ C1R2
    ;ROW 3
    CMP DI,1
    JZ C1R3
    JMP E
    ;---------------- 
    ;COLUME 2
    C2:
    ;ROW 0
    CMP DI,4 
    JZ C2R0
    ;ROW 1
    CMP DI,3
    JZ C2R1
    ;ROW 2
    CMP DI,2
    JZ C2R2
    ;ROW 3
    CMP DI,1
    JZ C2R3
    JMP E
    ;---------------- 
    ;COLUME 3
    C3:
    ;ROW 0
    CMP DI,4 
    JZ C3R0
    ;ROW 1
    CMP DI,3
    JZ C3R1
    ;ROW 2
    CMP DI,2
    JZ C3R2
    ;ROW 3
    CMP DI,1
    JZ C3R3
    JMP E
    ;---------------- 
    ;Seven
    ;----------------
    C0R0:
    CMP SI,4
    JGE E
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR

    MOV AL,'7'
    CALL SAVEPASSWORD
    
    CALL HALT
    JMP E
    ;----------------
    ;Four
    ;----------------
    C0R1:
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR

    MOV AL,'4'
    CALL SAVEPASSWORD
    
    CALL HALT
    JMP E
    ;----------------
    ;One
    ;----------------
    C0R2:
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'1'
    CALL SAVEPASSWORD
    
    CALL HALT
    JMP E
    ;----------------
    ;Appear
    ;----------------
    C0R3:
    CMP DX,01H
    JZ E
    
    HALTOFAPPEAR:
    CMP SI,00H
    JZ NOAPPEAR1
    
    MOV AL,0C6H 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND
    
    CMP SI,01H
    JNZ APPEARTWO1
    MOV AL,[00000H]
    CALL PRINTCHAR
    JMP NOAPPEAR1
      
    APPEARTWO1:
    CMP SI,02H
    JNZ APPEARTHREE1
    MOV AL,[00000H]
    CALL PRINTCHAR
    MOV AL,[00001H]
    CALL PRINTCHAR
    JMP NOAPPEAR1
     
    APPEARTHREE1:
    CMP SI,03H
    JNZ APPEARFOUT1
    MOV AL,[00000H]
    CALL PRINTCHAR
    MOV AL,[00001H]
    CALL PRINTCHAR
    MOV AL,[00002H]
    CALL PRINTCHAR
    JMP NOAPPEAR1
    
    APPEARFOUT1:
    MOV AL,[00000H]
    CALL PRINTCHAR
    MOV AL,[00001H]
    CALL PRINTCHAR
    MOV AL,[00002H]
    CALL PRINTCHAR
    MOV AL,[00003H]
    CALL PRINTCHAR

    NOAPPEAR1:
    
    
    IN AL,PORTC 
    AND AL,11110000B
    CMP AL,11110000B
    JNZ HALTOFAPPEAR
    
    CMP SI,00H
    JZ NOAPPEAR2
    
    MOV AL,0C6H 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND
    
    CMP SI,01H
    JNZ APPEARTWO2
    MOV AL,'*'
    CALL PRINTCHAR
    JMP NOAPPEAR2
      
    APPEARTWO2:
    CMP SI,02H
    JNZ APPEARTHREE2
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR
    JMP NOAPPEAR2
     
    APPEARTHREE2:
    CMP SI,03H
    JNZ APPEARFOUT2
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR
    JMP NOAPPEAR2
    
    APPEARFOUT2:
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR
    MOV AL,'*'
    CALL PRINTCHAR  
    
    NOAPPEAR2:
    JMP E
    ;---------------- 
    ;Eight
    ;----------------
    C1R0:
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'8'
    CALL SAVEPASSWORD
    
    CALL HALT
    JMP E
    ;----------------
    ;Five
    ;----------------
    C1R1:
    CMP SI,4
    JGE E
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'5'
    CALL SAVEPASSWORD 

    CALL HALT
    JMP E
    ;----------------
    ;Two
    ;----------------
    C1R2:
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'2'
    CALL SAVEPASSWORD

    CALL HALT
    JMP E
    ;----------------
    ;Zero
    ;----------------
    C1R3: 
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'0'
    CALL SAVEPASSWORD 

    CALL HALT
    JMP E
    ;----------------
    ;Nine
    ;----------------
    C2R0: 
    CMP SI,4
    JGE E
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'9'
    CALL SAVEPASSWORD 

    CALL HALT 
    JMP E
    ;---------------- 
    ;Six
    ;----------------
    C2R1:
    CMP SI,4
    JGE E 
    
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'6'
    CALL SAVEPASSWORD 

    CALL HALT
    JMP E
    ;----------------
    ;Three
    ;----------------
    C2R2:
    CMP SI,4
    JGE E
     
    INC SI
    MOV AL,'*'
    CALL PRINTCHAR
    
    MOV AL,'3'
    CALL SAVEPASSWORD 

    CALL HALT
    JMP E
    ;----------------
    C2R3:
    
    CALL HALT
    JMP E
    ;----------------
    ;Confirm
    ;----------------
    C3R0: 
    CMP SI,4
    JNZ E
    
    CMP DX,11H
    JZ RSCONFIRM
    CMP DX,00H
    JNZ E
    
    MOV AL,[0000H]
    CMP AL,[00004]
    JNZ WRONG
    MOV AL,[0001H]
    CMP AL,[0005H]
    JNZ WRONG
    MOV AL,[0002H]
    CMP AL,[0006H]
    JNZ WRONG
    MOV AL,[0003H]
    CMP AL,[0007H]
    JNZ WRONG
    JMP CORRECT
    WRONG:
    
    DEC BX 
    JZ ERROR
    
    CALL PRINTWRONGPASSWORD
    MOV AL,0C6H 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND

    MOV SI,00H
    JMP RESTART

    CORRECT:
    MOV DX,01H         
    CALL PRINTTRUEPASSWORD
    MOV AL,10000000B
    OUT PORTB,AL
    
    JMP ENDCONFIRM
      
    RSCONFIRM:
    MOV AL,[0000H]
    MOV [0004H],AL
    MOV AL,[0001H]
    MOV [0005H],AL
    MOV AL,[0002H]
    MOV [0006H],AL
    MOV AL,[0003H]
    MOV [0007H],AL
    CALL PRINTDONE
    MOV DX,01H
    
    ENDCONFIRM:
    CALL HALT
    JMP E
    ;----------------
    ;Exit
    ;----------------
    C3R1:
    TEST DX,00000001H
    JZ E
    
    MOV SI,00H
    MOV DX,00H
    MOV BX,03H 
    CALL PRINTPASSWORD
    MOV AL,0C6H 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND 
    JMP RESTART 
     
    CALL HALT
    JMP E
    ;----------------
    ;Delete
    ;----------------
    C3R2:
    CMP DX,01H
    JZ E
    
    CMP SI,00
    JZ NOOPERATION  
    MOV AH,00H
    DEC SI
    MOV AL,0C6H 
    ADD AX,SI 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND
    MOV AL,' '
    CALL PRINTCHAR
    MOV AL,0C6H 
    ADD AX,SI 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND
    NOOPERATION:   
    CALL HALT
    JMP E
    ;----------------
    ;Reset
    ;----------------
    C3R3:
    CMP DX,01H
    JNZ E
    
    MOV DX,11H
    MOV SI,00H 
    CALL PRINTNEWPASSWORD 
    
    MOV AL,0C6H 
    OUT PORTA,AL
    CALL ENABLEOFCOMMAND 
    
    JMP RESTART
    CALL HALT
    JMP E  

CHECK ENDP
;---------------------------  


;---------------------------
;Procedure to make a delay.
;---------------------------
DELAY PROC NEAR
    PUSH CX
    
    MOV CX,0FFH
    D:LOOP D

    POP CX
    RET
DELAY ENDP
;---------------------------
;---------------------------
;Procedure to halt up.
;---------------------------
HALT PROC NEAR
    PUSH AX
    
    H:
    IN AL,PORTC 
    AND AL,11110000B
    CMP AL,11110000B
    JNZ H
    
    POP AX
    RET
HALT ENDP
;---------------------------
;---------------------------
;Procedure to print a char.
;---------------------------
PRINTCHAR PROC NEAR
    
    OUT PORTA,AL 
    
    CALL ENABLEOFDATA
    
    RET
PRINTCHAR ENDP
;---------------------------
;---------------------------
;Procedure to make 
;data enable signal for LCD
;---------------------------
ENABLEOFDATA PROC NEAR
    PUSH AX  
    
    ;IN AL,PORTB
    ;OR AL,00000011B 
    MOV AL,00000011B
    OUT PORTB,AL
    
    CALL DELAY
    
    ;IN AL,PORTB
    ;OR AL,00000001B
    ;AND AL,11111101B
    MOV AL,00000001B
    OUT PORTB,AL 
    
    CALL DELAY
    
    POP AX
    RET
ENABLEOFDATA ENDP
;--------------------------- 
;---------------------------
;Procedure to make 
;command enable signal 
;for LCD.
;---------------------------
ENABLEOFCOMMAND PROC NEAR
    PUSH AX  
    
    ;IN AL,PORTB
    ;AND AL,11111110B
    ;OR AL,00000010B
    MOV AL,00000010B
    OUT PORTB,AL
    
    CALL DELAY
    
    ;IN AL,PORTB
    ;AND AL,11111100B
    MOV AL,00000000B
    OUT PORTB,AL 
    
    CALL DELAY
    
    POP AX
    RET
ENABLEOFCOMMAND ENDP
;---------------------------
;---------------------------
;Procedure to save password 
;in sequence memory location.
;---------------------------
SAVEPASSWORD PROC NEAR
    
    CMP SI,01
    JNZ NOTONE
    MOV [0000H],AL
    NOTONE:
    CMP SI,02
    JNZ NOTTWO
    MOV [0001H],AL
    NOTTWO:
    CMP SI,03
    JNZ NOTTHREE
    MOV [0002H],AL
    NOTTHREE:
    CMP SI,04
    JNZ NOTFOUR
    MOV [0003H],AL
    NOTFOUR:
   
    RET
SAVEPASSWORD ENDP
;---------------------------  
;---------------------------
;Procedure to clear LCD.
;---------------------------
CLEARLCD PROC NEAR
   PUSH AX
   
   MOV AL,01H
   OUT PORTA,AL    
   CALL ENABLEOFCOMMAND
    
   POP AX
   RET     
CLEARLCD ENDP
;--------------------------- 
;---------------------------
;Procedure to print 
; 'PASSWORD' on LCD.
;---------------------------
PRINTPASSWORD PROC NEAR
   PUSH AX
   
   CALL CLEARLCD
    
   MOV AL,82H
   OUT PORTA,AL  
   CALL ENABLEOFCOMMAND
   
   MOV AL,'*'
   CALL PRINTCHAR
   MOV AL,' '
   CALL PRINTCHAR                                         
   MOV AL,'P'
   CALL PRINTCHAR
   MOV AL,'a'
   CALL PRINTCHAR
   MOV AL,'s'
   CALL PRINTCHAR
   MOV AL,'s'
   CALL PRINTCHAR
   MOV AL,'w'
   CALL PRINTCHAR
   MOV AL,'o'
   CALL PRINTCHAR
   MOV AL,'r'
   CALL PRINTCHAR
   MOV AL,'d'
   CALL PRINTCHAR
   MOV AL,' '
   CALL PRINTCHAR
   MOV AL,'*'
   CALL PRINTCHAR
    
   POP AX
   RET     
PRINTPASSWORD ENDP 
;--------------------------- 
;---------------------------
;Procedure to print 
; 'WRONG PASSWORD' on LCD.
;---------------------------
PRINTWRONGPASSWORD PROC NEAR
    PUSH AX
    
    CALL CLEARLCD

    MOV AL,83H
    OUT PORTA,AL  
    CALL ENABLEOFCOMMAND
     
                                                           

    MOV AL,'W'
    CALL PRINTCHAR                                         
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'o'
    CALL PRINTCHAR
    MOV AL,'n'
    CALL PRINTCHAR
    MOV AL,'g'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR                                         
    MOV AL,':'
    CALL PRINTCHAR
    MOV AL,'('
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR
    MOV AL,'('
    CALL PRINTCHAR
    MOV AX,BX
    ADD AX,30H
    CALL PRINTCHAR
    MOV AL,')'
    CALL PRINTCHAR

    
    POP AX
    RET     
PRINTWRONGPASSWORD ENDP 
;---------------------------
;---------------------------
;Procedure to print 
; 'TRUE PASSWORD' on LCD.
;---------------------------
PRINTTRUEPASSWORD PROC NEAR
    PUSH AX  
    
    CALL CLEARLCD
    
    MOV AL,84H
    OUT PORTA,AL 
    CALL ENABLEOFCOMMAND

    MOV AL,'C'
    CALL PRINTCHAR                                         
    MOV AL,'o'
    CALL PRINTCHAR
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'e'
    CALL PRINTCHAR                                        
    MOV AL,'c'
    CALL PRINTCHAR
    MOV AL,'t'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR
    MOV AL,':'
    CALL PRINTCHAR
    MOV AL,')'
    CALL PRINTCHAR 
    
    POP AX
    RET     
PRINTTRUEPASSWORD ENDP 
;--------------------------- 
;---------------------------
;Procedure to print 
; 'DONE' on LCD.
;---------------------------
PRINTDONE PROC NEAR
    PUSH AX  
    
    CALL CLEARLCD
    
    MOV AL,85H
    OUT PORTA,AL 
    CALL ENABLEOFCOMMAND

    MOV AL,'D'
    CALL PRINTCHAR                                         
    MOV AL,'o'
    CALL PRINTCHAR
    MOV AL,'n'
    CALL PRINTCHAR
    MOV AL,'e'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR
    MOV AL,001
    CALL PRINTCHAR                                        
    MOV AL,':'
    CALL PRINTCHAR
    MOV AL,')'
    CALL PRINTCHAR 
    
    POP AX
    RET     
PRINTDONE ENDP 
;---------------------------
;---------------------------
;Procedure to print 
; 'PRINTNEWPASSWORD' on LCD.
;---------------------------
PRINTNEWPASSWORD PROC NEAR
    PUSH AX  
    
    CALL CLEARLCD
    
    MOV AL,83H
    OUT PORTA,AL 
    CALL ENABLEOFCOMMAND

    MOV AL,'N'
    CALL PRINTCHAR                                         
    MOV AL,'e'
    CALL PRINTCHAR
    MOV AL,'w'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR                                        
    MOV AL,'P'
    CALL PRINTCHAR
    MOV AL,'a'
    CALL PRINTCHAR
    MOV AL,'s'
    CALL PRINTCHAR
    MOV AL,'s'
    CALL PRINTCHAR
    MOV AL,'w'
    CALL PRINTCHAR
    MOV AL,'o'
    CALL PRINTCHAR
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'d'
    CALL PRINTCHAR 
    
    POP AX
    RET     
PRINTNEWPASSWORD ENDP 
;---------------------------   
;---------------------------
;Procedure to crash program
;---------------------------
ERRORPROC PROC NEAR
    PUSH AX  
    
    CALL CLEARLCD
    
    MOV AL,82H
    OUT PORTA,AL 
    CALL ENABLEOFCOMMAND

    MOV AL,'M'
    CALL PRINTCHAR                                         
    MOV AL,'o'
    CALL PRINTCHAR
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'e'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR                                        
    MOV AL,'3'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR
    MOV AL,'t'
    CALL PRINTCHAR
    MOV AL,'r'
    CALL PRINTCHAR
    MOV AL,'y'
    CALL PRINTCHAR
    MOV AL,' '
    CALL PRINTCHAR 
    MOV AL,':'
    CALL PRINTCHAR
    MOV AL,'('
    CALL PRINTCHAR 
    
    
    POP AX
    RET     
ERRORPROC ENDP  