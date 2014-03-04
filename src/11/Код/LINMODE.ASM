; Використання лiнiйної адресацiї для вiдображення
; на екранi змiсту оперативної памятi
;
; РЛА - Режим Лiнiйної адресацiї
;
IDEAL
P386
LOCALS
MODEL MEDIUM

INCLUDE "KEYS.INC" 	; мнемонiчнi коди клавiш
INCLUDE "COLORS.INC"	; мнемонiчнi коди кольорiв
INCLUDE "SWITCH.INC"    ; пiдпрограма переводу сегментого регiстра GS у РЛА
INCLUDE "IO.INC"	; пiдпрограми вводу/виводу даних на екран

SEGMENT sseg para stack 'STACK'  
DB 400h DUP(?)
ENDS

DATASEG
; Текстовi повiдомлення
Txt1 DB LIGHTMAGENTA,0,28,"Дамп оперативної пам'яти",0
     DB YELLOW,2,0,"Адреси",0
     DB LIGHTGREEN,2,11
     DB "Шiснадцятерiчне представлення:",0
     DB LIGHTCYAN,2,61,"ASCII-коди:",0
     DB LIGHTRED,21,0,"Введiть число "
     DB "або натиснiсть керуючу клавiшу:",0
Txt2 DB 23,0, "Стрiлка вниз - наступнi 256 байт;",0
     DB 23,35, "Стрiлка нагору - попереднi 256 байт;",0
     DB 24,0, "Enter - завершення вводу адреси;",0
     DB 24,33, "Esc - вiдмiна вводу адреси;",0
     DB 24,60, "F10 - вихiд",0

; Кiлькiсть введених символiв числа
CharacterCounter DB 0

; Позицiя для введенню адреси на екранi
OutAddress DB 21,47

; Рядок для вводу адреси
AddressString DB 9 DUP(0)

; Рядок промiжкiв для "затирання" числа
SpaceString DB 21,47,9 DUP(' '),0

; Початкова адреса
StartAddress DD 0

; Код команди
CommandByte DB 0
ENDS


CODESEG
;******************************************************
;*         ВИВIД БАЙТА НА ЕКРАН У КОДI ASCII          *
;* Пiдпрограма виводить змiст регiстра AL у кодi      *
;* ASCII в зазначену позицiю екрана.                  *
;* Координати позицiї передаються через глобальнi     *
;* змiннi ScreenString i ScreenColumn.                *
;******************************************************
PROC ShowASCIIChar near
        pusha
        push    DS
        push    ES
        mov     DI,DGROUP
        mov     DS,DI
        cld

; Настроїти пари ES:DI для прямого виводу у вiдеопам'ять
        push    AX
        
; Завантажити адресу сегмента вiдеоданих у ES
        mov     AX,0B800h
        mov     ES,AX

; Помножити номер рядка на довжину рядка в байтах
        mov     AX,[ScreenString]
        mov     DX,160
        mul     DX

        add     AX,[ScreenColumn]
        add     AX,[ScreenColumn]
        mov     DI,AX
        pop     AX
        mov     AH,[TextColorAndBackground]
        stosw

; Пiдготовка для виводу наступних байтiв
        ; Перевести поточну позицiю на 2 символи влiво
        inc     [ScreenColumn]
        
; Перевiрити перетинання правої границi екрана
        cmp     [ScreenColumn],80
        jb      @@End

        ; Якщо досягнута права границя екрана - 
        ; перейти на наступний рядок
        sub     [ScreenColumn],80
        inc     [ScreenString]
@@End:  pop     ES
        pop     DS
        popa
        ret
ENDP ShowASCIIChar


;*********************************************************
;* ПЕРЕКЛАД ЧИСЛА IЗ ШЕСТНАДЦАТЕРИЧНОГО КОДУ В ДВIЙКОВИЙ *
;* DS:SI - число в кодi ASCII.                           *
;* Результат повертається в EAX.                         *
;*********************************************************
PROC HexToBin32 near
        push    EBX
        push    CX
        push    SI
        cld
        xor     EBX,EBX ;обнулюємо накопичувач
        xor     CX,CX   ;обнулюємо лiчильник цифр
@@h0:   lodsb
        
; Перевiрка на нуль (ознака кiнця рядка)
        and     AL,AL
        jz      @@h4
        
; Перевiрка на дiапазон '0'-'9'
        cmp     AL,'0'  
        jb      @@Error
        cmp     AL,'9'  
        ja      @@h1
        sub     AL,'0'
        jmp short @@h3
@@h1:   ; Перевiрка на дiапазон 'A'-''
        cmp     AL,'A'  
        jb      @@Error
        cmp     AL,'F'  
        ja      @@h2
        sub     AL,'A'-10
        jmp short @@h3
@@h2:   ; Перевiрка на дiапазон 'a'-'f'
        cmp     AL,'a'  
        jb      @@Error
        cmp     AL,'f'  
        ja      @@Error
        sub     AL,'a'-10
@@h3:   ; Дописати до результату
        ; черговi 4 розряди праворуч
        shl     EBX,4
        or      BL,AL
        inc     CX
        cmp     CX,8
        jbe     @@h0
        ; Якщо в числi бiльше 8 цифр - помилка
        jmp short @@Error
@@h4:   ; Успiшне завершення - результат у EAX
        mov     EAX,EBX
        jmp short @@End
@@Error:; Помилка - обнулити результат
        xor     EAX,EAX 
@@End:  pop     SI
        pop     CX
        pop     EBX
        ret
ENDP HexToBin32


;************************************************
;* ПРИЙНЯТИ З КЛАВIАТУРИ НОВУ АДРЕСУ ЧИ КОМАНДУ *
;************************************************
PROC GetAddressOrCommand near
        pushad
        mov     [TextColorAndBackground],WHITE
        mov     [ScreenString],21
@@GetAddressOrCommand:
; Iнiцiалiзувати змiннi
        ; Обнулити лiчильник цифр
        mov     [CharacterCounter],0
        ; Очистити рядок
        mov     DI,offset AddressString
        mov     [byte ptr DS:DI],0   
        ; Очистити позицiю введення (забити промiжками)
        mov     SI,offset SpaceString
        call    ShowString
        ; Установити курсор у позицiю введення
        mov     [ScreenColumn],47
        mov     AL,[CharacterCounter]
        add     [byte ptr ScreenColumn],AL
        call    SetCursorPosition
        ; Увести цифру чи команду
        call    GetChar
        cmp     AL,0
        jz      @@Command

; ВВЕДЕННЯ АДРЕСИ В ШЕСТНАДЦАТЕРИЧНОМУ КОДI
@@Address:
        ; Перевiрка на дiапазон '0'-'9'
        cmp     AL,'0'  
        jb      @@AddressError
        cmp     AL,'9'  
        jbe     @@WriteChar
        ; Перевiрка на дiапазон 'A'-''
        cmp     AL,'A'  
        jb      @@AddressError
        cmp     AL,'F'  
        jbe     @@WriteChar
        ; Перевiрка на дiапазон 'a'-'f'
        cmp     AL,'a'  
        jb      @@AddressError
        cmp     AL,'f'  
        ja      @@AddressError
@@WriteChar:
        ; Перевiряємо кiлькiсть цифр
        cmp     [CharacterCounter],8
        jae     @@AddressError
        inc     [CharacterCounter]
        ; Записуємо цифру в число
        mov     [DS:DI],AL
        inc     DI
        ; Пересунути ознака кiнця рядка
        ; у наступний розряд
        mov     [byte ptr DS:DI],0
        ; Вiдобразити число на екранi
        mov     SI,offset SpaceString
        call    ShowString
        mov     SI,offset OutAddress
        call    ShowString
@@GetNextChar:
        ; Вiдобразити курсор у новiй позицiї введення
        mov     [ScreenColumn],47
        mov     AL,[CharacterCounter]
        add     [byte ptr ScreenColumn],AL
        call    SetCursorPosition
        ; Очiкувати введення наступного символу
        call    GetChar
        cmp     AL,0
        jne     @@Address

; Проаналiзувати код натиснутої клавiшi
        cmp     AH,B_Esc       ;скасування введення адреси
        je      @@GetAddressOrCommand

@@TestF10:
        cmp     AH,F10         ;"Вихiд"
        jne     @@TestRubout
        mov     [CommandByte],AH
        jmp     @@End

@@TestRubout:
        cmp     AH,B_RUBOUT    ;"Вибiй"
        jne     @@TestEnter
        cmp     [CharacterCounter],0
        je      @@AddressError
        ; Пересунути ознака кiнця рядка
        ; на розряд улiво
        dec     DI
        dec     [CharacterCounter]
        mov     [byte ptr DS:DI],0
        ; Вiдобразити число на екранi
        mov     SI,offset SpaceString
        call    ShowString
        mov     SI,offset OutAddress
        call    ShowString
        jmp     @@GetNextChar

@@TestEnter:
        cmp     AH,B_Enter     ;завершення введення числа
        jne     @@AddressError
        mov     [CommandByte],AH
        mov     SI,offset AddressString
        call    HexToBin32
        mov     [StartAddress],EAX
        jmp short @@End

@@AddressError:
        call    Beep
        jmp     @@GetNextChar

; ОБРОБКА "КОМАНД"
@@Command:
        cmp     AH,F10         ;"Вихiд"
        jne     @@TestDn
        mov     [CommandByte],AH
        jmp short @@End

@@TestDn:
        cmp     AH,B_DN        ;"Стрiлка вниз"
        jne     @@TestUp
        mov     [CommandByte],AH
        add     [StartAddress],256
        jmp short @@End

@@TestUp:
        cmp     AH,B_UP        ;"Стрiлка нагору"
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
;* Стартова процедура програми *
;*******************************
PROC MemoryDump
        mov     AX,DGROUP
        mov     DS,AX

; Установлюємо режим прямої адресацiї памятi
        call    Initialization

; Текстовий режим
        mov     AX,3
        int     10h

; Сховати курсор 
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

; Вiдобразити символи-дiльники колонок
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

; Iнiцiалiзуємо змiннi
        mov     [StartAddress],0
        mov     [CommandByte],0

; ЗОВНIШНIЙ ЦИКЛ
@@q0:   mov     EBX,[StartAddress]
        mov     [ScreenString],4
        mov     DX,16
@@q1:   mov     [ScreenColumn],0

; Вiдобразити лiнiйну адресу першого байта в групi
        mov     [TextColorAndBackground],YELLOW
        mov     EAX,EBX
        call    ShowHexDWord

; Вiдобразити символ-роздiльник стовпчикiв
        mov     [TextColorAndBackground],WHITE
        inc     [ScreenColumn]
        mov     AL,0B3h
        call    ShowASCIIChar
        inc     [ScreenColumn]

; Вiдобразити чергову групу байт
; у шестнадцатеричном кодi
        mov     CX,16
        mov     [TextColorAndBackground],LIGHTGREEN
@@q2:   mov     AL,[GS:EBX]
        call    ShowByteHexCode
        inc     [ScreenColumn]
        inc     EBX
        loop    @@q2

; Вiдобразити символ-роздiльник стовпчикiв
        mov     [TextColorAndBackground],WHITE
        mov     AL,0B3h
        call    ShowASCIIChar
        inc     [ScreenColumn]

        ; Повернутися назад на 16 символiв
        sub     EBX,16

; Вiдобразити чергову групу байт у кодах ASCII
        mov     CX,16
        mov     [TextColorAndBackground],LIGHTCYAN
@@q3:   mov     AL,[GS:EBX]
        call    ShowASCIIChar
        inc     EBX
        loop    @@q3
        inc     [ScreenString]
        dec     DX
        jnz     @@q1

        ; Очiкувати натискання будь-якої клавiшi
        call    GetAddressOrCommand
        cmp     [CommandByte],F10
        jne     @@q0

@@End:  ; Установити текстовий режим
	mov     ax,3
	int     10h
; Вихiд у DOS
	mov     AH,4Ch
	int     21h
ENDP	MemoryDump
END	MemoryDump
ENDS