.MODEL SMALL
.STACK 100h
.DATA
    MyString DB 'Hello, World!', 0 ; 以 0 结尾的字符串

.CODE
; 程序入口
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; 调用清屏子程序
    CALL ClearScreen
    
    ; 调用显示字符串子程序
    CALL DisplayString
    
    ; 将光标移动到左下角
    CALL MoveCursorToBottomLeft
    
    ; 程序结束
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; 清屏子程序
ClearScreen PROC
    MOV AX, 0600h           ; 设置功能号为 06h，表示清屏
    MOV BH, 07h             ; 清屏后的字符属性（白底黑字）
    MOV CX, 0               ; CX 的高位和低位表示清屏区域的左上角（行:列），这里是(0,0)
    MOV DX, 184Fh           ; DX 的高位和低位表示清屏区域的右下角（24行，79列）
    INT 10h                 ; 调用 BIOS 中断执行清屏
    RET
ClearScreen ENDP

; 显示字符串子程序
DisplayString PROC
    ; 设置光标位置
    MOV AH, 02h             ; 功能号 02h：设置光标位置
    MOV BH, 0               ; 页号（通常设置为0）
    MOV DH, 5               ; 行号，第5行
    MOV DL, 10              ; 列号，第10列
    INT 10h                 ; 设置光标位置

    ; 显示字符串
    MOV SI, OFFSET MyString ; 加载字符串偏移地址
PrintLoop:
    LODSB                   ; 从字符串加载下一个字符到 AL
    OR AL, AL               ; 检查是否为结束符（0）
    JZ Done                 ; 若为结束符，则跳转至 Done
    MOV AH, 0Eh             ; 功能号 0Eh：Teletype 输出字符
    INT 10h                 ; 显示字符
    JMP PrintLoop           ; 循环显示下一个字符

Done:
    RET
DisplayString ENDP

; 将光标移动到屏幕左下角
MoveCursorToBottomLeft PROC
    MOV AH, 02h             ; 功能号 02h：设置光标位置
    MOV BH, 0               ; 页号
    MOV DH, 24              ; 行号，第24行（屏幕最底行）
    MOV DL, 0               ; 列号，第0列（最左侧）
    INT 10h                 ; 设置光标位置
    RET
MoveCursorToBottomLeft ENDP

END MAIN
