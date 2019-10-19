;call putchar
org 0x7c00
jmp 0x0000:_start
vezes times 10 db 0
num times 5 db 0
entrada times 50 db 0
resposta times 50 db 0

_start:
    xor ax, ax
    mov cx, 0
    mov dx, 0
    mov ds, ax
    mov es, ax
    mov di, vezes

    call set_videomode
    mov di, num
    call gets
    call set_videomode

    call quantasVezes
    mov si, vezes; pega o numero de vezes
    ;sub [si], 2
    lodsb
    mov bh, al ;da para cl o numero de vezes
    call loop_String
    jmp $

loop_String:
;cmp bl, 0
;je .end
cmp bh, 0
je .end
    mov di, entrada ;PEGA A ENTRADA
    call gets ; GUARDAA ENTRADA
    mov si, entrada ;PASSA A ENTRADA PARA O SI
    mov dx,0 ; TAMANHO DA PILHA
    dec bh
    call empilha_E_Testa
    ;mov al, '0'
  ;call putchar

   ;cmp dx,0
   ;je sim
   ;jmp esvazia

    .end:
      ret
sim:
    mov al,'S'
    call putchar
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    jmp loop_String
esvazia:
  pop ax
  ;call putchar
  dec dx
  cmp dx, 0
  je nao
  jmp esvazia
nao:
    mov al ,'N'
    call putchar
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    jmp loop_String

empilha_E_Testa:
;mov al, 'M'
    lodsb
    cmp al, ' '
    je empilha_E_Testa
    ;call putchar

    cmp al, 0;se chegou no final
    je .done;loop_String
    ;call putchar
    cmp dx,0; se ta vazia
    je so_empilha
    ;call putchar
    mov cl, al;guada oq ta na entrada
    pop ax;tira oq ta na pilha e bota no ax
    ;call putchar
    cmp al,'{';ve q tnha na pilha
    je testa1
    cmp al,'(';ve oq tinha na pilha
    je testa2
    cmp al,'[';ve oq tiha na pilha
    je testa3
     jmp .done

    jmp empilha_E_Testa

    .done:
      cmp dx,0
      je sim
      jmp esvazia
        ret
testa1:
    cmp cl, '}'
    je ok
    push ax
    push cx
    inc dx
    jmp empilha_E_Testa

testa2:
    cmp cl,')'
    je ok
    push ax
    push cx
    inc dx
    jmp empilha_E_Testa

testa3:
    cmp cl, ']'
    je ok
    push ax
    push cx
    inc dx
    jmp empilha_E_Testa

ok:
    dec dl
    jmp empilha_E_Testa

so_empilha:
    push ax;coloca o ax na pilha
    inc dx
    jmp empilha_E_Testa

quantasVezes:
    ;DEERMINA O NUMERO DE VEZES QUE O PRORAMA VAI RODAR
    mov di,vezes
    cmp cx, 2
    je setaDez
    jmp setaMenosDez


setaMenosDez:;SE FOR MENOS DE 10 VAI SER O VARIAVEL -'0'
  mov si, num
  lodsb
  sub al, 48
  stosb
  ret

setaDez:;SE FOR 10 SETA O 10
  mov al, 10
  ;add al,47
  ;call putchar
  stosb
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
    je sera
    cmp cl, 100
    je loop1

    stosb
    inc cl
    call putchar

    jmp loop1

sera:
    cmp cl, 0
    je loop1
    jmp done

done:
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

times 510 - ($ - $$) db 0
dw 0xaa55 ; assinatura de boot
