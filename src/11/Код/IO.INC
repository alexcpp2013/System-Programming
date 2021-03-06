;                     ������� 2.2
;      ��楤��� �����/�뢮�� ��饣� �����祭��
;       ��� ࠡ��� � 梥⭮� ⥪�⮢�� ०���
;
; ���� ⥪�� �ணࠬ�� �㫠��� �������� ������쥢��.
; ���� lst_2_02.inc, 10.03.2000.

DATASEG
; ���� � 䮭 �뢮������ ⥪�� (�� 㬮�砭�� ��⠭����
; �뢮� ������ ⥪�� �� �୮�� 䮭�)
TextColorAndBackground DB 0Fh
; ��砫쭠� ������ ��� �뢮�� ⥪�⮢�� ��ப� �� ��࠭
ScreenString DW ?
ScreenColumn DW ?
ENDS

CODESEG
;*******************************************************
;*    ����� ����� �� ����� � ����������������� ����    *
;* ����ணࠬ�� �뢮��� ᮤ�ন��� ॣ���� AL         *
;* � ��⭠����筮� ���� � �������� ������ ��࠭�. *
;* ���न���� ����樨 ��।����� �१ ��������      *
;* ��६���� ScreenString � ScreenColumn. ��᫥       *
;* �믮������ ����樨 �뢮�� �ந�室�� ��⮬��-     *
;* �᪮� ���饭�� ���祭�� ��� ��६�����.         *
;*******************************************************
PROC ShowByteHexCode near
        pusha
        push    DS
        push    ES
        ; ����ந�� DS �� �������� ᥣ���� ������
        mov     DI,DGROUP
        mov     DS,DI
        ; ����ந�� ��ப��� ������� ������ ��
        ; ��⮨��६���� ०�� (�������� "���।")
        cld

; ����ந�� ���� ES:DI ��� ��אַ�� �뢮�� � �����������
        push    AX
        ; ����㧨�� ���� ᥣ���� ����������� � ES
        mov     AX,0B800h
        mov     ES,AX
        ; �������� ����� ��ப� �� ����� ��ப� � �����
        mov     AX,[ScreenString]
        mov     DX,160
        mul     DX
        ; �ਡ����� � ����祭���� �ந�������� �����
        ; ������� (������)
        add     AX,[ScreenColumn]
        add     AX,[ScreenColumn]
        ; ��९���� १���� � ������� ॣ����
        mov     DI,AX
        pop     AX

; �ᯮ�짮���� 梥� ᨬ�����, ������� �� 㬮�砭��
        mov     AH,[TextColorAndBackground]
; �뢥�� ���訩 ࠧ�� �᫠ 
        push    AX
        ; �뤥���� ���訩 ࠧ��
        shr     AL,4
        ; �८�ࠧ����� ���訩 ࠧ�� � ��� ASCII
        add     AL,'0'
        cmp     AL,'9'
        jbe     @@M0
        add     AL,'A'-'9'- 1
        ; �뢥�� ࠧ�� �᫠ �� ��࠭
@@M0:   stosw
        pop     AX
; �뢥�� ����訩 ࠧ�� �᫠ 
        ; �뤥���� ����訩 ࠧ�� �᫠
        and     AL,0FH
        ; �८�ࠧ����� ����訩 ࠧ�� � ��� ASCII
        add     AL,'0'
        cmp     AL,'9'
        jbe     @@M1
        add     AL,'A'-'9'- 1
        ; �뢥�� ࠧ�� �᫠ �� ��࠭
@@M1:   stosw

; �����⮢�� ��� �뢮�� ᫥����� ���⮢
        ; ��ॢ��� ⥪���� ������ �� 2 ᨬ���� �����
        add     [ScreenColumn],2
        ; �஢���� ����祭�� �ࠢ�� �࠭��� ��࠭�
        cmp     [ScreenColumn],80
        jb      @@End
        ; �᫨ ���⨣��� �ࠢ�� �࠭�� ��࠭� -
        ; ��३� �� ᫥������ ��ப�
        sub     [ScreenColumn],80
        inc     [ScreenString]
@@End:  pop     ES
        pop     DS
        popa
        ret
ENDP ShowByteHexCode


;*****************************************************
;*         ����� 16-���������� ����� �� �����        *
;*              � ����������������� ����             *
;* ��ࠬ����:                                        *
;* AX - �᫮, ���஥ �㤥� �뢥���� �� ��࠭.      *
;* ����� ��ப� ��।����� �१ ���������          *
;* ��६����� ScreenString, ����� �⮫�� - �१    *
;* ��६����� ScreenColumn, 梥� ⥪�� ��।������ *
;* ������쭮� ��६���� TextColorAndBackground.      *
;*****************************************************
PROC ShowHexWord NEAR
        xchg    AL,AH
        call    ShowByteHexCode
        xchg    AL,AH
        call    ShowByteHexCode
        ret
ENDP ShowHexWord


;*****************************************************
;*         ����� 32-���������� ����� �� �����        *
;*              � ����������������� ����             *
;* ��ࠬ����:                                        *
;* EAX - �᫮, ���஥ �㤥� �뢥���� �� ��࠭.     *
;* ����� ��ப� ��।����� �१ ���������          *
;* ��६����� ScreenString, ����� �⮫�� - �१    *
;* ��६����� ScreenColumn, 梥� ⥪�� ��।������ *
;* ������쭮� ��६���� TextColorAndBackground.      *
;*****************************************************
PROC ShowHexDWord NEAR
        rol     EAX,8
        call    ShowByteHexCode
        rol     EAX,8
        call    ShowByteHexCode
        rol     EAX,8
        call    ShowByteHexCode
        rol     EAX,8
        call    ShowByteHexCode
        ret
ENDP ShowHexDWord


;**************************************************
;*      ����� ����� �� ����� � �������� ����      *
;* ����ணࠬ�� �뢮��� ᮤ�ন��� ॣ���� AL    *
;* � ����筮� ���� � 㪠������ ������ ��࠭�.    *
;* ���न���� ����樨 ��।����� �१ �������� *
;* ��६���� ScreenString � ScreenColumn. ��᫥  *
;* �믮������ ����樨 �뢮�� �ந�室�� ��⮬�-  *
;* ��᪮� ���饭�� ���祭�� ��� ��६�����.  *
;**************************************************
PROC ShowByteBinCode near
        pusha
        push    DS
        push    ES
        ; �����㥬 �⮡ࠦ���� ���� � BL
        mov     BL,AL
        mov     AX,DGROUP
        mov     DS,AX
        cld
        ; ����㧨�� ���� "⥪�⮢��" ���������� � ES
        mov     AX,0B800h
        mov     ES,AX
        ; �������� ����� ��ப� �� ����� ��ப� � �����
        mov     AX,[ScreenString]
        mov     DX,160
        mul     DX
        ; �ਡ����� ������ ����� �������
        add     AX,[ScreenColumn]
        add     AX,[ScreenColumn]
        ; ��९���� १���� � ������� ॣ����
        mov     DI,AX

; �⮡ࠧ��� ࠧ��� �᫠ (��稭�� � ���襣�)
        mov     AH,[TextColorAndBackground]
        mov     CX,8   ;���稪 ࠧ�冷�
@@L0:   mov     AL,'0'
        ; �뤥���� ��।��� ࠧ�� �᫠
        rol     BL,1
        jnc     @@L1
        mov     AL,'1'
        ; �뢥�� ࠧ�� �᫠ �� ��࠭
@@L1:   stosw
        loop    @@L0

; �����⮢�� ��� �뢮�� ᫥����� ���⮢
        ; ��ॢ��� ⥪���� ������ �� 8 ᨬ����� �����
        add     [ScreenColumn],8
        ; �஢���� ����祭�� �ࠢ�� �࠭��� ��࠭�
        cmp     [ScreenColumn],80
        jb      @@End
        ; �᫨ ���⨣��� �ࠢ�� �࠭�� ��࠭� - 
        ; ��३� �� ᫥������ ��ப�
        sub     [ScreenColumn],80
        inc     [ScreenString]
; ����� ����ணࠬ��
@@End:  pop     ES
        pop     DS
        popa
        ret
ENDP ShowByteBinCode


;******************************************************
;* ����� 16-���������� ����� �� ����� � �������� ���� *
;* ��ࠬ����:                                         *
;* AX - �᫮, ���஥ �㤥� �뢥���� �� ��࠭.       *
;* ����� ��ப� ��।����� �१ ���������           *
;* ��६����� ScreenString, ����� �⮫�� - �१     *
;* ��६����� ScreenColumn, 梥� ⥪�� ��।������  *
;* ������쭮� ��६���� TextColorAndBackground.       *
;******************************************************
PROC ShowBinWord NEAR
        rol     AX,8
        call    ShowByteBinCode
        inc     [ScreenColumn]
        rol     AX,8
        call    ShowByteBinCode
        ret
ENDP ShowBinWord

PROC ShowBinDWord NEAR
        rol     EAX,8
        call    ShowByteBinCode
        inc     [ScreenColumn]
        rol     EAX,8
        call    ShowByteBinCode
        inc     [ScreenColumn]
        rol     EAX,8
        call    ShowByteBinCode
        inc     [ScreenColumn]
ENDP ShowBinDWord

PROC ShowString near
        push    AX
        push    BX
        push    DI
        push    ES
; ����ࠨ�� ॣ���� ES �� �������� ᥣ���� ������
        mov     AX,DGROUP
        mov     ES,AX
; ���������� 梥� ⥪�� � BL
        mov     BL,[ES:TextColorAndBackground]
; ����ࠨ�� ॣ���� ES �� �����������
        mov     AX,0B800h
        mov     ES,AX    
        cld
; ���᫨�� ���� ��� ��ப� � ����������
        ; ����㧨�� ����� ��ப� ��࠭� � AL �
        ; 㬭����� ��� �� ����� ��ப� � �����
        lodsb
        ; �஢�ઠ: ����� ��ப� �� ������ �ॢ����
        ; �।�� ������ �࠭��� ��࠭�
        cmp     AL,24  
        ja      @@Error
        mov     AH,160
        mul     AH
        ; ��९���� १���� � ������� ॣ���� DI
        mov     DI,AX
        ; ����㧨�� ����� �⮫�� � ������
        ; �ਡ����� ��� � DI
        lodsb
        cmp     AL,79   ;����� ������� �� ������
        ja      @@Error ;�ॢ���� �ਭ� ��࠭�
        mov     BH,AL   ;��������� ����� �������
        xor     AH,AH   ;���㫨�� AH
        add     DI,AX
        add     DI,AX
        ; ����㧨�� ��ਡ�� 梥� � AH
        mov     AH,BL
@@L1:   ; ����㧨�� ��।��� ᨬ��� ��ப� � AL
        lodsb
        ; �஢�ઠ �� 0 (�� ����� ��ப�)
        and     AL,AL  
        jz      @@L2
        ; �஢���� ����� ������� ᨬ����
        cmp     BH,79
        ja      @@Error ;����襭� �ࠢ�� �࠭�� ��࠭�
        ; �뢥�� ᨬ��� �� ��࠭
        stosw
        inc     BH      ;㢥����� ����� �������
        jmp     @@L1
@@L2:   pop     ES
        pop     DI
        pop     BX
        pop     AX
        ret
@@Error: ;���������� ��室 � DOS �� �訡��
        mov     AH,4Ch
        int     21h
ENDP ShowString


;*****************************************************
;*  ����� ��������� ������ ��������� ����� �� �����  *
;* �� ��ࠬ���� ��।����� �१ ���� ��������:    *
;* ���� ���� - ��ਡ�� 梥� � 䮭� ��� ��ப�;    *
;* ��ன ���� - ����� ��砫쭮� ��ப�� (0-24);     *
;* ��⨩ ���� - ����� ��砫쭮� ������� (0-79);     *
;* ����� ���� ��ப�, ��࠭�祭��� �㫥�.            *
;* ���� �������� ��।����� �१ ॣ����� DS:SI.  *
;*****************************************************
PROC ShowColorString near
        push    AX
        ; ��������� 梥�, �ᯮ��㥬� �� 㬮�砭��
        mov     AL,[TextColorAndBackground]
        push    AX
        ; ��⠭����� 梥� ��ப�
        cld
        lodsb
        mov     [TextColorAndBackground],AL
        ; �ᯮ�짮���� �㭪�� ShowString
        call    ShowString
        ; ����⠭����� 梥�, �ᯮ��㥬� �� 㬮�砭��
        pop     AX
        mov     [TextColorAndBackground],AL
        pop     AX
        ret
ENDP ShowColorString


;********************************
;*  ���������� ������� �������  *
;* �室�� ��ࠬ����:           *
;* ScreenString - ����� ��ப�  *
;* ScreenColumn - ����� �⮫�� *
;********************************
PROC SetCursorPosition NEAR
        pusha
; ���᫥��� ��������� ���� �����
        mov     AX,[ScreenString]
        mov     BX,80
        mul     BX
        add     AX,[ScreenColumn]
        mov     BL,AL ;��������� ����訩 ����
; ��אַ� �뢮� ����樨 �����
; � ॣ����� ���������஫���
        mov     DX,3D4h
        ; �뢥�� ���訩 ���� ���� �����
        mov     AL,0Eh
        out     DX,AX  
        ; �뢥�� ����訩 ���� ���� �����
        inc     AL
        mov     AH,BL
        out     DX,AX  
        popa
        ret
ENDP SetCursorPosition


;*********************************************
;*       ������� ������ �� ����������        *
;* ��楤�� �����⢫�� ���� ᨬ���� �     *
;* ������� �㭪樨 00h ���뢠��� Int16h.    *
;* ��� "⥪�⮢��" �ࠢ����� ������ ����� *
;* ᪠�-����� �ᯮ������� ASCII-����.       *
;* �室��� ��ࠬ��஢ ���.                   *
;* �㭪�� �����頥�:                       *
;* AL - ��� ᨬ����;                         *
;* AH - �ࠢ���騩 ���, �᫨ � AL ����.     *
;*********************************************
PROC GetChar NEAR
        mov     AX,0
        int     16h
        and     AL,AL
        jnz     @@Get1
        ret     ;(� AL - ����, � AH - �ࠢ���騩 ���)
@@Get1: cmp     AL,32
        jnb     @@Get2
        ; ��९���� � AH �ࠢ���騩 ���
        xchg    AL,AH 
        mov     AL,0
        ret     ;(� AL - ����, � AH - �ࠢ���騩 ���)
@@Get2: mov     AH,0
        ret     ;(� AL - ��� �㪢�, � AH - ����)
ENDP GetChar


;************************************************
;*        ������� ������ �� ����������,         *
;*            ���� �� ���� � ������             *
;* ��楤�� �஢���� ����稥 ᨬ���� � ���� *
;* ���������� � ���뢠�� ���, �᫨ �� ����.    *
;* �室��� ��ࠬ��஢ ���.                      *
;* �㭪�� �����頥�:                          *
;* AL - ��� ᨬ����;                            *
;* AH - �ࠢ���騩 ���, �᫨ � AL ����.        *
;* �᫨ � AL � AH �㫨 - ����⨩ �� �뫮.       *
;************************************************
PROC WaitChar NEAR
; �஢���� ����稥 ᨬ���� � ���� ����������
        mov     AH,1
        int     16h
        jz      @@NoInput
; �ਭ��� ᨬ��� �� ����������
        mov     AX,0
        int     16h
        and     AL,AL
        jnz     @@GET1
        ret     ;� AL - ����, � AH - �ࠢ���騩 ���
@@GET1: cmp     AL,32
        jnb     @@GET2
        mov     AH,AL ;��९���� � AH �ࠢ���騩 ���
        mov     AL,0
        ret     ;� AL - ����, � AH - �ࠢ���騩 ���
@@GET2: mov     AH,0
        ret     ;� AL - ��� �㪢�, � AH - ����
@@NoInput:
        xor     AX,AX
        ret     ;� AL � AH - �㫨
ENDP WaitChar


;*************************************
;* ������� ������ � ��������� ������ *
;*  (��楤�� ��ࠬ��஢ �� �����)  *
;*************************************
PROC ClearScreen NEAR
        pusha
        push    ES
; ����ந�� ES:DI �� "⥪�⮢��" ������� ����������
        mov     AX,0B800h 
        mov     ES,AX     
        cld
        mov     DI,0
; �뢥�� 2000 "������" ᨬ����� (ASCII-��� 0) �
; ��ਡ�⮬ "���� 梥�, ��� 䮭"
        mov     CX,2000
        mov     AX,0F00H
        rep     stosw
        pop     ES
        popa
        ret
ENDP ClearScreen


;*****************************************************
;* ������ ��������� ������� ����� ���������� ������� *
;*          (��楤�� ��ࠬ��஢ �� �����)          *
;*****************************************************
PROC Beep NEAR
        push    AX
        push    DX
; ��᫠�� �� �ନ��� ��� "������" (07h)
        mov     AH,2
        mov     DL,7
        int     21h
        pop     DX
        pop     AX
        ret
ENDP Beep
ENDS
