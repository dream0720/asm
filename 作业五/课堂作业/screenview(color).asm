ASSUME CS:code

data segment             ; 数据段
    db 'Welcome to masm!'           ; 保存字符串
    db 00000010B, 00100100B, 01110001B ; 保存三种颜色形式
data ends

stack segment            ; 栈段
    db 128 dup(0)
stack ends            

code segment
start:
    ; 清屏操作
    mov ax, 0600h        ; 功能号 06h：滚屏窗口上移（全屏清除）
    mov bh, 07h          ; 背景黑色，文字灰色
    mov cx, 0            ; 左上角位置（行:列）
    mov dx, 184Fh        ; 右下角位置（24行，79列）
    int 10h              ; 调用 BIOS 中断

    ; 数据段初始化
    mov ax, data
    mov ds, ax            ; ds指向数据段

    ; 栈段初始化
    mov ax, stack
    mov ss, ax
    mov sp, 128           ; 创建栈段

    ; 视频段初始化
    mov ax, 0B800H
    mov es, ax            ; es控制打印的屏幕
    
    ; 指针和偏移量初始化
    mov si, 0             ; si控制字符串数据的起始位置
    mov di, 0010h         ; di控制颜色属性的起始位置
    mov bx, 160*10+30*2   ; bx控制打印在屏幕上的位置

    mov cx, 3             ; 控制外层循环次数，即打印的行数
    ; 入栈保存初始位置和颜色属性
s0: push di
    push si
    push cx
    push bx

    ; 内层循环，打印16个字符
    mov cx, 16            ; 一次打印循环次数
    mov dh, ds:[di]       ; 高位字节存放属性，dh存放颜色属性

s:  mov dl, ds:[si]       ; 低位字节存放数据，dl存放字符数据
    mov es:[bx], dx       ; 把字符和属性一起存放在屏幕缓冲区中
    inc si                ; 字符数据移动
    add bx, 2             ; 一个字符打印在屏幕上占两个字节，所以要加2
    loop s                ; 内层循环

    ; 恢复出栈顺序
    pop bx
    pop cx
    pop si
    pop di

    add bx, 160           ; 换行，增加160个字节的偏移
    inc di                ; 更新颜色属性偏移
    loop s0               ; 外层循环

    ; 程序结束
    mov ax, 4c00H
    int 21h
code ends
end start
