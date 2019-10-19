org 0x7c00
jmp 0x0000:set_videomode
data:
titulo db 'Titulo', 0
play db 'Play', 0
help db 'Help', 0
arrow db '>', 0

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

start:
  xor ax, ax
  mov ds, ax
  mov es, ax

  call printa_titulo
  call printa_play
  call printa_help
  call tela_up
  
  jmp $

tela_up:
  call apaga_arrow_down
  call printa_arrow_up
  call getchar 
  cmp al, 's'
  je tela_down
  jmp tela_up
  ret

tela_down:
  call apaga_arrow_up
  call printa_arrow_down
  call getchar 
  cmp al, 'w'
  je tela_up
  jmp tela_down
  ret

printa_titulo:
  mov ah,02h
  mov dh,3    ;row
  mov dl,15     ;column
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

printa_arrow_up:
  mov ah,02h
  mov dh,10    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov si, arrow
  call printf
  ret

printa_arrow_down:
  mov ah,02h
  mov dh,12    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov si, arrow
  call printf
  ret

apaga_arrow_down:
  mov ah,02h
  mov dh,12    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov al, ' '
  call putchar
  ret

apaga_arrow_up:
  mov ah,02h
  mov dh,10    ;row
  mov dl,13     ;column
  mov bl, 4
  int 10h

  mov al, ' '
  call putchar
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

times 510 - ($ - $$) db 0
dw 0xaa55 ; assinatura de boot
