;                     ЛИСТИНГ 3.1
;         Подпрограмма, устанавливающая режим
;              линейной адресации данных
;
; Автор текста программы Кулаков Владимир Геннадьевич.
; Файл lst_3_01.inc, 08.03.2000

; Порт, управляющий запретом немаскируемых прерываний
CMOS_ADDR      equ  0070h
CMOS_DATA      equ  0071h
; Селекторы сегментов
SYS_PROT_CS    equ  0008h
SYS_REAL_SEG   equ  0010h
SYS_MONDO_SEG  equ  0018h

CODESEG
;**********************************************
;* ВКЛЮЧЕНИЕ РЕЖИМА ЛИНЕЙНОЙ АДРЕСАЦИИ ПАМЯТИ *
;*       (процедура параметров не имеет)      *
;**********************************************
PROC Initialization NEAR
        pushad
; Сохранить значения сегментных регистров в
; реальном режиме (кроме GS)
        mov     [CS:Save_SP],SP
        mov     AX,SS
        mov     [CS:Save_SS],AX
        mov     AX,DS
        mov     [CS:Save_DS],AX
; (работаем теперь только с кодовым сегментом)
        mov     AX,CS
        mov     [word ptr CS:Self_Mod_CS],AX
        mov     DS,AX
        cli
        mov     SS,AX
        mov     SP,offset Local_Stk_Top
        sti

; Установить режим линейной адресации
        call    SetLAddrModeForGS

; Восстановить значения сегментных регистров
        cli
        mov     SP,[CS:Save_SP]
        mov     AX,[CS:Save_SS]
        mov     SS,AX
        mov     AX,[CS:Save_DS]
        mov     DS,AX
        sti
; Разрешить работу линии A20
        call    Enable_A20
        popad
        ret
ENDP Initialization


; Область сохранения значений сегментных регистров
Save_SP DW ?
Save_SS DW ?
Save_DS DW ?
; Указатель на GDT
GDTPtr  DQ ?
; Таблица дескрипторов сегментов для
; входа в защищенный режим
GDT DW 00000h,00000h,00000h,00000h ;не используется
    DW 0FFFFh,00000h,09A00h,00000h ;сегмент кода CS
    DW 0FFFFh,00000h,09200h,00000h ;сегмент данных DS
    DW 0FFFFh,00000h,09200h,0008Fh ;сегмент GS
; Локальный стек для защищенного режима
; (организован внутри кодового сегмента)
label GDTEnd word
        DB 255 DUP(0FFh)
Local_Stk_Top DB (0FFh)


;*********************************************
;*        ОТМЕНИТЬ ПРЕДЕЛ СЕГМЕНТА GS        *
;* Процедура изменяет содержимое теневого    *
;* регистра GS таким образом, что становится *
;* возможной линейная адресация через него   *
;* 4 Gb памяти в реальном режиме             *
;*********************************************
PROC SetLAddrModeForGS near
; Вычислить линейный адрес кодового сегмента
        mov     AX,CS
        movzx   EAX,AX
        shl     EAX,4   ;умножить номер параграфа на 16
        mov     EBX,EAX ;сохранить линейный адрес в EBX
; Занести младшее слово линейного адреса в дескрипторы
; сегментов кода и данных
        mov     [word ptr CS:GDT+10],AX
        mov     [word ptr CS:GDT+18],AX
        ; Переставить местами старшее и младшее слова
        ror     EAX,16
; Занести биты 16-23 линейного адреса в дескрипторы
; сегментов кода и данных
        mov     [byte ptr CS:GDT+12],AL
        mov     [byte ptr CS:GDT+20],AL
; Установить предел (Limit) и базу (Base) для GDTR
        add     bx, offset GDT
        mov [word ptr CS:GDTPtr],(offset GDTEnd-GDT-1)
        mov     [dword ptr CS:GDTPtr+2],EBX
; Сохранить регистр флагов
        pushf
; Запретить прерывания, так как таблица прерываний IDT
; не сформирована для защищенного режима
        cli
; Запретить немаскируемые прерывания NMI
        in      AL,CMOS_ADDR
        mov     AH,AL
        or      AL,080h      ;установить старший разряд
        out     CMOS_ADDR,AL ;не затрагивая остальные
        and     AH,080h
        ; Запомнить старое состояние маски NMI
        mov     CH,AH
; Перейти в защищенный режим
        lgdt    [fword ptr CS:GDTPtr]
        mov     BX,CS    ;запомнить сегмент кода
        mov     EAX,CR0
        or      AL,01b   ;установить бит PE
        mov     CR0,EAX  ;защита разрешена
        ; Безусловный дальний переход на метку SetPMode
        ; (очистить очередь команд и перезагрузить CS)
                DB      0EAh
                DW      (offset SetPMode)
                DW      SYS_PROT_CS
SetPMode:
        ; Подготовить границы сегментов
        mov     AX,SYS_REAL_SEG
        mov     SS,AX
        mov     DS,AX
        mov     ES,AX
        mov     FS,AX
        ; Снять ограничения с сегмента GS
        mov     AX,SYS_MONDO_SEG
        mov     GS,AX
; Вернуться в реальный режим
        mov     EAX,CR0
        and     AL,11111110b ;сбросить бит PE
        mov     CR0,EAX      ;защита отключена

        ; Безусловный дальний переход на метку SetRMode
        ; (очистить очередь команд и перезагрузить CS)
            DB 0EAh
            DW (offset SetRMode)
Self_Mod_CS DW ?

SetRMode:
        ; Регистры стека и данных
        ; настроить на сегмент кода
        mov     SS,BX
        mov     DS,BX
        ; Обнулить дополнительные сегментные
        ; регистры данных (GS не трогать!)
        xor     AX,AX
        mov     ES,AX
        mov     FS,AX
        ; Возврат в реальный режим,
        ; прерывания снова разрешены
        in      AL,CMOS_ADDR
        and     AL,07Fh
        or      AL,CH
        out     CMOS_ADDR,AL
        popf
        ret
ENDP SetLAddrModeForGS


;****************************************
;* Разрешить работу с памятью выше 1 Мб *
;****************************************
PROC Enable_A20 near
        call    Wait8042BufferEmpty
        mov     AL,0D1h ;команда управления линий A20
        out     64h,AL
        call    Wait8042BufferEmpty
        mov     AL,0DFh ;разрешить работу линии
        out     60h,AL
        call    Wait8042BufferEmpty
        ret
ENDP Enable_A20


;***********************************************
;*   ОЖИДАНИЕ ОЧИСТКИ ВХОДНОГО БУФЕРА I8042    *
;* При выходе из процедуры:                    *
;* флаг ZF установлен - нормальное завершение, *
;* флаг ZF сброшен - ошибка тайм-аута.         *
;***********************************************
proc Wait8042BufferEmpty near
        push    CX
        mov     CX,0FFFFh  ;задать число циклов
@@kb:   in      AL,64h     ;получить статус
        test    AL,10b     ;буфер i8042 свободен?
        loopnz  @@kb       ;если нет, то цикл
        pop     CX
        ; (если при выходе сброшен флаг ZF - ошибка)
        ret
endp Wait8042BufferEmpty
ENDS
