;Jogo da memoria - kernel
org 0x8600
jmp 0x0000:main

msg db 'Digite ENTER para continuar', 0
limpa db '                           ', 0
win db 'VOCE GANHOU!!!!!!', 0
acertou db 'VOCE ACERTOU', 0, 10
errou db 'VOCE ERROU',0 , 10
choice db 100
escolha db 100, 100
stf db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;guarda status das cartas
cartas db 5, 1, 3, 2, 4, 5, 2, 1, 3, 4 ;guarda id/posicao da cartas
cont db 10
fundo db   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 9, 9, 11, 11, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 9, 9, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 9, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 9, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4

com_linha dw 48
com_coluna dw 48

com_linha_var dw 48
com_coluna_var dw 48


deslocamento dw 50

fim_linha dw 1
fim_coluna dw 1

fim_linha_var dw 1
fim_coluna_var dw 1

main:



mov ax,[com_linha]
  mov word[com_linha_var], ax
  add ax,40
  mov word[fim_linha_var], ax
  mov word[fim_linha], ax

  mov ax,[com_coluna]
  mov word[com_linha_var],ax
  add ax,40
  mov word[fim_coluna], ax
  mov word[fim_coluna_var],ax

  xor ax, ax
  mov ds, ax
  mov es, ax

  
  call set_mode
  call printa_deck  
  call printa_num
  call printa_cursor
  call getchar

  mov ah, 0Ch
  jmp $
n
printf:
  lodsb
  cmp al, 0
  je finish
  mov ah, 0eh
  int 10h
  jmp printf
  ret

finish:
  ret

printa_cursor:
  mov ah,02h
  mov dl,15    ;column
  mov dh,2
  int 10h
  mov si, limpa
  call printf

  mov ah,02h
  mov dl,5    ;column
  mov dh,0
  int 10h
  mov si, limpa
  call printf
  .loop1:
    mov di, escolha
    cmp byte[di], 100
    je .primeiro
    inc di
    cmp byte[di], 100
    je .segundo
  .a:
    call getchar
    cmp al, '0'
    je .zero
    cmp al, '1'
    je .um
    cmp al, '2'
    je .dois
    cmp al, '3'
    je .tres
    cmp al, '4'
    je .quatro
    cmp al, '5'
    je .cinco
    cmp al, '6'
    je .seis
    cmp al, '7'
    je .setee
    cmp al, '8'
    je .oito
    cmp al, '9'
    je .nove
    cmp al, 13
    je .select
    cmp al, 'b'
    je 0x7E00
    jmp .loop1
  .um:
    mov al, '1'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .dois:
    mov al, '2'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .tres:
    mov al, '3'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .quatro:
    mov al, '4'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .cinco:
    mov al, '5'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .seis:
    mov al, '6'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .setee:
    mov al, '7'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .oito:
    mov al, '8'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .nove:
    mov al, '9'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .zero:
    mov al, '0'
    call putchar
    add al, -48
    mov [choice], al
    jmp .loop1
  .select:
    cmp byte[choice], 100
    jne .salva
    jmp .loop1
  .salva:
    xor dh, dh
    mov si, stf
    mov al, [choice]
    dec si
    dec dh
    .lop:
      inc si
      inc dh
      cmp dh, al
      jne .lop
    cmp byte[si], 2
    je .loop1
    mov di, escolha
    cmp byte[di], 100
    je .salvaum
    mov al, [choice];confere se a nova carta escolhida nao eh igual a anterior
    cmp byte[di], al
    je .loop1
    inc di
    cmp byte[di], 100
    je .salvadois
    jmp .loop1
  .salvaum:
    mov ah,02h
    mov dl,21    ;column
    mov dh,0
    int 10h
    mov al, ' '
    call putchar

    mov ah,02h
    mov dh,24    ;row
    mov dl,22    ;column
    int 10h
    mov al, ' '
    call putchar

    mov al, [choice]
    mov [di], al
    xor dh, dh
    mov si, stf
    dec si
    dec dh
    .b:;muda status da carta
      inc si
      inc dh
      cmp dh, al
      jne .b
    mov byte[si], 1
    call printa_deck
    jmp .loop1
  .salvadois:
    mov al, [choice]
    mov [di], al
    xor dh, dh
    mov si, stf
    dec si
    dec dh
    .c:;muda status da carta
      inc si
      inc dh
      cmp dh, al
      jne .c
    mov byte[si], 1
    call printa_deck
    jmp verifica
  .primeiro:
    mov ah,02h
    mov dh,24    ;row
    mov dl,20    ;column
    int 10h
    jmp .a
  .segundo:
    mov ah,02h
    mov dh,24    ;row
    mov dl,22    ;column
    int 10h
    jmp .a
  ret

printa_deck:
 ; mov si, stf
 ; xor cl, cl
  ;mov dh, 10   ;row
  ;mov dl, 5     ;column

  pusha
mov di,stf
xor bx,bx

mov cx,[fim_coluna]
mov [fim_coluna_var],cx
mov cx,[fim_linha]
mov [fim_linha_var],cx
mov cx, [com_coluna] ;coluna
mov [com_coluna_var],cx
mov dx, [com_linha];linha
mov [com_linha_var],dx
mov ah, 0Ch
;isso daqui determina que vc vai printar as cartas inicialmente da primeira posicao

printa_cartas:
      mov si, fundo
      mov cx, [com_coluna_var] ;coluna ;pega a coluna atual
      mov dx, [com_linha_var];linha pega a linha atual
      mov ah, 0Ch
      
laco:
  lodsb
  
  mov di,stf
  add di,bx
  

  cmp byte[di],0
  je pinta
  
  mov di, cartas
  add di,bx
  add al,[di]
  ;add al,5;determina cor da peça
  pinta:
  int 10h
  inc cx
  cmp cx, [fim_coluna_var]
  je compara_eh_quinze
  jmp laco

 done:
inc bx
mov cx, [com_coluna_var] ;coluna
add cx, [deslocamento]
mov  [com_coluna_var],cx ;coluna
mov cx, [fim_coluna_var] 
add cx, [deslocamento]
mov  [fim_coluna_var],cx ;coluna
cmp bx,5
jl printa_cartas

cmp bx,5
je aumenta_linha

cmp bx, 10
jl printa_cartas
popa
ret

aumenta_linha:
mov dx, [com_linha_var];linha
add dx,[deslocamento]
mov  [com_linha_var],dx;linha
mov dx, [fim_linha_var];linha
add dx,[deslocamento]
mov  [fim_linha_var],dx;linha

mov dx, [com_coluna]
mov [com_coluna_var],dx

mov dx, [fim_coluna]
mov [fim_coluna_var],dx

jmp printa_cartas


compara_eh_quinze:
 
  mov cx, [com_coluna_var]
  inc dx
  cmp dx, [fim_linha_var]
  je done

  jmp laco

verifica:;verifica se as cartas escolhidas sao iguais
  mov si, cartas
  mov al, [escolha]
  xor dh, dh
  dec si
  dec dh
  .loop1:;anda pelo cartas ate chegar na posicao do escolha
    inc si
    inc dh
    cmp dh, al
    jne .loop1
  mov cl, [si]
  
  xor dh, dh
  mov si, cartas
  mov al, [escolha+1]
  dec si
  dec dh
  .loop2:
    inc si
    inc dh
    cmp dh, al
    jne .loop2
  mov ch, [si]
  
  cmp ch, cl
  je .acertou
  jmp .errou
  .acertou:
    mov ah,02h
    mov dl,15    ;column
    mov dh,2
    int 10h
    mov bl, 2
    mov si, acertou
    call printf

    mov ah,02h
    mov dl,5    ;column
    mov dh,0
    int 10h
    mov bl, 15
    mov si, msg
    call printf

    mov ah,02h
    mov dl,0    ;column
    mov dh,24
    int 10h
    mov si, limpa
    call printf

    call getchar
    mov dl,5 
    cmp al, 13
    jne .acertou

    xor dh, dh
    mov si, stf
    mov al, [escolha]
    dec si
    dec dh
    .lop:
      inc si
      inc dh
      cmp dh, al
      jne .lop
    mov byte[si], 2
    xor dh, dh
    mov si, stf
    mov al, [escolha+1]
    dec si
    dec dh
    .e:
      inc si
      inc dh
      cmp dh, al
      jne .e
    mov byte[si], 2
    call printa_deck

    mov byte[escolha], 100
    mov byte[escolha+1], 100
    mov byte[choice], 100
    add byte[cont], -2

    mov ah,02h
    mov dl,15    ;column
    mov dh,0
    int 10h
    mov si, acertou
    call printf

    cmp byte[cont], 0
    jne printa_cursor
    call set_videomode
    call set_mode2

    mov ah,02h
    mov dl,12    ;column
    mov dh,11
    int 10h
    mov si, win
    call printf

    .malu:
      call getchar
      cmp al, 13
    jne .malu
    jmp 0x7E00

    ret
  .errou:;reseta o status das cartas
    mov ah,02h
    mov dl,15    ;column
    mov dh,2
    int 10h
    mov si, errou
    mov bl, 4
    call printf

    mov ah,02h
    mov dl,5    ;column
    mov dh,0
    int 10h
    mov bl, 15
    mov si, msg
    call printf

    mov ah,02h
    mov dl,0    ;column
    mov dh,24
    int 10h
    mov si, limpa
    call printf

    call getchar
    mov dl,5 
    cmp al, 13
    jne .errou
    xor dh, dh
    mov si, stf
    mov al, [escolha]
    dec si
    dec dh
    .lops:
      inc si
      inc dh
      cmp dh, al
      jne .lops
    mov byte[si], 0
    xor dh, dh
    mov si, stf
    mov al, [escolha+1]
    dec si
    dec dh
    .es:
      inc si
      inc dh
      cmp dh, al
      jne .es
    mov byte[si], 0
    call printa_deck
    
    mov byte[escolha], 100
    mov byte[escolha+1], 100
    mov byte[choice], 100
    jmp printa_cursor
    ret

  ret

set_mode:
  mov ah, 0 ;escolhe modo video
  mov al, 13h ;modo VGA
  int 10h

  mov ah, 0xb ;scolhe cor da tela
  mov bh, 0
  mov bl, 3 ;cor da tela
  int 10h

  mov ah, 0xe ;escolhe cor da letra
  mov bh, 0   ;numero da pagina
  mov bl, 0xf ;cor branca da letra
  ret

set_mode2:
  mov ah, 0 ;escolhe modo video
  mov al, 13h ;modo VGA
  int 10h

  mov ah, 4 ;scolhe cor da tela
  mov bh, 0
  mov bl, 3 ;cor da tela
  int 10h

  mov ah, 0xe ;escolhe cor da letra
  mov bh, 0   ;numero da pagina
  mov bl, 0xf ;cor branca da letra
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

putchar:
  mov ah, 0eh ;modo de imprmir na tela
  int 10h ;imprime o que tá em al
  ret

getchar:
  mov ah, 00h
  int 16h
  ret

printa_num:
  mov ah,02h
  mov dh,4    ;row
  mov dl,8     ;column
  int 10h
  mov al,'0'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,14     ;column
  int 10h
  mov al,'1'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,20    ;column
  int 10h
  mov al,'2'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,27     ;column
  int 10h
  mov al,'3'
  call putchar
  

  mov ah,02h
  mov dh,4    ;row
  mov dl,33  ;column
  int 10h
  mov al,'4'
  call putchar
  
  
  mov ah,02h
  mov dh,18    ;row
  mov dl,8     ;column
  int 10h
  mov al,'5'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,14     ;column
  int 10h
  mov al,'6'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,20    ;column
  int 10h
  mov al,'7'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,27     ;column
  int 10h
  mov al,'8'
  call putchar
  

  mov ah,02h
  mov dh,18    ;row
  mov dl,33  ;column
  int 10h
  mov al,'9'
  call putchar

  ret

exit:
