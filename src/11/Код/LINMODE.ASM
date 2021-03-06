; ������⠭�� �i�i���� �����i� ��� �i���ࠦ����
; �� ��࠭i ��i��� ����⨢��� �����i
;
; ��� - ����� �i�i���� �����i�
;
IDEAL
P386
LOCALS
MODEL MEDIUM

INCLUDE "KEYS.INC" 	; ������i�i ���� ����i�
INCLUDE "COLORS.INC"	; ������i�i ���� �����i�
INCLUDE "SWITCH.INC"    ; �i��ணࠬ� ��ॢ��� ᥣ���⮣� ॣi��� GS � ���
INCLUDE "IO.INC"	; �i��ணࠬ� �����/������ ����� �� ��࠭

SEGMENT sseg para stack 'STACK'  
DB 400h DUP(?)
ENDS

DATASEG
; ����⮢i ���i��������
Txt1 DB LIGHTMAGENTA,0,28,"���� ����⨢��� ���'��",0
     DB YELLOW,2,0,"����",0
     DB LIGHTGREEN,2,11
     DB "�i᭠�����i筥 �।�⠢�����:",0
     DB LIGHTCYAN,2,61,"ASCII-����:",0
     DB LIGHTRED,21,0,"����i�� �᫮ "
     DB "��� ����i��� ������� ����i��:",0
Txt2 DB 23,0, "���i��� ���� - ����㯭i 256 ����;",0
     DB 23,35, "���i��� ������ - ����।�i 256 ����;",0
     DB 24,0, "Enter - �����襭�� ����� ����;",0
     DB 24,33, "Esc - �i��i�� ����� ����;",0
     DB 24,60, "F10 - ���i�",0

; �i��i��� �������� ᨬ���i� �᫠
CharacterCounter DB 0

; �����i� ��� �������� ���� �� ��࠭i
OutAddress DB 21,47

; �冷� ��� ����� ����
AddressString DB 9 DUP(0)

; �冷� �஬i��i� ��� "���࠭��" �᫠
SpaceString DB 21,47,9 DUP(' '),0

; ���⪮�� ����
StartAddress DD 0

; ��� �������
CommandByte DB 0
ENDS


CODESEG
;******************************************************
;*         ���I� ����� �� ����� � ���I ASCII          *
;* �i��ணࠬ� �������� ��i�� ॣi��� AL � ���i      *
;* ASCII � �����祭� �����i� ��࠭�.                  *
;* ���न��� �����i� ��।������ �१ �������i     *
;* ��i��i ScreenString i ScreenColumn.                *
;******************************************************
PROC ShowASCIIChar near
        pusha
        push    DS
        push    ES
        mov     DI,DGROUP
        mov     DS,DI
        cld

; ������� ��� ES:DI ��� ��אַ�� ������ � �i������'���
        push    AX
        
; �����⠦�� ����� ᥣ���� �i�������� � ES
        mov     AX,0B800h
        mov     ES,AX

; �������� ����� �浪� �� ������� �浪� � �����
        mov     AX,[ScreenString]
        mov     DX,160
        mul     DX

        add     AX,[ScreenColumn]
        add     AX,[ScreenColumn]
        mov     DI,AX
        pop     AX
        mov     AH,[TextColorAndBackground]
        stosw

; �i���⮢�� ��� ������ ����㯭�� ����i�
        ; ��ॢ��� ����� �����i� �� 2 ᨬ���� ��i��
        inc     [ScreenColumn]
        
; ��ॢi�� ���⨭���� �ࠢ�� �࠭��i ��࠭�
        cmp     [ScreenColumn],80
        jb      @@End

        ; ��� ����� �ࠢ� �࠭��� ��࠭� - 
        ; ��३� �� ����㯭�� �冷�
        sub     [ScreenColumn],80
        inc     [ScreenString]
@@End:  pop     ES
        pop     DS
        popa
        ret
ENDP ShowASCIIChar


;*********************************************************
;* �������� ����� I� ������������������ ���� � ��I������ *
;* DS:SI - �᫮ � ���i ASCII.                           *
;* ������� ����������� � EAX.                         *
;*********************************************************
PROC HexToBin32 near
        push    EBX
        push    CX
        push    SI
        cld
        xor     EBX,EBX ;������ �������㢠�
        xor     CX,CX   ;������ �i稫쭨� ���
@@h0:   lodsb
        
; ��ॢiઠ �� ��� (������ �i��� �浪�)
        and     AL,AL
        jz      @@h4
        
; ��ॢiઠ �� �i������ '0'-'9'
        cmp     AL,'0'  
        jb      @@Error
        cmp     AL,'9'  
        ja      @@h1
        sub     AL,'0'
        jmp short @@h3
@@h1:   ; ��ॢiઠ �� �i������ 'A'-''
        cmp     AL,'A'  
        jb      @@Error
        cmp     AL,'F'  
        ja      @@h2
        sub     AL,'A'-10
        jmp short @@h3
@@h2:   ; ��ॢiઠ �� �i������ 'a'-'f'
        cmp     AL,'a'  
        jb      @@Error
        cmp     AL,'f'  
        ja      @@Error
        sub     AL,'a'-10
@@h3:   ; ������ �� १�����
        ; �࣮�i 4 ஧�廊 �ࠢ����
        shl     EBX,4
        or      BL,AL
        inc     CX
        cmp     CX,8
        jbe     @@h0
        ; ��� � ��i �i��� 8 ��� - �������
        jmp short @@Error
@@h4:   ; ��i譥 �����襭�� - १���� � EAX
        mov     EAX,EBX
        jmp short @@End
@@Error:; ������� - ���㫨� १����
        xor     EAX,EAX 
@@End:  pop     SI
        pop     CX
        pop     EBX
        ret
ENDP HexToBin32


;************************************************
;* �������� � ����I����� ���� ������ �� ������� *
;************************************************
PROC GetAddressOrCommand near
        pushad
        mov     [TextColorAndBackground],WHITE
        mov     [ScreenString],21
@@GetAddressOrCommand:
; I�i�i��i�㢠� ��i��i
        ; ���㫨� �i稫쭨� ���
        mov     [CharacterCounter],0
        ; ����� �冷�
        mov     DI,offset AddressString
        mov     [byte ptr DS:DI],0   
        ; ����� �����i� �������� (����� �஬i�����)
        mov     SI,offset SpaceString
        call    ShowString
        ; ��⠭���� ����� � �����i� ��������
        mov     [ScreenColumn],47
        mov     AL,[CharacterCounter]
        add     [byte ptr ScreenColumn],AL
        call    SetCursorPosition
        ; ����� ���� � �������
        call    GetChar
        cmp     AL,0
        jz      @@Command

; �������� ������ � ������������������ ���I
@@Address:
        ; ��ॢiઠ �� �i������ '0'-'9'
        cmp     AL,'0'  
        jb      @@AddressError
        cmp     AL,'9'  
        jbe     @@WriteChar
        ; ��ॢiઠ �� �i������ 'A'-''
        cmp     AL,'A'  
        jb      @@AddressError
        cmp     AL,'F'  
        jbe     @@WriteChar
        ; ��ॢiઠ �� �i������ 'a'-'f'
        cmp     AL,'a'  
        jb      @@AddressError
        cmp     AL,'f'  
        ja      @@AddressError
@@WriteChar:
        ; ��ॢi��� �i��i��� ���
        cmp     [CharacterCounter],8
        jae     @@AddressError
        inc     [CharacterCounter]
        ; ������� ���� � �᫮
        mov     [DS:DI],AL
        inc     DI
        ; ������� ������ �i��� �浪�
        ; � ����㯭�� ஧��
        mov     [byte ptr DS:DI],0
        ; �i���ࠧ�� �᫮ �� ��࠭i
        mov     SI,offset SpaceString
        call    ShowString
        mov     SI,offset OutAddress
        call    ShowString
@@GetNextChar:
        ; �i���ࠧ�� ����� � ���i� �����i� ��������
        mov     [ScreenColumn],47
        mov     AL,[CharacterCounter]
        add     [byte ptr ScreenColumn],AL
        call    SetCursorPosition
        ; ��i�㢠� �������� ����㯭��� ᨬ����
        call    GetChar
        cmp     AL,0
        jne     @@Address

; �஠���i�㢠� ��� ������� ����i�i
        cmp     AH,B_Esc       ;᪠�㢠��� �������� ����
        je      @@GetAddressOrCommand

@@TestF10:
        cmp     AH,F10         ;"���i�"
        jne     @@TestRubout
        mov     [CommandByte],AH
        jmp     @@End

@@TestRubout:
        cmp     AH,B_RUBOUT    ;"���i�"
        jne     @@TestEnter
        cmp     [CharacterCounter],0
        je      @@AddressError
        ; ������� ������ �i��� �浪�
        ; �� ஧�� �i��
        dec     DI
        dec     [CharacterCounter]
        mov     [byte ptr DS:DI],0
        ; �i���ࠧ�� �᫮ �� ��࠭i
        mov     SI,offset SpaceString
        call    ShowString
        mov     SI,offset OutAddress
        call    ShowString
        jmp     @@GetNextChar

@@TestEnter:
        cmp     AH,B_Enter     ;�����襭�� �������� �᫠
        jne     @@AddressError
        mov     [CommandByte],AH
        mov     SI,offset AddressString
        call    HexToBin32
        mov     [StartAddress],EAX
        jmp short @@End

@@AddressError:
        call    Beep
        jmp     @@GetNextChar

; ������� "������"
@@Command:
        cmp     AH,F10         ;"���i�"
        jne     @@TestDn
        mov     [CommandByte],AH
        jmp short @@End

@@TestDn:
        cmp     AH,B_DN        ;"���i��� ����"
        jne     @@TestUp
        mov     [CommandByte],AH
        add     [StartAddress],256
        jmp short @@End

@@TestUp:
        cmp     AH,B_UP        ;"���i��� ������"
        jne     @@CommandError
        mov     [CommandByte],AH
        sub     [StartAddress],256
        jmp short @@End

@@CommandError:
        call    Beep
        jmp     @@GetAddressOrCommand
@@End:  popad
        ret
ENDP	GetAddressOrCommand

;*******************************
;* ���⮢� ��楤�� �ணࠬ� *
;*******************************
PROC MemoryDump
        mov     AX,DGROUP
        mov     DS,AX

; ��⠭����� ०�� ��אַ� �����i� �����i
        call    Initialization

; ����⮢�� ०��
        mov     AX,3
        int     10h

; �客�� ����� 
        mov     [ScreenString],25
        mov     [ScreenColumn],0
        call    SetCursorPosition

        mov     CX,5
        mov     SI,offset Txt1

@@NextString1:
        call    ShowColorString
        loop    @@NextString1
        mov     [TextColorAndBackground],WHITE
        mov     CX,5
        mov     SI,offset Txt2

@@NextString2:
        call    ShowString
        loop    @@NextString2

        mov     [TextColorAndBackground],WHITE

; �i���ࠧ�� ᨬ����-�i�쭨�� �������
        mov     AL,0B3h
        mov     [ScreenString],2
        mov     [ScreenColumn],9
        call    ShowASCIIChar
        mov     [ScreenColumn],59
        call    ShowASCIIChar
        mov     [ScreenString],3
        mov     [ScreenColumn],9
        call    ShowASCIIChar
        mov     [ScreenColumn],59
        call    ShowASCIIChar

; I�i�i��i��� ��i��i
        mov     [StartAddress],0
        mov     [CommandByte],0

; ����I��I� ����
@@q0:   mov     EBX,[StartAddress]
        mov     [ScreenString],4
        mov     DX,16
@@q1:   mov     [ScreenColumn],0

; �i���ࠧ�� �i�i��� ����� ���讣� ���� � ���i
        mov     [TextColorAndBackground],YELLOW
        mov     EAX,EBX
        call    ShowHexDWord

; �i���ࠧ�� ᨬ���-஧�i�쭨� �⮢�稪i�
        mov     [TextColorAndBackground],WHITE
        inc     [ScreenColumn]
        mov     AL,0B3h
        call    ShowASCIIChar
        inc     [ScreenColumn]

; �i���ࠧ�� �࣮�� ���� ����
; � ��⭠����筮� ���i
        mov     CX,16
        mov     [TextColorAndBackground],LIGHTGREEN
@@q2:   mov     AL,[GS:EBX]
        call    ShowByteHexCode
        inc     [ScreenColumn]
        inc     EBX
        loop    @@q2

; �i���ࠧ�� ᨬ���-஧�i�쭨� �⮢�稪i�
        mov     [TextColorAndBackground],WHITE
        mov     AL,0B3h
        call    ShowASCIIChar
        inc     [ScreenColumn]

        ; ��������� ����� �� 16 ᨬ���i�
        sub     EBX,16

; �i���ࠧ�� �࣮�� ���� ���� � ����� ASCII
        mov     CX,16
        mov     [TextColorAndBackground],LIGHTCYAN
@@q3:   mov     AL,[GS:EBX]
        call    ShowASCIIChar
        inc     EBX
        loop    @@q3
        inc     [ScreenString]
        dec     DX
        jnz     @@q1

        ; ��i�㢠� ���᪠��� ���-类� ����i�i
        call    GetAddressOrCommand
        cmp     [CommandByte],F10
        jne     @@q0

@@End:  ; ��⠭���� ⥪�⮢�� ०��
	mov     ax,3
	int     10h
; ���i� � DOS
	mov     AH,4Ch
	int     21h
ENDP	MemoryDump
END	MemoryDump
ENDS