ASSUME CS:CODE, DS:DATA
DATA SEGMENT
    prompt  DB "The 9mul9 table: $"
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA
    MOV DS, AX

    LEA DX, prompt
    MOV AH, 9
    INT 21H

    MOV DL, 13
    MOV AH, 2
    INT 21H
    MOV DL, 10
    MOV AH, 2
    INT 21H

    MOV CX, 1
    MOV DX, 1

    PUSH CX
    PUSH DX

outLOOP:
    PUSH CX
    PUSH DX

inLOOP:
    POP DX
    POP CX

    ; 保存 CX 和 DX 到栈
    PUSH CX
    PUSH DX

    ; 输出 '行数x列数='
    CALL preoutput    ; 输出行列信息

    ; 恢复 CX 和 DX
    POP DX
    POP CX
    PUSH DX
    ; 计算乘法
    MOV AX, CX
    MUL DX             ; AX = CX * DX
    POP DX             ;MUL把结果的高16位放在了DX里，所以要从栈中恢复DX值

    PUSH CX
    PUSH DX
    ; 输出结果
    CALL PRINT_NUMBER   ; 输出乘法结果

    MOV DL, ' '
    MOV AH, 2
    INT 21H

    POP DX
    POP CX

    inc DX
    cmp DX, 10
    jge resetCol

    PUSH CX
    PUSH DX

    jmp inLOOP

resetCol:
    MOV DX, CX
    inc DX
    PUSH CX
    PUSH DX
    ; 换行
    MOV DL, 13
    MOV AH, 2
    INT 21H
    MOV DL, 10
    MOV AH, 2
    INT 21H

    POP DX
    POP CX

    inc CX
    cmp CX, 10
    jge endofmul

    PUSH CX
    PUSH DX

    jmp outLOOP

endofmul:
    ; 退出程序
    MOV AH, 4CH
    INT 21H

preoutput:
    ; 输出当前行数和列数
    PUSH DX
    MOV AX, CX    ; 读取当前行数
    CALL PRINT_NUMBER
    MOV DL, 'X'
    MOV AH, 2
    INT 21H
    POP DX
    MOV AX, DX   ; 读取当前列数
    CALL PRINT_NUMBER
    MOV DL, '='
    MOV AH, 2
    INT 21H
    RET

PRINT_NUMBER:
    MOV BX, 10          ; BX 初始化为 10
    MOV CX, 0           ; CX 初始为 0

    oLOOP1: 
        MOV DX, 0      ; DX = 0
        DIV BX         ; AX = AX / 10; 余数放在 DX
        ADD DL, '0'    ; 把 DL 加上 '0'
        PUSH DX        ; 把 DX 压入栈
        INC CX         ; CX++
        CMP AX, 0     
        JNZ oLOOP1     ; 如果 AX 不为 0, 继续循环

    MOV AH, 2          ; 准备输出字符
    oLOOP2: 
        POP DX         ; 从栈中弹出数字
        INT 21H        ; 输出数字
        LOOP oLOOP2    ; 循环输出

    RET                 ; 结束调用

CODE ENDS
END START
