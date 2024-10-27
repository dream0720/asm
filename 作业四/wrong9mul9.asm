ASSUME CS:CODE, DS:DATA
DATA SEGMENT
    xy     DB "x    y$"
    space  DB "    $"
    error  DB "error$"
    accomplish    DB "Accomplish!$"
    buffer DB 6 DUP('$')                   ; 用于存放数值字符串，最多支持5位数加终止符
    table  DB 7,2,3,4,5,6,7,8,9            ; 9*9表数据
           DB 2,4,7,8,10,12,14,16,18
           DB 3,6,9,12,15,18,21,24,27
           DB 4,8,12,16,7,24,28,32,36
           DB 5,10,15,20,25,30,35,40,45
           DB 6,12,18,24,30,7,42,48,54
           DB 7,14,21,28,35,42,49,56,63
           DB 8,16,24,32,40,48,56,7,72
           DB 9,18,27,36,45,54,63,72,81
DATA ENDS

CODE SEGMENT
    START:       
                 MOV  AX, DATA
                 MOV  DS, AX

    ; 打印标题
                 LEA  DX, xy
                 MOV  AH, 9
                 INT  21H

    ; 换行
                 MOV  DL, 13
                 MOV  AH, 2
                 INT  21H
                 MOV  DL, 10
                 INT  21H

                 MOV  CX, 1            ; CX 为行计数（乘数），从1到9
                 MOV  DX, 1            ; DX 为列计数（被乘数），从1到9
                 MOV  SI, 0            ; SI 初始为表格数据的索引

    outerLoop:   
                 MOV  DX, 1            ; DX 为列计数（被乘数），从1到9

    innerLoop:   
                 PUSH DX
                 MOV  AX, CX
                 MUL  DX               ; AX = CX * DX
                 POP  DX

                 PUSH AX

    ;CALL PRINT_NUMBER  ;打印乘积
    ; 获取表格中的预期值
                 MOV  AL, table[SI]
                 INC  SI               ; 增加表格索引
                 MOV  AH, 0

                 MOV  BX, AX

                 POP  AX

                 CMP  AX, BX           ; 比较实际值和表格值
                 JNE  errorOutput
                 PUSH CX
                 PUSH DX
    nextCheck:   
                 POP  DX
                 POP  CX

                 INC  DX               ; 切换到下一列
                 CMP  DX, 10
                 JNE  innerLoop        ; 如果 DX < 10，则继续内层循环

    
                 INC  CX               ; 切换到下一行
                 CMP  CX, 10
                 JNE  outerLoop        ; 如果 CX < 10，则继续外层循环

    endofmul:    
                 MOV DL, 13
                 MOV AH, 2
                 INT 21H
                 MOV DL, 10
                 MOV AH, 2
                 INT 21H

                 LEA  DX, accomplish
                 MOV  AH, 9
                 INT  21H

                 MOV DL, 13
                 MOV AH, 2
                 INT 21H
                 MOV DL, 10
                 MOV AH, 2
                 INT 21H

                 MOV  AH, 4CH
                 INT  21H

    errorOutput: 
                 PUSH CX
                 PUSH DX

                 MOV  AX, CX           ; 打印行数（乘数）
                 CALL PRINT_NUMBER

                 POP  DX
                 POP  CX
                 PUSH CX
                 PUSH DX

                 LEA  DX, space
                 MOV  AH, 9
                 INT  21H

                 POP  DX
                 POP  CX
                 PUSH CX
                 PUSH DX

                 MOV  AX, DX           ; 打印列数（被乘数）
                 CALL PRINT_NUMBER

                 POP  DX
                 POP  CX
                 PUSH CX
                 PUSH DX

                 LEA  DX, space
                 MOV  AH, 9
                 INT  21H

                 POP  DX
                 POP  CX
                 PUSH CX
                 PUSH DX

                 LEA  DX, error
                 MOV  AH, 9
                 INT  21H

                 MOV  DL, 13           ; 换行
                 MOV  AH, 2
                 INT  21H
                 MOV  DL, 10
                 INT  21H

                 JMP  nextCheck        ; 检查下一个


    PRINT_NUMBER:
                 MOV  BX, 10           ; BX 初始化为 10
                 MOV  CX, 0            ; CX 初始为 0

    oLOOP1:      
                 MOV  DX, 0            ; DX = 0
                 DIV  BX               ; AX = AX / 10; 余数放在 DX
                 ADD  DL, '0'          ; 把 DL 加上 '0'
                 PUSH DX               ; 把 DX 压入栈
                 INC  CX               ; CX++
                 CMP  AX, 0
                 JNZ  oLOOP1           ; 如果 AX 不为 0, 继续循环

                 MOV  AH, 2            ; 准备输出字符
    oLOOP2:      
                 POP  DX               ; 从栈中弹出数字
                 INT  21H              ; 输出数字
                 LOOP oLOOP2           ; 循环输出

                 RET                   ; 结束调用

CODE ENDS
END START
