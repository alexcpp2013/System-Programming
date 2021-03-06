;                     ������� 3.1
;         ����ணࠬ��, ��⠭��������� ०��
;              �������� ����樨 ������
;
; ���� ⥪�� �ணࠬ�� �㫠��� �������� ������쥢��.
; ���� lst_3_01.inc, 08.03.2000

; ����, �ࠢ���騩 ����⮬ ����᪨�㥬�� ���뢠���
CMOS_ADDR      equ  0070h
CMOS_DATA      equ  0071h
; �������� ᥣ���⮢
SYS_PROT_CS    equ  0008h
SYS_REAL_SEG   equ  0010h
SYS_MONDO_SEG  equ  0018h

CODESEG
;**********************************************
;* ��������� ������ �������� ��������� ������ *
;*       (��楤�� ��ࠬ��஢ �� �����)      *
;**********************************************
PROC Initialization NEAR
        pushad
; ���࠭��� ���祭�� ᥣ������ ॣ���஢ �
; ॠ�쭮� ०��� (�஬� GS)
        mov     [CS:Save_SP],SP
        mov     AX,SS
        mov     [CS:Save_SS],AX
        mov     AX,DS
        mov     [CS:Save_DS],AX
; (ࠡ�⠥� ⥯��� ⮫쪮 � ������ ᥣ���⮬)
        mov     AX,CS
        mov     [word ptr CS:Self_Mod_CS],AX
        mov     DS,AX
        cli
        mov     SS,AX
        mov     SP,offset Local_Stk_Top
        sti

; ��⠭����� ०�� �������� ����樨
        call    SetLAddrModeForGS

; ����⠭����� ���祭�� ᥣ������ ॣ���஢
        cli
        mov     SP,[CS:Save_SP]
        mov     AX,[CS:Save_SS]
        mov     SS,AX
        mov     AX,[CS:Save_DS]
        mov     DS,AX
        sti
; ������� ࠡ��� ����� A20
        call    Enable_A20
        popad
        ret
ENDP Initialization


; ������� ��࠭���� ���祭�� ᥣ������ ॣ���஢
Save_SP DW ?
Save_SS DW ?
Save_DS DW ?
; �����⥫� �� GDT
GDTPtr  DQ ?
; ������ ���ਯ�஢ ᥣ���⮢ ���
; �室� � ���饭�� ०��
GDT DW 00000h,00000h,00000h,00000h ;�� �ᯮ������
    DW 0FFFFh,00000h,09A00h,00000h ;ᥣ���� ���� CS
    DW 0FFFFh,00000h,09200h,00000h ;ᥣ���� ������ DS
    DW 0FFFFh,00000h,09200h,0008Fh ;ᥣ���� GS
; ������� �⥪ ��� ���饭���� ०���
; (�࣠������� ����� �������� ᥣ����)
label GDTEnd word
        DB 255 DUP(0FFh)
Local_Stk_Top DB (0FFh)


;*********************************************
;*        �������� ������ �������� GS        *
;* ��楤�� ������� ᮤ�ন��� ⥭�����    *
;* ॣ���� GS ⠪�� ��ࠧ��, �� �⠭������ *
;* ��������� �������� ������ �१ ����   *
;* 4 Gb ����� � ॠ�쭮� ०���             *
;*********************************************
PROC SetLAddrModeForGS near
; ���᫨�� ������� ���� �������� ᥣ����
        mov     AX,CS
        movzx   EAX,AX
        shl     EAX,4   ;㬭����� ����� ��ࠣ�� �� 16
        mov     EBX,EAX ;��࠭��� ������� ���� � EBX
; ������ ����襥 ᫮�� ��������� ���� � ���ਯ���
; ᥣ���⮢ ���� � ������
        mov     [word ptr CS:GDT+10],AX
        mov     [word ptr CS:GDT+18],AX
        ; ����⠢��� ���⠬� ���襥 � ����襥 ᫮��
        ror     EAX,16
; ������ ���� 16-23 ��������� ���� � ���ਯ���
; ᥣ���⮢ ���� � ������
        mov     [byte ptr CS:GDT+12],AL
        mov     [byte ptr CS:GDT+20],AL
; ��⠭����� �।�� (Limit) � ���� (Base) ��� GDTR
        add     bx, offset GDT
        mov [word ptr CS:GDTPtr],(offset GDTEnd-GDT-1)
        mov     [dword ptr CS:GDTPtr+2],EBX
; ���࠭��� ॣ���� 䫠���
        pushf
; ������� ���뢠���, ⠪ ��� ⠡��� ���뢠��� IDT
; �� ��ନ஢��� ��� ���饭���� ०���
        cli
; ������� ����᪨�㥬� ���뢠��� NMI
        in      AL,CMOS_ADDR
        mov     AH,AL
        or      AL,080h      ;��⠭����� ���訩 ࠧ��
        out     CMOS_ADDR,AL ;�� ���ࠣ���� ��⠫��
        and     AH,080h
        ; ��������� ��஥ ���ﭨ� ��᪨ NMI
        mov     CH,AH
; ��३� � ���饭�� ०��
        lgdt    [fword ptr CS:GDTPtr]
        mov     BX,CS    ;��������� ᥣ���� ����
        mov     EAX,CR0
        or      AL,01b   ;��⠭����� ��� PE
        mov     CR0,EAX  ;���� ࠧ�襭�
        ; ����᫮��� ���쭨� ���室 �� ���� SetPMode
        ; (������ ��।� ������ � ��१���㧨�� CS)
                DB      0EAh
                DW      (offset SetPMode)
                DW      SYS_PROT_CS
SetPMode:
        ; �����⮢��� �࠭��� ᥣ���⮢
        mov     AX,SYS_REAL_SEG
        mov     SS,AX
        mov     DS,AX
        mov     ES,AX
        mov     FS,AX
        ; ����� ��࠭�祭�� � ᥣ���� GS
        mov     AX,SYS_MONDO_SEG
        mov     GS,AX
; �������� � ॠ��� ०��
        mov     EAX,CR0
        and     AL,11111110b ;����� ��� PE
        mov     CR0,EAX      ;���� �⪫�祭�

        ; ����᫮��� ���쭨� ���室 �� ���� SetRMode
        ; (������ ��।� ������ � ��१���㧨�� CS)
            DB 0EAh
            DW (offset SetRMode)
Self_Mod_CS DW ?

SetRMode:
        ; �������� �⥪� � ������
        ; ����ந�� �� ᥣ���� ����
        mov     SS,BX
        mov     DS,BX
        ; ���㫨�� �������⥫�� ᥣ�����
        ; ॣ����� ������ (GS �� �ண���!)
        xor     AX,AX
        mov     ES,AX
        mov     FS,AX
        ; ������ � ॠ��� ०��,
        ; ���뢠��� ᭮�� ࠧ�襭�
        in      AL,CMOS_ADDR
        and     AL,07Fh
        or      AL,CH
        out     CMOS_ADDR,AL
        popf
        ret
ENDP SetLAddrModeForGS


;****************************************
;* ������� ࠡ��� � ������� ��� 1 �� *
;****************************************
PROC Enable_A20 near
        call    Wait8042BufferEmpty
        mov     AL,0D1h ;������� �ࠢ����� ����� A20
        out     64h,AL
        call    Wait8042BufferEmpty
        mov     AL,0DFh ;ࠧ���� ࠡ��� �����
        out     60h,AL
        call    Wait8042BufferEmpty
        ret
ENDP Enable_A20


;***********************************************
;*   �������� ������� �������� ������ I8042    *
;* �� ��室� �� ��楤���:                    *
;* 䫠� ZF ��⠭����� - ��ଠ�쭮� �����襭��, *
;* 䫠� ZF ��襭 - �訡�� ⠩�-���.         *
;***********************************************
proc Wait8042BufferEmpty near
        push    CX
        mov     CX,0FFFFh  ;������ �᫮ 横���
@@kb:   in      AL,64h     ;������� �����
        test    AL,10b     ;���� i8042 ᢮�����?
        loopnz  @@kb       ;�᫨ ���, � 横�
        pop     CX
        ; (�᫨ �� ��室� ��襭 䫠� ZF - �訡��)
        ret
endp Wait8042BufferEmpty
ENDS
