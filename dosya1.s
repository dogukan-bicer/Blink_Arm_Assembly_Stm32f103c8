							   EXPORT Ana_Program

Delay_suresi                   EQU  0x239A95;8mhz/3(clock sinyali)=2.333.333=0x239A95
RCC                            EQU  0x40021000 ;RCC nin adresi
Port_C                         EQU  0x40011000 ;Port c nin adresi

							   AREA Bolum3, CODE, READONLY
delay 
                               LDR r9,=Delay_suresi ;register r9 u Delay_suresindeki deger yap
sayac						   SUBS r9,#1 ;register r9 a 1 ekle
							   BNE sayac ;sayac'a esit degilse
							   BX LR ;geri dön
Ana_Program						                              
                               ; apb2 aktif (CLOCK ayarlamasi)
							   MOV r0, #0x10 
							   LDR r1, =RCC
                               STR r0, [r1, #0x18] ;RCC_AHB2ENR ADRESI

                               ; pc13 çikis olarak ayarlandi
							   MOV r0, #0x200000 
							   LDR r1, =Port_C
                               STR r0, [r1, #0x04] ; pa13 cikis olarak ayarlandi

                               ; pc13 ledi açik/kapali
dongu
                               MOV r0, #0x0000; pc13 açik
							   ;MOV r0, #0x2000;pc13 kapali
                               STR r0, [r1, #0x0C]
                               BL delay ;delay subroutine i cagir
							   MOV r0, #0x2000;pc13 kapali
                               STR r0, [r1, #0x0C]
							   BL delay 
                               B dongu ;döngüyü tekrarla
							   
							   ALIGN
							   
							   END
								   
								   
