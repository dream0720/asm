data segment 
    ; 表示21年的21个字符串，每个年份占4个字节
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    
    ; 表示21年公司总收入的21个dword型数据
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514 
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    
    ; 表示21年公司雇员人数的21个word型数据
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
    dw 11542,14430,15257,17800         
data ends 

table segment
    db 21 dup ('year summ ne ?? ')    ; 每条记录16字节
table ends 

stack segment stack
    db 256 dup(0)  ; 定义 256 字节的栈空间
stack ends

code segment
    assume cs:code, ds:data, es:table, ss:stack

    extrn show_num:proc   ; 声明外部过程
    
start:
    mov ax, stack
    mov ss, ax
    mov sp, 256

    mov ax, data
    mov ds, ax

    mov ax, table
    mov es, ax
    
    mov si, 0          ; 年份源
    mov di, 84         ; 收入源 (21*4 字节后的位置)
    mov bp, 168        ; 员工数源 (21*4 + 21*4 字节后的位置)
    mov bx, 0          ; table 目标位置

    mov cx, 21         ; 循环21年
process_data:
    push cx
    push si
    push di
    push bp
    push bx
    
    ; 复制年份 (4字节)
    mov cx, 4
copy_year:
    mov al, ds:[si]
    mov es:[bx], al
    inc si
    inc bx
    loop copy_year

    ; 复制收入 (4字节)
    mov ax, ds:[di]      ; 收入的低16位
    mov es:[bx], ax
    mov ax, ds:[di+2]    ; 收入的高16位
    mov es:[bx+2], ax
    add bx, 4

    ; 复制员工数 (2字节)
    mov ax, ds:[bp]
    mov es:[bx], ax
    add bx, 2

    ; 计算人均收入
    mov ax, ds:[di]      ; 收入低位
    mov dx, ds:[di+2]    ; 收入高位
    div word ptr ds:[bp] ; 除以员工数
    mov es:[bx], ax      ; 存储人均收入
    
    pop bx
    add bx, 16           ; 移动到下一条记录
    pop bp
    add bp, 2            ; 下一个员工数
    pop di
    add di, 4            ; 下一个收入
    pop si
    add si, 4            ; 下一个年份
    pop cx
    loop process_data



    ; 清屏操作
    mov ax, 0600h        ; 功能号 06h：滚屏窗口上移（全屏清除）
    mov bh, 07h          ; 背景黑色，文字灰色
    mov cx, 0            ; 左上角位置（行:列）
    mov dx, 184Fh        ; 右下角位置（24行，79列）
    int 10h              ; 调用 BIOS 中断


    ; 视频段初始化
    mov ax, table
    mov ds, ax           ; ds指向table段
    mov ax, 0B800H
    mov es, ax           ; es指向显存

    mov si, 0            ; table数据指针
    mov bx, 160*2        ; 从第2行开始显示，每行160字节

    mov cx, 21           ; 外层循环21行
next_row:
    push cx
    push si
    push bx

    ; 显示年份(4字节)
    mov cx, 4
    add bx, 8
show_year:
    mov al, [si]
    mov ah, 02h          ; 绿色属性
    mov es:[bx], ax
    add bx, 2
    inc si
    loop show_year

    add bx, 24            ; 列间距

    ; 显示收入(4字节)
    push dx
    mov ax, [si]
    mov dx, [si+2]
    call show_num
    add si, 4
    add bx, 48           ; 列间距

    ; 显示人数(2字节)
    mov ax, [si]
    mov dx, 0
    call show_num
    add si, 2
    add bx, 48           ; 列间距

    ; 显示人均收入(2字节)
    mov ax, [si]
    mov dx, 0
    call show_num

    pop bx
    add bx, 160          ; 下一行
    pop si
    add si, 16           ; 下一条记录
    pop cx
    loop next_row

    mov ax, 4c00h
    int 21h



code ends
END start
