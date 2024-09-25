.MODEL SMALL

DATASEG SEGMENT
    Letters DB 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC
    ; 初始化数据段
    MOV AX, DATASEG
    MOV DS, AX

    MOV CX, 26          ; 设置循环次数为26
    MOV SI, 0           ; 数组索引初始化为0

L: 
    MOV AL, [Letters + SI] ; 从数组中取出小写字母
    MOV AH, 02h          ; 设置功能号为打印字符
    INT 21H              ; 打印当前字符
    INC SI               ; 移动到下一个字母
    LOOP L               ; 循环直到CX为0

    ; 退出程序
    MOV AX, 4C00h        ; 退出程序
    INT 21H
MAIN ENDP

CODESEG ENDS
END MAIN
