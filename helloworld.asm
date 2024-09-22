.MODEL small              ; 使用 small 内存模型
.STACK 100h               ; 设置堆栈大小
.DATA
    msg db 'Hello, World!$'  ; 定义字符串，以 '$' 结束

.CODE
main PROC
    mov ax, @data         ; 将数据段地址加载到 AX
    mov ds, ax            ; 设置数据段寄存器

    mov ah, 09h           ; DOS 中断 21h，功能号 09h (显示字符串)
    lea dx, msg           ; 加载字符串地址到 DX
    int 21h               ; 调用 DOS 中断

    mov ax, 4C00h         ; DOS 终止程序中断 (功能号 4Ch)
    int 21h               ; 调用 DOS 中断
main ENDP
END main
