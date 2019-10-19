org 0x7c00
jmp 0x0000:_start

input times 50 db 0

diferente db 'NAO EXISTE', 0
red db 'vermelho', 0
green db 'verde', 0
yellow db 'amarelo', 0
blue db 'azul', 0


_start:
    xor ax, ax
    mov cx, ax
    mov ds, ax
    mov es, ax

    call set_videomode

    mov di, input
    call gets

    call set_videomode

    ;---------- prova que a string tá sendo pega 
    ;mov di, input
    ;mov al, [di]
    ;int 10h
    ;inc di
    ;mov al, [di]
    ;int 10h
    ;call done
    ;----------------
    mov di, input
    mov si, red
    call compara
    cmp cx, 1
    je case_red

    mov di, input
    mov si, yellow
    call compara
    cmp cx, 1
    je case_yellow

    mov di, input
    mov si, green
    call compara
    cmp cx, 1
    je case_green

    mov di, input
    mov si, blue
    call compara
    cmp cx, 1
    je case_blue

    call nope




;final da main

compara:

    compara_loop:
        mov al, [di]
        mov bl, [si]
        cmp al, 0
        je checkout
        cmp al, bl
        jne retorna

        inc si
        inc di
        jmp compara_loop
    printa:
        mov cx, 1
    retorna: 
        ret
    checkout:
        cmp bl, 0
        je printa
        ret

nope:
    mov si, diferente
    nope_loop:
        lodsb
        cmp al, 0
        je done

        mov ah, 0xe
        mov bh, 0
        mov bl, 5
        int 10h
        jmp nope_loop

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


putchar:
    mov ah, 0eh ;modo de imprmir na tela
    int 10h ;imprime o que tá em al
    ret
;função que coloca um único caracter na tela

delchar:
    mov al, 8 ;8 = backspace
    call putchar
    mov al,''
    call putchar
    mov al, 8
    call putchar
    ret
;função que deleta último caracter colocado por putchar

getchar:
    mov ah, 00h ;modo de leitura do teclado
    int 16h ;recebe o que foi teclado
    ret
;função que coleta um único caracter do teclado

endl:
    mov al, 10 ;10 = nova linha
    call putchar
    mov al, 13 ;13 = carriage return
    call putchar
    ret
;função que coloca uma nova linha na tela

backspace:
    cmp cl, 0
    je loop1
    dec di
    dec cl
    mov byte[di], 0
    call delchar
    jmp loop1

gets:
    xor cx, cx
    loop1:
        call getchar
        cmp al, 8
        je backspace
        cmp al, 13
        je .done
        cmp cl, 100
        je loop1

        stosb
        inc cl
        call putchar

        jmp loop1
.done:
    mov al, 0
    stosb
    call endl
    ret

case_red:
    mov si, red
    print_red:
        lodsb
        cmp al, 0
        je done

        mov ah, 0xe
        mov bh, 0
        mov bl, 12
        sub al, 32
        int 10h
        jmp print_red

case_yellow:
    mov si, yellow
    print_yellow:
        lodsb
        cmp al, 0
        je done

        mov ah, 0xe
        mov bh, 0
        mov bl, 14
        sub al, 32
        int 10h
        jmp print_yellow

case_green:
    mov si, green
    print_green:
        lodsb
        cmp al, 0
        je done

        mov ah, 0xe
        mov bh, 0
        mov bl, 2
        sub al, 32
        int 10h
        jmp print_green

case_blue:
    mov si, blue
    print_blue:
        lodsb
        cmp al, 0
        je done

        mov ah, 0xe
        mov bh, 0
        mov bl, 9
        sub al, 32
        int 10h
        jmp print_blue

done:
    jmp $ ; $ = linha atual
 


times 510 - ($ - $$) db 0
dw 0xaa55 ; assinatura de boot
