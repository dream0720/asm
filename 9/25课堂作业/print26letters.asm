.MODEL SMALL

DATASEG SEGMENT
    Letters DB 'a'
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC
    MOV AX, DATASEG
    MOV DS, AX

    MOV CX, 26          ; 设置循环次数为26
    MOV SI, 0           ; 数组索引初始化为0

L: 
    MOV AL, [Letters] ; 从数组中取出小写字母
    MOV DL, AL
    MOV AH, 02h          ; 设置功能号为打印字符
    INC AL               ; 移动到下一个字母
    MOV [Letters], AL
    INT 21H              ; 打印当前字符
    LOOP L               ; 循环直到CX为0

    MOV AX, 4C00h        ; 退出程序
    INT 21H
MAIN ENDP

CODESEG ENDS
END MAIN
