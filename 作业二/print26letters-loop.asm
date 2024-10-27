.MODEL SMALL

DATASEG SEGMENT
    Letters DB 'a'              ; 第一个字母
    NL      DB 0Dh, 0Ah, '$'    ; 换行符
DATASEG ENDS

CODESEG SEGMENT
               ASSUME CS:CODESEG, DS:DATASEG

; 新过程：打印字母并处理双层循环
PRINT_AND_LOOP PROC
    MOV    CX, 2                     ; 外层循环次数为2（两行）

OUTER_LOOP:
    MOV    SI, 0                     ; 内层计数器初始化为0

INNER_LOOP:
    MOV    AL, [Letters]             ; 从数组中取出小写字母
    MOV    DL, AL
    MOV    AH, 02h                   ; 设置功能号为打印字符
    INT    21H                       ; 打印当前字符

    INC    AL                        ; 移动到下一个字母
    MOV    [Letters], AL             ; 更新数组中的字母

    INC    SI                        ; 计数器增加
    CMP    SI, 13                    ; 检查内层计数器是否等于13
    JL     INNER_LOOP                ; 如果小于13，继续内层循环

    ; 打印换行
    MOV    DX, OFFSET NL             ; 指向换行符
    MOV    AH, 09h                   ; 设置功能号为打印字符串
    INT    21H                       ; 打印换行

    LOOP   OUTER_LOOP                ; 外层循环，控制两行
    RET
PRINT_AND_LOOP ENDP

;主循环
MAIN PROC
    MOV    AX, DATASEG
    MOV    DS, AX

    CALL   PRINT_AND_LOOP            ; 调用打印字母和双层循环的过程

    MOV    AX, 4C00h                 ; 退出程序
    INT    21H
MAIN ENDP

CODESEG ENDS
END MAIN
