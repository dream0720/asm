.model small
.stack 100h

.data
    result dw 0               ; 用于存储最终结果
    NL     db 0Dh, 0Ah, '$'   ; 换行符

.code
main proc
    mov ax, @data              ; 初始化数据段
    mov ds, ax

    ; 初始化变量
    mov cx, 1                  ; 计数器从 1 开始
    mov bx, 0                  ; 和从 0 开始

.loop:
    add bx, cx                 ; 将当前计数器加到和上
    inc cx                     ; 计数器加 1
    cmp cx, 101                ; 如果计数器达到 101
    jl  .loop                  ; 继续循环

    ; 第一种方式：将结果放在寄存器中打印
    mov ax, bx                 ; 将和放入 ax
    call PrintNum              ; 调用打印数字的子程序
    mov dx, OFFSET NL          ; 打印换行
    mov ah, 09h                ; 设置功能号为打印字符串
    int 21h                    ; 调用 DOS 中断

    ; 退出程序
    mov ax, 4C00h              ; 功能号：退出
    int 21h                    ; 调用 DOS 中断

PrintNum proc                  ; 打印数字的子程序
    xor cx, cx                 ; 清除 cx，准备计数
    mov bx, 10                 ; 除数为 10

.next_digit:
    xor dx, dx                 ; 清除 dx
    div bx                      ; ax 除以 10，商在 ax，余数在 dx
    push dx                    ; 保存余数
    inc cx                     ; 计数器加 1
    test ax, ax                ; 检查 ax 是否为 0
    jnz .next_digit            ; 如果不为 0，继续循环

.print_loop:
    pop dx                     ; 恢复余数
    add dl, '0'                ; 转换为字符
    mov ah, 02h                ; DOS 输出字符功能
    int 21h                    ; 调用 DOS 中断
    loop .print_loop           ; 打印所有数字

    ret
PrintNum endp

main endp
end main
