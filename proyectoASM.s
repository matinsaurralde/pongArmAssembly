#include "imagenes.h"
#include <stdio.h>

.text
.align 2

.global miMain
.type miMain, %function

miMain: // X0 pixels
		mov		x10, X0			//  BackUp pixels address
		mov		x15, X1			//  BackUp control
		
		mov     x11, #0         //  x11 -> Control vertical player one   (Barra 1)
		mov     x12, #0         //  x12 -> Control vertical player two   (Barra 2)
		mov     x13, #160         //  x13 -> Control horizontal pelotita
		mov     x14, #120         //  x13 -> Control vertical pelotita
		movz    x16, #0           //  x16 -> Flag direccion horizontal pelota, inicia hacia la derecha
		movz    x17, #1           //  x17 -> Flag direccion vertical pelota, inicia hacia abajo
		
miMain_loop:

//  Pintamos el fondo        
        mov     x0, x10     // Direc de pantalla
        movz    x1, #0      // Col del rec
        mov     x2, #0     // Fila del rec
        movz    x3, #320     // Ancho del rec
        movz    x4, #240     // Alto del rec
        movz	w5, 0x0000			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0x0000, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle
		
		//TODO: asegurarse que X11 (Botones) no se pasa de los limites de 0 y de 240/320
		//miMain_abajo_player_one
		ldrb    w7, [x15, #5]                                 // Obtenemos la tecla "S" (Ver si esta presionada)
		cmp     w7, #1
		b.ne    miMain_arriba_player_one                      // Si no esta presionada no movemos la barra 1
		cmp     x11, #180                                     // Verificamos que llegamos al limite y la barra no baja mas
		b.ge    miMain_arriba_player_one    
        add     x11, x11, #5                                    // Si esta presionada movemos la barra 1 hacia abajo

miMain_arriba_player_one:
        ldrb    w7, [x15, #6]                                   // Obtenemos la tecla "W" (Ver si esta presionada)
		cmp     w7, #1
		b.ne    miMain_abajo_player_two                           // Si no esta presionada no movemos la barra 1
        cmp     x11, #0                                         // Verificamos que llegamos al limite y la barra no sube mas
		b.le    miMain_abajo_player_two
        sub     x11, x11, #5                                    // Si esta presionada movemos la barra 1 hacia arriba
        
miMain_abajo_player_two:
		ldrb    w7, [x15, #3]                                   // Obtenemos la tecla flecha abajo (Ver si esta presionada)
		cmp     w7, #1
		b.ne    miMain_arriba_player_two                          // Si no esta presionada no movemos la barra 2
		cmp     x12, #180                                     // Verificamos que llegamos al limite y la barra no baja mas
		b.ge    miMain_arriba_player_two    
        add     x12, x12, #5                                    // Si esta presionada movemos la barra 2 hacia abajo

miMain_arriba_player_two:
        ldrb    w7, [x15, #2]                                   // Obtenemos la tecla flecha arriba (Ver si esta presionada)
		cmp     w7, #1
		b.ne    miMain_next                                       // Si no esta presionada no movemos la barra 2
        cmp     x12, #0                                         // Verificamos que llegamos al limite y la barra no sube mas
		b.le    miMain_next
        sub     x12, x12, #5                                    // Si esta presionada movemos la barra 2 hacia arriba

miMain_next:                // Dibujamos las barras
        mov     x0, x10     // Direc de pantalla   (Barra 1)
        movz    x1, #0      // Col del rec
        mov     x2, x11     // Fila del rec
        movz    x3, #10     // Ancho del rec
        movz    x4, #60     // Alto del rec
        movz	w5, 0xFFFF			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0xFFFF, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle
		
		mov     x0, x10     // Direc de pantalla   (Barra 2)
        movz    x1, #310      // Col del rec
        mov     x2, x12     // Fila del rec
        movz    x3, #10     // Ancho del rec
        movz    x4, #60     // Alto del rec
        movz	w5, 0xFFFF			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0xFFFF, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle
		
		
// Dibujamos limites superior e inferior
        mov     x0, x10     // Direc de pantalla   (Barra 2)
        movz    x1, #0      // Col del rec
        mov     x2, #0     // Fila del rec
        movz    x3, #320     // Ancho del rec
        movz    x4, #2     // Alto del rec
        movz	w5, 0xFFFF			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0xFFFF, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle
		
		mov     x0, x10     // Direc de pantalla   (Barra 2)
        movz    x1, #0      // Col del rec
        mov     x2, #238     // Fila del rec
        movz    x3, #320     // Ancho del rec
        movz    x4, #2     // Alto del rec
        movz	w5, 0xFFFF			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0xFFFF, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle

// Verificamos el movimiento de la pelotita
// Verificamos si la pelota se mueve hacia la derecha
		cmp     x16, #1                    // Verificamos FLAG Horizontal
		b.eq    miMain_left_ball
        add     x13, x13, #5
		cmp     x13, #306                 // Verificamos limite derecho
		b.lt    miMain_down_ball  
		movz    x16, #1                   // Seteamos FLAG BALL_LEFT
		cmp     x14, x12
		b.lt    miMain_game_over_player_one          // la pelotita choco arriba de la barra (Pierde player 2)
		add     x18, x12, #60
		cmp     x14, x18
		b.gt    miMain_game_over_player_one          // la pelotita choco abajo de la barra (Pierde player 2)
		
miMain_left_ball:                       // Verificamos si la pelota se mueve hacia la izquierda
        sub     x13, x13, #5
		cmp     x13, #10                  // Verificamos limite izquierdo
		b.gt    miMain_down_ball
		movz    x16, #0                   // Seteamos FLAG BALL_RIGHT
		cmp     x14, x11
		b.lt    miMain_game_over_player_two          // la pelotita choco arriba de la barra (Pierde player 1)
		add     x18, x11, #60
		cmp     x14, x18
		b.gt    miMain_game_over_player_two          // la pelotita choco abajo de la barra (Pierde player 1)
		
miMain_down_ball:                       // Verificamos si la pelota se mueve hacia abajo
		cmp     x17, #1                   // Verificamos FLAG Vertical
		b.eq    miMain_up_ball
        add     x14, x14, #3
		cmp     x14, #235                 // Verificamos limite abajo
		b.lt    miMain_draw_ball
		movz    x17, #1                   // Seteamos FLAG BALL_UP
		
miMain_up_ball:                         // Verificamos si la pelota se mueve hacia arriba
        sub     x14, x14, #3
		cmp     x14, #5                   // Verificamos limite arriba
		b.gt    miMain_draw_ball
		movz    x17, #0                   // Seteamos FLAG BALL_DOWN
    
miMain_draw_ball:
		mov     x0, x10     // Direc de pantalla
        mov     x1, x13      // Col del rec
        mov     x2, x14     // Fila del rec
        movz    x3, #4     // Ancho del rec
        movz    x4, #4     // Alto del rec
        movz	w5, 0xFFFF			// 0x00000aa0                                     // 0x GGBB
		movk	w5, 0xFFFF, lsl 16	// w2 = color = 0xffff0aa0 ->  0x0000FFFF         // 0x AARR
		bl      print_rectangle
    

miMain_wait: 							//wait for frame
        ldrb	w7, [x15, #8]
		subs	wzr, w7, #1
        b.ne	miMain_wait
		mov		w7, #0
		strb	w7,[x15, #8]
		b		miMain_loop
		
		

		
		
		
/*
    x0 -> Direc pantalla
    x1 -> Columna de pantalla (donde empieza)
    x2 -> Fila pantalla
    x3 -> Ancho
    x4 -> Alto
    x5 -> Color
*/				
print_rectangle:
        sub     sp, sp, #32
        str     x6, [sp, #16]
        str     x29, [sp, #8]
        str     x30, [sp, #0]
        
        cmp     x1, #0
        b.ge    print_rectangle_verify_max_col
        movz    x1, #0

print_rectangle_verify_max_col:
        sub     x6, x3, #320         //  x6 = 10 - 320 = -310
        sub     x6, xzr, x6          //  x6 = 0 - -310 = 310
        cmp     x1, x6                //  x2 <= x6 -> 
        b.le    print_rectangle_verify_min_row
        mov     x1, x6
        
print_rectangle_verify_min_row:
        cmp     x2, #0
        b.ge    print_rectangle_verify_max_row
        movz    x2, #0
        
print_rectangle_verify_max_row:  
        sub     x6, x4, #240         //  x6 = 60 - 240 = -180
        sub     x6, xzr, x6          //  x6 = 0 - -180 = 180
        cmp     x2, x6                //  x2 <= x6 -> 
        b.le    print_rectangle_continue
        mov     x2, x6
        
print_rectangle_continue:
        movz    x6, 0x500   // 320 x 4 = 1280 = 0x500
        mul     x2, x2, x6       
        add     x0, x0, x2
        
        lsl     x1, x1, #2
        add     x0, x0, x1  // Posicion absoluta del origen del rectangulo
        
        movz    x2, #0      // Contador en alto
        
print_rectangle_loop_fila:      
        movz    x1, #0      // Contador en ancho
        
print_rectangle_loop_columna:
        str     x5, [x0, #0]    // Pintamos de color
        add     x0, x0, #4      // Nos movemos un pixel
        add     x1, x1, #1      // Incrementanmos el contador en ancho
        cmp     x1, x3          // Comparamos el contador en ancho con el ancho del rectangulo
        b.lt    print_rectangle_loop_columna   // Si no llegamos al ancho, seguimos pintando
        add     x0, x0, #1280       // Nos movemos al ultimo pixel de la siguiente fila
        lsl     x6, x3, #2          //  Calculamos el primer pixel de la fila
        sub     x0, x0, x6          // Nos movemos al primer pixel de la siguiente fila
        add     x2, x2, #1       // Incrementamos el contador en alto
        
        cmp     x2, x4          // Comparamos el contador en alto con el alto del rectangulo
        b.lt    print_rectangle_loop_fila   // Si no llegamos al ancho, seguimos pintando
        
        
        ldr     x30, [sp, #0]
        ldr     x29, [sp, #8]
        ldr     x6, [sp, #16]
        add     sp, sp, #32
        ret
        
/*
    x0 -> Direc pantalla
    x1 -> Columna de pantalla (donde empieza)
    x2 -> Fila pantalla
    x3 -> Direccion de imagen
    x4 -> Ancho (Sacado de imagen)
    x5 -> Alto (Sacado de imagen)
*/				
print_image:
        sub     sp, sp, #32
        str     x6, [sp, #16]
        str     x29, [sp, #8]
        str     x30, [sp, #0]
        
        ldr     x4, [x3, #0]
        ldr     x5, [x3, #8]
        add     x3, x3, #16
        
        cmp     x1, #0
        b.ge    print_image_verify_max_col
        movz    x1, #0

print_image_verify_max_col:
        sub     x6, x4, #320         //  x6 = 10 - 320 = -310
        sub     x6, xzr, x6          //  x6 = 0 - -310 = 310
        cmp     x1, x6                //  x2 <= x6 -> 
        b.le    print_image_verify_min_row
        mov     x1, x6
        
print_image_verify_min_row:
        cmp     x2, #0
        b.ge    print_image_verify_max_row
        movz    x2, #0
        
print_image_verify_max_row:  
        sub     x6, x5, #240         //  x6 = 60 - 240 = -180
        sub     x6, xzr, x6          //  x6 = 0 - -180 = 180
        cmp     x2, x6                //  x2 <= x6 -> 
        b.le    print_image_continue
        mov     x2, x6
        
print_image_continue:
        movz    x6, 0x500   // 320 x 4 = 1280 = 0x500
        mul     x2, x2, x6       
        add     x0, x0, x2
        
        lsl     x1, x1, #2
        add     x0, x0, x1  // Posicion absoluta del origen del rectangulo
        
        movz    x2, #0      // Contador en alto
        
print_image_loop_fila:      
        movz    x1, #0      // Contador en ancho
        
print_image_loop_columna:
        ldr     w6, [x3, #16]
        str     w6, [x0, #0]    // Pintamos de color
        add     x3, x3, #4
        add     x0, x0, #4      // Nos movemos un pixel
        add     x1, x1, #1      // Incrementanmos el contador en ancho
        cmp     x1, x4          // Comparamos el contador en ancho con el ancho del rectangulo
        b.lt    print_image_loop_columna   // Si no llegamos al ancho, seguimos pintando
        add     x0, x0, #1280       // Nos movemos al ultimo pixel de la siguiente fila
        lsl     x6, x4, #2          //  Calculamos el primer pixel de la fila
        sub     x0, x0, x6          // Nos movemos al primer pixel de la siguiente fila
        add     x2, x2, #1       // Incrementamos el contador en alto
        
        cmp     x2, x5          // Comparamos el contador en alto con el alto del rectangulo
        b.lt    print_image_loop_fila   // Si no llegamos al ancho, seguimos pintando
        
        
        ldr     x30, [sp, #0]
        ldr     x29, [sp, #8]
        ldr     x6, [sp, #16]
        add     sp, sp, #32
        ret



miMain_game_over_player_one:
        mov     x0, x10     // Direc de pantalla
        movz    x1, #0      // Col del rec
        mov     x2, #0     // Fila del rec
        adrp    x3, gameoverplayerone
        add     x3, x3, :lo12:gameoverplayerone
		bl      print_image
		
		b       miMain_game_over

miMain_game_over_player_two:
        mov     x0, x10     // Direc de pantalla
        movz    x1, #0      // Col del rec
        mov     x2, #0     // Fila del rec
    
        adrp    x3, gameoverplayertwo
        add     x3, x3, :lo12:gameoverplayertwo
		bl      print_image
		
		b       miMain_game_over
		
miMain_game_over:
        b       miMain_game_over
