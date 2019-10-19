org 0x7c00
jmp 0x0000:_begin

input1 times 100 db 0
input2 times 100 db 0
yes db 'sim', 0
no db 'nao', 0

current times 10 db 0


_begin:
    xor ax, ax
    mov cx, ax
    mov ds, ax
    mov es, ax
    
    call set_videomode

    mov di, input1
    call gets

    mov di, input2
    call gets

    mov di, input1
    mov si, input2

    call set_videomode

    call isok

    ;--------------- prova que as strings estão sendo pegas -----------------
    ;mov si, input1
    ;mov dl, 4
    ;call printf
    ;
    ;mov si, input2
    ;mov dl, 10
    ;call printf
    ;------------------------------------------------------------------------

    jmp done

isok:
    mov dl, [di]
    
    loop_isok:            
        lodsb
        cmp dl, 0
        je sim
        cmp al, 0
        je nao
        cmp al, dl
        je .aumenta_di

        jmp loop_isok

    .aumenta_di:
        inc di
        jmp isok


sim:
    mov si, yes

    sim_loop:
        lodsb

        cmp al, 0
        je done

        call putchar

        jmp sim_loop

nao:
    mov si, no

    nao_loop:
        lodsb

        cmp al, 0
        je done
        
        call putchar

        jmp nao_loop


printf:
    lodsb
    cmp al, 0
    je return
    
    mov ah, 0xe
    mov bh, 0
    int 10h
    jmp printf


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

backspace:
    cmp cl, 0
    je loop1
    dec di
    dec cl
    mov byte[di], 0
    call delchar
    jmp loop1

endl:
    mov al, 10 ;10 = nova linha
    call putchar
    mov al, 13 ;13 = carriage return
    call putchar
    ret
;função que coloca uma nova linha na tela

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

return: 
    ret

done:
    jmp $ 

times 510 - ($ - $$) db 0
dw 0xaa55 ; assinatura de boot
