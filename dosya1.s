		           EXPORT Ana_Program
delay_ms           EQU 0xE10 ;10hz 3600 psc=36
GPIOA_IDR	       EQU 0x40010808

GPIOA_CRL	       EQU 0x40010800
GPIOA_ODR	       EQU 0x4001080C
RCC_APB2ENR        EQU 0x40021000
RCC_APB1ENR        EQU 0x40021000
TIM2_ARR           EQU 0x40000000
TIM2_PSC           EQU 0x40000028
TIM2_DIER          EQU 0x40000000
TIM2_CR1           EQU 0x40000000
TIM2_SR            EQU 0x40000000

		           AREA Bolum3, CODE, READONLY	 
delay
   ; 10:         TIM2->CNT = 0; 
                   MOVS     r1,#0x00
                   MOV      r2,#0x40000000
                   STRH     r1,[r2,#0x24] 
  ;  11:         while (TIM2->CNT < us); 
                   NOP      
geri               MOV      r1,#0x40000000
                   LDRH     r1,[r1,#0x24]
				   LDR      r5,=delay_ms
                   CMP      r1,r5
                   BLT      geri				   
				   BX LR
Ana_Program	
                   MOV      r0,#0x0
                   LDR      r1,=TIM2_SR 
                   STR      r0,[r1,#0x10]				   
;BX   LR
 ;        RCC->APB2ENR = 0x04; /// port a active 
                   MOV      r0,#0x04
                   LDR      r1,=RCC_APB2ENR  
                   STR      r0,[r1,#0x18]
     ; pa3 out
                   MOV      r0,#0x3000
                   LDR      r1,=GPIOA_CRL  
                   STR      r0,[r1,#0x00]

                   ADDS     R11,R11,#1  
    ;         RCC->APB1ENR =0x1;// timer2 active 
                   MOV      r0,#0x1
                   LDR      r1,=RCC_APB1ENR  
                   STR      r0,[r1,#0x1C]
    ;        TIM2->ARR = 0xffff;  
                   MOV      r0,#0xFFFF
                   LDR      r1,=TIM2_ARR
                   STR      r0,[r1,#0x2C]
    ;         TIM2->PSC = 0x36;  
                   MOV     r0,#0x36
                   STR     r0,[r1,#0x28]
    ;         TIM2->CR1 = 0x1;  
                   MOV      r0,#0x1
                   LDR      r1,=TIM2_CR1
				   STR      r0,[r1,#0x00]
    ;         while (!(TIM2->SR & (1<<0)));  // UIF: Update interrupt flag..  This bit is set by hardware when the registers are updated 
                   NOP      
while              MOV      r0,#0x40000000
                   LDRH     r0,[r0,#0x10]
                   AND      r0,r0,#0x01
                   CMP      r0,#0x00
                   BEQ      while
loop              NOP                       
    ;         while(1) 
   ;          GPIOA->ODR ^=0x0008;//toggle pa3 
                   BL       delay
                   LDR      r0,=GPIOA_ODR  
                   LDR      r0,[r0,#0x00]
                   EOR      r0,r0,#0x08
                   LDR      r1,=GPIOA_ODR  
                   STR      r0,[r1,#0x00] 
                   ADDS     R7,R7,#1
				   BL       delay
			       B        loop
				   ALIGN
	               END
