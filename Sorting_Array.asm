#include "p16f84.inc"

c_adr  set  0x30    ; Начальный адрес массива
c_num  set  0x5    ; Количество элементов в массиве
v_ptr  equ  0x2F    ; Указатель на текущий элемент
tmp    equ  0x1E    ; Временная переменная
flag   equ  0x1F    ; Флаг перестановок
dir    equ  0x4F    ; Направление сортировки

BEGIN:

movlw  b'00000000'  ; Поместить значение в регистр W
bsf    STATUS,RP0   ; Выбор банка 1
movwf  TRISB        ; Установить PORTB на выход (Все ножки в 0)
bcf    STATUS,RP0   ; Выбор банка 0
clrf   PORTB        ; Очистить PORTB
movf   PORTA, W     ; Запомнить состояние PORTA в переменную dir
movwf  dir
 
SORT

clrf   flag         ; Сброс флага перестановок
movlw  c_adr        ; Поместить в W начальный адрес массива
movwf  FSR 

COMPARE

movf   INDF, W      ; Чтение i-го числа
movwf  tmp          ; Временное сохранение в tmp
incf   FSR, F       ; Чтение (i + 1)-го числа
subwf  INDF, W      ; Сравнение i и (i + 1)

btfss  dir, 0       ; Выбор направления сортировки
goto   ASCENDING
goto   DESCENDING

ASCENDING           ; Сортировка по возрастанию
                    
btfsc  STATUS, C
goto   NEXTNUMBER
goto   EXCHANGE

DESCENDING          ; Сортировка по убыванию

btfss STATUS, C
goto NEXTNUMBER
btfsc STATUS, Z
goto NEXTNUMBER

EXCHANGE

movf   INDF, W      ; Меняем местами пару чисел
decf   FSR, F
movwf  INDF
movf   tmp, W
incf   FSR, F
movwf  INDF
bsf    flag, 0      ; Установка флага перестановок

NEXTNUMBER

movlw  c_adr + c_num     
subwf  FSR, W
btfss  STATUS, C
goto   COMPARE      ; Если проверены не все пары чисел, то переходим к COMPARE

btfsc  flag, 0      ; Проверка, были ли перестановки
goto   SORT         ; Если были, проходим по массиву ещё раз

movlw  b'00000010'  ; Сигнал об окончании сотрировки по возрастанию на RB1
btfsc  dir, 0       ; Если RB0 установлен в 0, то пропустить следующую команду
movlw  b'00000100'  ; Сигнал об окончании сотрировки по убыванию на RB2
movwf  PORTB

end