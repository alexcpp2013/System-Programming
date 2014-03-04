      IDEAL
      P386
      MODEL MEDIUM
      
      ; П?дключити файл мнемон?чних позначень кольор?в
      INCLUDE "lst2.inc"
      INCLUDE "lst5.inc"
      
      SEGMENT sseg para stack 'STACK'
      DB 400h DUP(?)
      ENDS
      
      DATASEG
      ; Параметри пристрою PCI
      VendorID       DW ? ; ?дентиф?катор виробника
      DeviceID       DW ? ; ?дентиф?катор пристрою
      ClassCode      DD ? ; тип пристрою
      BaseAddress0   DD ? ; базова адреса 0
      BaseAddress1   DD ? ; базова адреса 1
      BaseAddress2   DD ? ; базова адреса 2
      BaseAddress3   DD ? ; базова адреса 3
      BaseAddress4   DD ? ; базова адреса 4
      BaseAddress5   DD ? ; базова адреса 5
      InterruptLine  DB ? ; номер переривання ?RQ, що використовується
      ; Координати пристрою PC?
      BusNumber      DB ? ;номер шини
      DeviceNumber   DB ? ; номер пристрою ? номер функц?ї
      ; Л?чильник операц?й натискання/в?дпускання клав?ш
      PressCounter DW ?
      ; Текстов? пов?домлення
      PCI DB 0,25,"Тестування функцiй PCI BIOS",0
          DB 4,20,"Параметри виявленого контролера мосту хоста",0
          DB 6,0,"Номер шини:",0
          DB 7,0,"Номер пристрою:",0
          DB 8,0,"Номер функцiї:",0
          DB 9,0,"Iдентиф?катор виробника:",0
          DB 10,0,"Iдентифiкатор пристрою:",0
          DB 11,0,"Тип пристрою:",0
          DB 12,0,"Базова адреса 0:",0
          DB 13,0,"Базова адреса 1:",0
          DB 14,0,"Базова адреса 2:",0
          DB 15,0,"Базова адреса 3:",0
          DB 16,0,"Базова адреса 4:",0
          DB 17,0,"Базова адреса 5:",0
          DB 18,0,"Номер переривання, що використовується:",0
          DB 24,29,"Натиснiть будь-яку клавiшу",0
      ; Пов?домлення про те, що переривання не використовується
      NoIRQ DB 18,32,"не використовується",0
      ; Пов?домлення про помилки
      NotPCI DB LIGHTRED,12,18
             DB "Система не пiдтримує iнтерфейс PCI BIOS",0
      NotSVGA DB LIGHTRED,12,22
              DB "Контролера мосту хоста не знайдено",0
      BadRegister DB LIGHTRED,12,22
                  DB "Невiрний номер регiстра",0
      Exit DB LIGHTRED,24,17
           DB "Для виходу з програми натиснiть будь-яку клавiшу",0
      ENDS
      
      CODESEG
      ;*****************************
      ;* Основний модуль програми  *
      ;*****************************
      PROC PCITest  near
              mov     AX,DGROUP
              mov     DS,AX
      ; Установити текстовий режим ? очистити екран
              mov     AX,3
              int     10h
      ; Сховати курсор - забрати за нижню границю екрана
              mov     [ScreenString],25
              mov     [ScreenColumn],0
              call    SetCursorPosition
      ; Установити зелений кол?р символ?в ? чорний фон
              mov     [TextColorAndBackground],LIGHTGREEN
      ; Вивести текстов? пов?домлення на екран
              mov     CX,16
              mov     SI,offset PCI
      @@NextString:
              call    ShowString
              loop    @@NextString
      ; Установити жовтий кол?р символ?в ? чорний фон
              mov     [TextColorAndBackground],YELLOW
      
      ; Опитування PCI-устройств
      ; Перев?рити наявн?сть PC? B?OS
              mov     AX,0B101h
              int     1Ah
              jc      @@PCIBIOSNotFound
              cmp     EDX,20494350h
              jne     @@PCIBIOSNotFound
      ;Знайт контролер мосту хоста
      ; (пристр?й типу 090000h)
              mov     AX,0B103h
              mov     ECX,060000h
              mov     SI,0
              int     1Ah
              jc      @@DeviceNotFound
              mov     [BusNumber],BH
              mov     [DeviceNumber],BL
      
      ; Одержати ?дентиф?катор виробника
              mov     AX,0B109h ; читати слово
              mov     DI,0      ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [VendorID],CX
      ; Одержати ?дентиф?катор пристрою
              mov     AX,0B109h ; читати слово
              mov     DI,2      ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [DeviceID],CX
      ; Одержати тип пристрою (самоперев?рка)
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,8      ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              shr     ECX,8
              mov     [ClassCode],ECX
      ; Одержати базову адресу 0
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,10h    ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress0],ECX
      ; Одержати базову адресу 1
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,14h    ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress1],ECX
      ; Одержати базову адресу 2
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,18h    ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress2],ECX
      ; Одержати базову адресу 3
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,1Ch    ; зсув слова
              int     1Ah

              jc      @@BadRegisterNumber
              mov     [BaseAddress3],ECX
      ; Одержати базову адресу 4
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,20h    ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress4],ECX
      ; Одержати базову адресу 5
              mov     AX,0B10Ah ; читати подв?йне слово
              mov     DI,24h    ; зсув слова
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [BaseAddress5],ECX
      
      ; Одержати номер переривання IRQ,
      ; що використовується пристроєм
              mov     AX,0B108h ; читати байт
              mov     DI,3Ch    ; зсув байта
              int     1Ah
              jc      @@BadRegisterNumber
              mov     [InterruptLine],CL
      
      ; Вивести отриман? дан? на екран в
      ; ш?стнадцятир?чному код?
              ; В?добразити основн? параметри пристрою
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
      
              ; В?добразити базов? адреси
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
      
              ; Вивести номер переривання ?RQ, що використовується
              inc     [ScreenString]
              mov     [ScreenColumn],40
              mov     AL,[InterruptLine]
              cmp     AL,0FFh      ; переривання використовується?
              je      @@IRQNotUsed
              call    ShowByteHexCode
              jmp short @@End
      @@IRQNotUsed:
              mov     SI,offset NoIRQ
              call    ShowString
              jmp short @@End
      
      ; Обробка помилок
      @@BadRegisterNumber:
              ; Нев?рний номер рег?стра
              mov     SI,offset BadRegister
              jmp     @@ErrorMessage
      @@DeviceNotFound:
              ; Не знайдений контролер мосту хоста
              mov     SI,offset NotSVGA
              jmp     @@ErrorMessage
      @@PCIBIOSNotFound:
              ; Не п?дтримується PC? B?OS
              mov     SI,offset NotPCI
      @@ErrorMessage:
              ; Видати пов?домлення про тип помилки
              call    ClearScreen
              call    ShowColorString
              mov     SI,offset Exit
              call    ShowColorString
      
      ; Зак?нчення роботи
      @@End:  ; Оч?кувати натискання будь-якої клав?ш?
              call    GetChar
      ; Переустановити текстовий режим ? очистити екран
              mov     AX,3
              int     10h
      ; Вих?д у DOS
              mov     AH,4Ch
              int     21h
      ENDP PCITest 
      END  PCITest
      ENDS

