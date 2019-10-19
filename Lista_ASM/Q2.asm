org 0x7c00



e1 times 50 db 'x'
e2 times 50 db 'x'
jmp 0x0000:main
scanf:

    mov ah, 0x00;pega entrada
    int 16h

    cmp al, 13
    je sera
    cmp al, 8
    je backspace
    call putchar
    sub al, 48
    stosb
    inc cl
    jmp scanf
    ret

backspace:
    cmp cl, 0
    je scanf
    dec di
    dec cl
    mov byte[di], 'x'
    call delchar
    jmp scanf

delchar:
    mov al, 8
    call putchar
    mov al,''
    call putchar
    mov al, 8
    call putchar
    ret

putchar:
    mov ah, 0x0e
    ;add al, 48
    int 10h
    ret

endl:
    mov al, 'x'
    stosb
    mov al, 10
    call putchar
    mov al, 13
    call putchar
    ret

sera:
    cmp cl, 0
    je scanf
    call endl

store:
    mov al, 'x'
    stosb
    ret

printf:
    lodsb
    ;add ax, 48
    cmp al, 'x'
    je finish
    ;cmp cl, 0
    ;je finish
    ;add ax, 48
    mov ah, 0eh
    int 10h
    jmp printf

finish:
    ret

converte:
    lodsb
    cmp al, 'x'
    je finish
    ;add ax, 2
    ;push bx
    ;mov bl, 15
    ;call putchar
    ;pop bx

    mov dx, ax
    mov al, 10
    mov ah,0
    mul cl
    add al, dl
    mov cl, al
   
    jmp converte

gcd:
    mov si, e2
    lodsb
    mov cx, ax;bota E2 NO BX
    
    ;lodsb
    ;mov ah, 0eh
    ;add al,48
    ;int 10h
    
    

    mov si, e1
    lodsb; BOTA E1 NO AX
    ;mov ah, 0eh
    ;add al,48
    ;int 10h
    ;mov bx, e2
    mov dx, 1
    euc_alg:
      
      mov dx, 0h
      div cx ;ax = ax/bx
      cmp dx, 0 ; o resto eh zero?
      je result
      mov ax, cx ; o ax recebe o menor
      mov cx, dx ; o bx recebe o resto
      ;mov ax, dx
        
      jmp euc_alg


result:
   mov ax, cx
   ;add al,-251
    add al, 48
   ;add al,49
   ;call putchar
   sub al,48
    ;jmp $
    ret
    


set_videomode:
    mov ah, 0 ;escolhe modo video
    mov al, 12h ;modo VGA
    int 10h

    mov ah, 0xb ;scolhe cor da tela
    mov bh, 0
    mov bl, 0 ;cor da tela
    int 10h

    mov ah, 0xe ;escolhe cor da letra
    mov bh, 0   ;numero da pagina
    mov bl, 0xf ;cor branca da letra

    ret

tostring: ; ax = 4
;push di
mov di, e1
;mov cx, 0
.loop1:

cmp ax, 0
je .endloop1
xor dx, dx
mov bx, 10
;mov cx, ax
;mov ah,0
div bx ; ax = 999, dx = 9

;call putchar
xchg ax, dx; swap ax, dx

add ax, 48 ; 9 + '0' = '9'
;call putchar
;call putchar
stosb

xchg ax, dx
jmp .loop1
.endloop1:
 
    .done:
    mov al, 'x'
    stosb
    mov si,e1
    call reverse
    ret
reverse:
mov di, e2
xor cx, cx ; zerar contador
.loop1:
lodsb
cmp al, 'x'
je .endloop1
inc cl
push ax
jmp .loop1
.endloop1:
    ;reverse:
    .loop2:
    cmp cl, 0
    je .endloop2
    dec cl
    pop ax
    stosb
    jmp .loop2
    .endloop2:
    mov al,'x'
    stosb
    ret
main:
    xor ax, ax
    mov ds, ax
    mov es, ax

    call set_videomode

    ;mov ax, 97
    ;int 10h

    xor cx, cx
    mov di,e1
    ;mov dmov bx, e2i, e1
    call scanf
    mov si, e1
    ;call printf

    xor cx, cx
    ;mov al, '0' ;teste do printf
    ;int 10h
    ;mov si,e1
    ;call printf
    call converte
   

    mov ax, cx
    mov di,e1
    
    stosb
    mov si, e2
   
    
    mov di, e2
    xor cx, cx
    call scanf
    xor cx, cx
    call converte
  
    
    ;mov al, '$' ;teste do printf
    ;int 10h
    mov ax, cx
    mov di, e2
    
    stosb
    mov si,e2
    lodsb
     
   ; mov ah, 0eh
    ;add al,48
    ;int 10h
     
  
    call gcd
        ;push bx
    ;mov bl, 15
    ;call putchar
    ;pop bx
    call tostring
    mov si,e2
    call printf


  times 510-($-$$) db 0
dw 0xaa55
