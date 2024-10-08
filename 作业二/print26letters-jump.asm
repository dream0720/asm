.MODEL SMALL

DATASEG SEGMENT
    Letters DB 'a'              ; 第一个字母
    NL      DB 0Dh, 0Ah, '$'    ; 换行符
DATASEG ENDS

CODESEG SEGMENT
            ASSUME CS:CODESEG, DS:DATASEG

MAIN PROC
            MOV    AX, DATASEG
            MOV    DS, AX

            MOV    CX, 26                    ; 设置循环次数为26
            MOV    SI, 0                     ; 计数器初始化为0
    
    L:      
            MOV    AL, [Letters]             ; 从数组中取出小写字母
            MOV    DL, AL
            MOV    AH, 02h                   ; 设置功能号为打印字符
            INT    21H                       ; 打印当前字符

            INC    AL                        ; 移动到下一个字母
            MOV    [Letters], AL             ; 更新数组中的字母

            INC    SI                        ; 计数器增加
            CMP    SI, 13                    ; 检查计数器是否等于13
            JE     NEWLINE                   ; 如果SI等于13，则打印换行
    B:      
            LOOP   L                         ; 循环直到CX为0
            JMP    ENDL                      ; 跳转到结束

    NEWLINE:
            MOV    DX, OFFSET NL             ; 指向换行符
            MOV    AH, 09h                   ; 设置功能号为打印字符串
            INT    21H                       ; 打印换行
            MOV    SI, 0                     ; 重置计数器
            JMP    B                         ; 继续循环

    ENDL:   
            MOV    AX, 4C00h                 ; 退出程序
            INT    21H
MAIN ENDP

CODESEG ENDS
END MAIN
