;Jogo da Memoria
org 0x7E00
jmp 0x0000:start
data:
titulo db 'JOGUITO DA MEMORIA', 0
play db 'Play', 0
help db 'Help', 0
cred db 'Creditos', 0
n1 db 'Felipe Nunes (fnap)', 0
n2 db 'Marcelo Victor (mvbs3)', 0
n3 db 'Maria Luisa Lima (mlll)', 0
arrow db '>', 0
l1 db 'Digite um numero de 0-9 para selecionar uma carta e pressione enter para escolhe-la', 0
l3 db 'O objetivo eh combinar as pecas iguais.', 0
l4 db 'O jogo continua ate voce encontrar todosos pares.', 0
l5 db 'Pressione b para voltar ao menu a qual- quer momento.', 0


set_videomode:
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

start:
  xor ax, ax
  mov cx, ax
  mov ds, ax
  mov es, ax

	call set_videomode

  call printa_titulo
  call printa_play
  call printa_help
  call printa_cred
  call tela_up

  jmp $

tela_up:
  call apaga_arrow_down
  call apaga_arrow_middle
  call printa_arrow_up
  call getchar
  cmp al, 13
  je jogo
  cmp al, 's'
  je tela_middle
  jmp tela_up
  ret

tela_down:
  call apaga_arrow_up
  call apaga_arrow_middle
  call printa_arrow_down
  call getchar
  cmp al, 13
  je tela_cred
  cmp al, 'w'
  je tela_middle
  jmp tela_down
  ret

tela_middle:
  call apaga_arrow_up
  call apaga_arrow_down
  call printa_arrow_middle
  call getchar
  cmp al, 13
  je tela_help
  cmp al, 'w'
  je tela_up
  cmp al, 's'
  je tela_down
  jmp tela_middle
  ret

printa_titulo:
  mov ah,02h
  mov dh,3    ;row
  mov dl,10     ;column
  int 10h

  mov si, titulo
  call printf
  ret

printa_play:
  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, play
  call printf
  ret

printa_help:
  mov ah,02h
  mov dh,12    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, help
  call printf
  ret

printa_cred:
  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, cred
  call printf
  ret

printa_arrow_up:
  mov ah,02h
  mov dh,10    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov si, arrow
  call printf

  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 3
  int 10h

  mov si, play
  call printf
  ret

  printa_arrow_middle:
    mov ah,02h
    mov dh,12    ;row
    mov dl,13     ;column
    mov bl, 4
    int 10h

    mov si, arrow
    call printf

    mov ah,02h
    mov dh,12    ;row
    mov dl,15     ;column
    mov bl, 3
    int 10h

    mov si, help
    call printf
    ret

printa_arrow_down:
  mov ah,02h
  mov dh,14    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov si, arrow
  call printf

  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 3
  int 10h

  mov si, cred
  call printf
  ret

tela_help:

	call set_videomode

	mov ah,02h
	mov dh,1 ;row
	mov dl,17 ;column
	mov bl,10
	int 10h

	mov si, help
	call printf

  mov ah,02h
	mov dh,4 ;row
	mov dl,0 ;column
	mov bl,2
	int 10h

	mov si, l1
	call printf

  mov ah,02h
  mov dh,9 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, l3
  call printf

  mov ah,02h
  mov dh,13 ;row
  mov dl,0 ;column
  mov bl,2
  int 10h

  mov si, l4
  call printf

  mov ah,02h
  mov dh,20 ;row
  mov dl,0 ;column
  mov bl,3
  int 10h

  mov si, l5
  call printf

	call getchar
    cmp al, 'b'
    je start
	jmp tela_help

tela_cred:
  call set_videomode

  mov ah,02h
  mov dh,1 ;row
  mov dl,15 ;column
  mov bl,1
  int 10h

  mov si, cred
  call printf

  mov ah,02h
  mov dh,4 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, n1
  call printf

  mov ah,02h
  mov dh,9 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, n2
  call printf

  mov ah,02h
  mov dh,14 ;row
  mov dl,5 ;column
  mov bl,3
  int 10h

  mov si, n3
  call printf

  call getchar
    cmp al, 'b'
    je start
  jmp tela_cred

apaga_arrow_down:
  mov ah,02h
  mov dh,14    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov al, ' '
  call putchar


  mov ah,02h
  mov dh,14    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, cred
  call printf
  ret

apaga_arrow_middle:
  mov ah,02h
  mov dh,12    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov al, ' '
  call putchar


  mov ah,02h
  mov dh,12    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, help
  call printf
  ret

apaga_arrow_up:
  mov ah,02h
  mov dh,10    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov al, ' '
  call putchar

  mov ah,02h
  mov dh,10    ;row
  mov dl,15     ;column
  mov bl, 2
  int 10h

  mov si, play
  call printf
  ret

printf:
  lodsb
  cmp al, 0
  je finish
  mov ah, 0eh
  int 10h
  jmp printf
  ret

getchar:
  mov ah, 00h
  int 16h
  ret

putchar:
  mov ah, 0eh ;modo de imprmir na tela
  int 10h ;imprime o que tá em al
  ret

finish:
  ret

jogo:
;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x500:0x0])
	mov ax,0x860		;0x50<<1 + 0 = 0x500
	mov es,ax
	xor bx,bx		;Zerando o offset

;Setando a posição da Ram onde o jogo será lido
	mov ah, 0x02	;comando de ler setor do disco
	mov al,8		;quantidade de blocos ocupados por jogo
	mov dl,0		;drive floppy

;Usaremos as seguintes posições na memoria:
	mov ch,0		;trilha 0
	mov cl,7		;setor 2
	mov dh,0		;cabeca 0
	int 13h
	jc jogo	;em caso de erro, tenta de novo

break:
	jmp 0x8600 		;Pula para a posição carregada


exit:
