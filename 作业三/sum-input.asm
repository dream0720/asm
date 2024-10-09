.model small
.stack 100h

.data
    result db 0               
    NL     db 0Dh, 0Ah, '$'   
    prompt db 'Please input a number between 1 and 100, ended with `enter` : $'  
    error  db 'Wrong input! $'
    inputBuffer db 5 dup(0)   
    inputLen db 0             
    debug_msg1 db 'Debug: Current char = $', 0Dh, 0Ah, '$'
    debug_msg2 db 'Debug: Converted number = $', 0Dh, 0Ah, '$'

.code
main proc
    mov ax, @data              
    mov ds, ax

    ; 提示用户输入
    mov dx, OFFSET prompt      
    mov ah, 09h                
    int 21h                    

    ; 输入数字
    lea dx, inputBuffer        
    mov byte ptr [inputBuffer], 4 
    mov ah, 0Ah                
    int 21h                    

    ; 获取输入的实际长度
    mov cl, [inputBuffer + 1]  
    cmp cl, 0                  
    je .invalid_input          

    ; 转换输入字符串为数字
    xor bx, bx                 
    lea si, [inputBuffer + 2]  

.convert_loop:
    cmp cl, 0                  
    je .check_range            

    mov al, [si]               
    sub al, '0'                
    cmp al, 0                  
    jb .invalid_input          
    cmp al, 9                  
    ja .invalid_input          

    ; 打印当前字符
    mov dx, OFFSET debug_msg1  
    mov ah, 09h                
    int 21h                    
    mov dl, [si]               
    mov ah, 02h                
    int 21h                    
    ; 打印换行
    mov dx, OFFSET NL          
    mov ah, 09h                
    int 21h                    

    ; 将数字加到 bx 中
    mov dx, bx                 
    mov bx, 10                 
    mul bx                     
    add bx, ax                 
    inc si                     
    dec cl                     

    ; 调试：打印转换后的数字
    mov dx, OFFSET debug_msg2  
    mov ah, 09h                
    int 21h                    
    call PrintNum              
    ; 打印换行
    mov dx, OFFSET NL          
    mov ah, 09h                
    int 21h                    

    jmp .convert_loop          

.check_range:
    cmp bx, 1                  
    jb .invalid_input          
    cmp bx, 100                
    ja .invalid_input          

    ; 输出结果
    mov ax, bx                 
    call PrintNum              
    mov dx, OFFSET NL          
    mov ah, 09h                
    int 21h                    

.endofmain:
    ; 退出程序
    mov ax, 4C00h              
    int 21h                    

.invalid_input:
    mov dx, OFFSET NL          
    mov ah, 09h                
    int 21h                    
    mov dx, OFFSET error       
    mov ah, 09h                
    int 21h                    
    mov dx, OFFSET NL          
    mov ah, 09h                
    int 21h                    
    jmp .endofmain             

PrintNum proc                 
    xor cx, cx                 
    mov bx, 10                 

.next_digit:
    xor dx, dx                 
    div bx                      
    push dx                     
    inc cx                      
    test ax, ax                 
    jnz .next_digit            

.print_loop:
    pop dx                     
    add dl, '0'                
    mov ah, 02h                
    int 21h                    
    loop .print_loop           

    ret
PrintNum endp

main endp
end main
