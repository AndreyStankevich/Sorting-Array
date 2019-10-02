#include "p16f84.inc"

c_adr  set  0x30    ; ��������� ����� �������
c_num  set  0x5    ; ���������� ��������� � �������
v_ptr  equ  0x2F    ; ��������� �� ������� �������
tmp    equ  0x1E    ; ��������� ����������
flag   equ  0x1F    ; ���� ������������
dir    equ  0x4F    ; ����������� ����������

BEGIN:

movlw  b'00000000'  ; ��������� �������� � ������� W
bsf    STATUS,RP0   ; ����� ����� 1
movwf  TRISB        ; ���������� PORTB �� ����� (��� ����� � 0)
bcf    STATUS,RP0   ; ����� ����� 0
clrf   PORTB        ; �������� PORTB
movf   PORTA, W     ; ��������� ��������� PORTA � ���������� dir
movwf  dir
 
SORT

clrf   flag         ; ����� ����� ������������
movlw  c_adr        ; ��������� � W ��������� ����� �������
movwf  FSR 

COMPARE

movf   INDF, W      ; ������ i-�� �����
movwf  tmp          ; ��������� ���������� � tmp
incf   FSR, F       ; ������ (i + 1)-�� �����
subwf  INDF, W      ; ��������� i � (i + 1)

btfss  dir, 0       ; ����� ����������� ����������
goto   ASCENDING
goto   DESCENDING

ASCENDING           ; ���������� �� �����������
                    
btfsc  STATUS, C
goto   NEXTNUMBER
goto   EXCHANGE

DESCENDING          ; ���������� �� ��������

btfss STATUS, C
goto NEXTNUMBER
btfsc STATUS, Z
goto NEXTNUMBER

EXCHANGE

movf   INDF, W      ; ������ ������� ���� �����
decf   FSR, F
movwf  INDF
movf   tmp, W
incf   FSR, F
movwf  INDF
bsf    flag, 0      ; ��������� ����� ������������

NEXTNUMBER

movlw  c_adr + c_num     
subwf  FSR, W
btfss  STATUS, C
goto   COMPARE      ; ���� ��������� �� ��� ���� �����, �� ��������� � COMPARE

btfsc  flag, 0      ; ��������, ���� �� ������������
goto   SORT         ; ���� ����, �������� �� ������� ��� ���

movlw  b'00000010'  ; ������ �� ��������� ���������� �� ����������� �� RB1
btfsc  dir, 0       ; ���� RB0 ���������� � 0, �� ���������� ��������� �������
movlw  b'00000100'  ; ������ �� ��������� ���������� �� �������� �� RB2
movwf  PORTB

end