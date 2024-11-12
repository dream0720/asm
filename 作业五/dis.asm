data segment
    ; 如果有需要的数据，可以在这里定义
data ends

code segment
    assume cs:code, ds:data

; 声明需要对外公开的过程
public show_num

show_num proc
    push ax
    push bx
    push cx
    push dx
    push si
    push bp
    
    mov si, bx          ; 保存显存位置指针
    mov bp, 0           ; 用bp记录位数
    
digit_to_str:
    mov cx, 10          ; 除数为10
    call divdw          ; 调用不会溢出的除法
    push cx             ; 余数入栈
    inc bp             ; 位数加1
    
    ; 检查商是否为0
    mov cx, ax         
    or cx, dx          ; 检查高低位
    jnz digit_to_str   ; 不为0继续循环
    
    mov cx, bp         ; cx = 位数，用于loop
    
show_digit:
    pop dx              ; 取出数字
    add dl, 30h         ; 转ASCII
    mov dh, 03h         ; 设置绿色属性
    mov es:[si], dx     ; 写入显存
    add si, 2           ; 移动显存指针
    loop show_digit     ; 循环显示
    
    mov bx, si          ; 保存新的显存位置
    
    pop bp
    pop si 
    pop dx
    pop cx
    pop bx
    pop ax
    ret
show_num endp

divdw:
	push bx

	push ax
	mov ax, dx	;高16位
	mov dx, 0
	div cx		;除数
	mov bx, ax	;bx = int(H/N)	dx = rem(H/N)
	pop ax		;低16位
	div cx		;(rem(H / N) * 10000H + L ) / N
	mov cx, dx	;余数
	mov dx, bx	;dx = int(H/N)

	pop bx
	ret

code ends
end