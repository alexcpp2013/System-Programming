      IDEAL
      P386
      MODEL MEDIUM
      
      ; �?������ 䠩� ������?筨� �����祭� �����?�
      INCLUDE "lst2.inc"
      INCLUDE "lst5.inc"
      
      SEGMENT sseg para stack 'STACK'
      DB 400h DUP(?)
      ENDS
      
      DATASEG
      ; ��ࠬ��� ������ PCI
      VendorID       DW ? ; ?�����?���� ��஡����
      DeviceID       DW ? ; ?�����?���� ������
      ClassCode      DD ? ; ⨯ ������
      BaseAddress0   DD ? ; ������ ���� 0
      BaseAddress1   DD ? ; ������ ���� 1
      BaseAddress2   DD ? ; ������ ���� 2
      BaseAddress3   DD ? ; ������ ���� 3
      BaseAddress4   DD ? ; ������ ���� 4
      BaseAddress5   DD ? ; ������ ���� 5
      InterruptLine  DB ? ; ����� ���ਢ���� ?RQ, � ������⮢������
      ; ���न��� ������ PC?
      BusNumber      DB ? ;����� 設�
      DeviceNumber   DB ? ; ����� ������ ? ����� �㭪�?�
      ; �?稫쭨� �����?� ���᪠���/�?���᪠��� ����?�
      PressCounter DW ?
      ; ����⮢? ���?��������
      PCI DB 0,25,"����㢠��� �㭪�i� PCI BIOS",0
          DB 4,20,"��ࠬ��� ������� ����஫�� ����� ���",0
          DB 6,0,"����� 設�:",0
          DB 7,0,"����� ������:",0
          DB 8,0,"����� �㭪�i�:",0
          DB 9,0,"I�����?���� ��஡����:",0
          DB 10,0,"I�����i���� ������:",0
          DB 11,0,"��� ������:",0
          DB 12,0,"������ ���� 0:",0
          DB 13,0,"������ ���� 1:",0
          DB 14,0,"������ ���� 2:",0
          DB 15,0,"������ ���� 3:",0
          DB 16,0,"������ ���� 4:",0
          DB 17,0,"������ ���� 5:",0
          DB 18,0,"����� ���ਢ����, � ������⮢������:",0
          DB 24,29,"����i�� ���-�� ����i��",0
      ; ���?�������� �� �, � ���ਢ���� �� ������⮢������
      NoIRQ DB 18,32,"�� ������⮢������",0
      ; ���?�������� �� �������
      NotPCI DB LIGHTRED,12,18
             DB "���⥬� �� �i��ਬ�� i���䥩� PCI BIOS",0
      NotSVGA DB LIGHTRED,12,22
              DB "����஫�� ����� ��� �� ��������",0
      BadRegister DB LIGHTRED,12,22
                  DB "���i୨� ����� ॣi���",0
      Exit DB LIGHTRED,24,17
           DB "��� ��室� � �ணࠬ� ����i�� ���-�� ����i��",0
      ENDS
      
      CODESEG
      ;*****************************
      ;* �᭮���� ����� �ணࠬ�  *
      ;*****************************
      PROC PCITest  near
              mov     AX,DGROUP
              mov     DS,AX
      ; ��⠭���� ⥪�⮢�� ०�� ? ����� ��࠭
              mov     AX,3
              int     10h
      ; �客�� ����� - ����� �� ����� �࠭��� ��࠭�
              mov     [ScreenString],25
              mov     [ScreenColumn],0
              call    SetCursorPosition
      ; ��⠭���� ������� ���?� ᨬ���?� ? �୨� 䮭
              mov     [TextColorAndBackground],LIGHTGREEN
      ; ������ ⥪�⮢? ���?�������� �� ��࠭
              mov     CX,16
              mov     SI,offset PCI
      @@NextString:
              call    ShowString
              loop    @@NextString
      ; ��⠭���� ���⨩ ���?� ᨬ���?� ? �୨� 䮭
              mov     [TextColorAndBackground],YELLOW
      
      ; ����㢠��� PCI-���ன��
      ; ��ॢ?�� ��?��� PC? B?OS
              mov     AX,0B101h
              int     1Ah
              jc      @@PCIBIOSNotFound
              cmp     EDX,20494350h
              jne     @@PCIBIOSNotFound
      ;����� ����஫�� ����� ���
      ; (�����?� ⨯� 090000h)
              mov     AX,0B103h
              mov     ECX,060000h
              mov     SI,0
              int     1Ah
              jc      @@DeviceNotFound
              mov     [BusNumber],BH
              mov     [DeviceNumber],BL
      
      ; ���ঠ� ?�����?���� ��஡����
              mov     AX,0B109h ; ��� ᫮��
              mov     DI,0      ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [VendorID],CX
      ; ���ঠ� ?�����?���� ������
              mov     AX,0B109h ; ��� ᫮��
              mov     DI,2      ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [DeviceID],CX
      ; ���ঠ� ⨯ ������ (ᠬ���ॢ?ઠ)
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,8      ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              shr     ECX,8
              mov     [ClassCode],ECX
      ; ���ঠ� ������ ����� 0
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,10h    ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress0],ECX
      ; ���ঠ� ������ ����� 1
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,14h    ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress1],ECX
      ; ���ঠ� ������ ����� 2
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,18h    ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress2],ECX
      ; ���ঠ� ������ ����� 3
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,1Ch    ; ��� ᫮��
              int     1Ah

              jc      @@BadRegisterNumber
              mov     [BaseAddress3],ECX
      ; ���ঠ� ������ ����� 4
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,20h    ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress4],ECX
      ; ���ঠ� ������ ����� 5
              mov     AX,0B10Ah ; ��� ����?��� ᫮��
              mov     DI,24h    ; ��� ᫮��
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress5],ECX
      
      ; ���ঠ� ����� ���ਢ���� IRQ,
      ; � ������⮢������ ������
              mov     AX,0B108h ; ��� ����
              mov     DI,3Ch    ; ��� ����
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [InterruptLine],CL
      
      ; ������ ��ਬ��? ���? �� ��࠭ �
      ; �?�⭠�����?筮�� ���?
              ; �?���ࠧ�� �᭮��? ��ࠬ��� ������
              mov     [ScreenString],6
              mov     [ScreenColumn],12
              mov     AL,[BusNumber]
              call    ShowByteHexCode
      
              inc     [ScreenString]
              mov     [ScreenColumn],18
              mov     AL,[DeviceNumber]
              shr     AL,3
              call    ShowByteHexCode
      
              inc     [ScreenString]
              mov     [ScreenColumn],15
              mov     AL,[DeviceNumber]
              and     AL,111b
              call    ShowByteHexCode
      
              inc     [ScreenString]
              mov     [ScreenColumn],28
              mov     AX,[VendorID]
              call    ShowHexWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],26
              mov     AX,[DeviceID]
              call    ShowHexWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],16
              mov     EAX,[ClassCode]
              call    ShowHexDWord
      
              ; �?���ࠧ�� �����? ����
              inc     [ScreenString]
              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress0]
              call    ShowHexDWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress1]
              call    ShowHexDWord
      
              inc     [ScreenString]

              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress2]
              call    ShowHexDWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress3]
              call    ShowHexDWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress4]
              call    ShowHexDWord
      
              inc     [ScreenString]
              mov     [ScreenColumn],17
              mov     EAX,[BaseAddress5]
              call    ShowHexDWord
      
              ; ������ ����� ���ਢ���� ?RQ, � ������⮢������
              inc     [ScreenString]
              mov     [ScreenColumn],40
              mov     AL,[InterruptLine]
              cmp     AL,0FFh      ; ���ਢ���� ������⮢������?
              je      @@IRQNotUsed
              call    ShowByteHexCode
              jmp short @@End
      @@IRQNotUsed:
              mov     SI,offset NoIRQ
              call    ShowString
              jmp short @@End
      
      ; ��஡�� �������
      @@BadRegisterNumber:
              ; ���?୨� ����� ॣ?���
              mov     SI,offset BadRegister
              jmp     @@ErrorMessage
      @@DeviceNotFound:
              ; �� ��������� ����஫�� ����� ���
              mov     SI,offset NotSVGA
              jmp     @@ErrorMessage
      @@PCIBIOSNotFound:
              ; �� �?��ਬ������ PC? B?OS
              mov     SI,offset NotPCI
      @@ErrorMessage:
              ; ����� ���?�������� �� ⨯ �������
              call    ClearScreen
              call    ShowColorString
              mov     SI,offset Exit
              call    ShowColorString
      
      ; ���?�祭�� ஡��
      @@End:  ; ��?�㢠� ���᪠��� ���-类� ����?�?
              call    GetChar
      ; �����⠭���� ⥪�⮢�� ०�� ? ����� ��࠭
              mov     AX,3
              int     10h
      ; ���?� � DOS
              mov     AH,4Ch
              int     21h
      ENDP PCITest 
      END  PCITest
      ENDS

