/**
  ******************************************************************************
  * @file      startup_stm32.s dedicated to STM32F446RETx device
  * @author    Ac6
  * @version   V1.0.0
  * @date      2018-04-25
  ******************************************************************************
  */

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

/**
 * @brief  This is the code that gets called when the processor first
 *          starts execution following a reset event. Only the absolutely
 *          necessary set is performed, after which the application
 *          supplied main() routine is called.
 * @param  None
 * @retval : None
*/

  .section .text.Reset_Handler
  .weak Reset_Handler
  .type Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit
  
/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call the clock system intitialization function.*/
  bl  SystemInit
/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever


.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler
/******************************************************************************
*
* The STM32F446RETx vector table.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
   .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object
  .size g_pfnVectors, .-g_pfnVectors


g_pfnVectors:
  .word _estack
  .word Reset_Handler
  .word NMI_Handler
  .word HardFault_Handler
  .word	MemManage_Handler
  .word	BusFault_Handler
  .word	UsageFault_Handler
  .word	0
  .word	0
  .word	0
  .word	0
  .word	SVC_Handler
  .word	DebugMon_Handler
  .word	0
  .word	PendSV_Handler
  .word	SysTick_Handler
  .word	WWDG_IRQHandler              			/* Window Watchdog interrupt                                          */
  .word	0                            			/* Reserved                                                           */
  .word	TAMP_STAMP_IRQHandler        			/* Tamper and TimeStamp interrupts through the EXTI line              */
  .word	RTC_WKUP_IRQHandler          			/* RTC Wakeup interrupt through the EXTI line                         */
  .word	FLASH_IRQHandler             			/* Flash global interrupt                                             */
  .word	RCC_IRQHandler               			/* RCC global interrupt                                               */
  .word	pinISR			             			/* EXTI Line0 interrupt                                               */
  .word	EXTI1_IRQHandler             			/* EXTI Line1 interrupt                                               */
  .word	EXTI2_IRQHandler             			/* EXTI Line2 interrupt                                               */
  .word	EXTI3_IRQHandler             			/* EXTI Line3 interrupt                                               */
  .word	EXTI4_IRQHandler             			/* EXTI Line4 interrupt                                               */
  .word	DMA1_Stream0_IRQHandler      			/* DMA1 Stream0 global interrupt                                      */
  .word	DMA1_Stream1_IRQHandler      			/* DMA1 Stream1 global interrupt                                      */
  .word	DMA1_Stream2_IRQHandler      			/* DMA1 Stream2 global interrupt                                      */
  .word	DMA1_Stream3_IRQHandler      			/* DMA1 Stream3 global interrupt                                      */
  .word	DMA1_Stream4_IRQHandler      			/* DMA1 Stream4 global interrupt                                      */
  .word	DMA1_Stream5_IRQHandler      			/* DMA1 Stream5 global interrupt                                      */
  .word	DMA1_Stream6_IRQHandler      			/* DMA1 Stream6 global interrupt                                      */
  .word	ADC_IRQHandler               			/* ADC3 global interrupts                                             */
  .word	CAN1_TX_IRQHandler           			/* CAN1 TX interrupts                                                 */
  .word	CAN1_RX0_IRQHandler          			/* CAN1 RX0 interrupts                                                */
  .word	CAN1_RX1_IRQHandler          			/* CAN1 RX1 interrupts                                                */
  .word	CAN1_SCE_IRQHandler          			/* CAN1 SCE interrupt                                                 */
  .word	EXTI9_5_IRQHandler           			/* EXTI Line[9:5] interrupts                                          */
  .word	TIM1_BRK_TIM9_IRQHandler     			/* TIM1 Break interrupt and TIM9 global interrupt                     */
  .word	TIM1_UP_TIM10_IRQHandler     			/* TIM1 Update interrupt and TIM10 global interrupt                   */
  .word	TIM1_TRG_COM_TIM11_IRQHandler			/* TIM1 Trigger and Commutation interrupts and TIM11 global interrupt */
  .word	TIM1_CC_IRQHandler           			/* TIM1 Capture Compare interrupt                                     */
  .word	timerISR		              			/* TIM2 global interrupt                                              */
  .word	TIM3_IRQHandler              			/* TIM3 global interrupt                                              */
  .word	TIM4_IRQHandler              			/* TIM4 global interrupt                                              */
  .word	I2C1_EV_IRQHandler           			/* I2C1 event interrupt                                               */
  .word	I2C1_ER_IRQHandler           			/* I2C1 error interrupt                                               */
  .word	I2C2_EV_IRQHandler           			/* I2C2 event interrupt                                               */
  .word	I2C2_ER_IRQHandler           			/* I2C2 error interrupt                                               */
  .word	SPI1_IRQHandler              			/* SPI1 global interrupt                                              */
  .word	SPI2_IRQHandler              			/* SPI2 global interrupt                                              */
  .word	USART1_IRQHandler            			/* USART1 global interrupt                                            */
  .word	USART2_IRQHandler            			/* USART2 global interrupt                                            */
  .word	USART3_IRQHandler            			/* USART3 global interrupt                                            */
  .word	EXTI15_10_IRQHandler         			/* EXTI Line[15:10] interrupts                                        */
  .word	RTC_Alarm_IRQHandler         			/* RTC Alarms (A and B) through EXTI line interrupt                   */
  .word	OTG_FS_WKUP_IRQHandler       			/* USB On-The-Go FS Wakeup through EXTI line interrupt                */
  .word	TIM8_BRK_TIM12_IRQHandler    			/* TIM8 Break interrupt and TIM12 global interrupt                    */
  .word	TIM8_UP_TIM13_IRQHandler     			/* TIM8 Update interrupt and TIM13 global interrupt                   */
  .word	TIM8_TRG_COM_TIM14_IRQHandler			/* TIM8 Trigger and Commutation interrupts and TIM14 global interrupt */
  .word	TIM8_CC_IRQHandler           			/* TIM8 Capture Compare interrupt                                     */
  .word	DMA1_Stream7_IRQHandler      			/* DMA1 Stream7 global interrupt                                      */
  .word	FMC_IRQHandler               			/* FMC global interrupt                                               */
  .word	0                            			/* Reserved                                                           */
  .word	TIM5_IRQHandler              			/* TIM5 global interrupt                                              */
  .word	SPI3_IRQHandler              			/* SPI3 global interrupt                                              */
  .word	UART4_IRQHandler             			/* UART4 global interrupt                                             */
  .word	UART5_IRQHandler             			/* UART5 global interrupt                                             */
  .word	TIM6_DAC_IRQHandler          			/* TIM6 global interrupt, DAC1 and DAC2 underrun error interrupt      */
  .word	TIM7_IRQHandler              			/* TIM7 global interrupt                                              */
  .word	DMA2_Stream0_IRQHandler      			/* DMA2 Stream0 global interrupt                                      */
  .word	DMA2_Stream1_IRQHandler      			/* DMA2 Stream1 global interrupt                                      */
  .word	DMA2_Stream2_IRQHandler      			/* DMA2 Stream2 global interrupt                                      */
  .word	DMA2_Stream3_IRQHandler      			/* DMA2 Stream3 global interrupt                                      */
  .word	DMA2_Stream4_IRQHandler      			/* DMA2 Stream4 global interrupt                                      */
  .word	ETH_IRQHandler               			/* Ethernet global interrupt                                          */
  .word	ETH_WKUP_IRQHandler          			/* Ethernet Wakeup through EXTI line interrupt                        */
  .word	CAN2_TX_IRQHandler           			/* CAN2 TX interrupts                                                 */
  .word	CAN2_RX0_IRQHandler          			/* CAN2 RX0 interrupts                                                */
  .word	CAN2_RX1_IRQHandler          			/* CAN2 RX1 interrupts                                                */
  .word	CAN2_SCE_IRQHandler          			/* CAN2 SCE interrupt                                                 */
  .word	OTG_FS_IRQHandler            			/* USB On The Go FS global interrupt                                  */
  .word	DMA2_Stream5_IRQHandler      			/* DMA2 Stream5 global interrupt                                      */
  .word	DMA2_Stream6_IRQHandler      			/* DMA2 Stream6 global interrupt                                      */
  .word	DMA2_Stream7_IRQHandler      			/* DMA2 Stream7 global interrupt                                      */
  .word	USART6_IRQHandler            			/* USART6 global interrupt                                            */
  .word	I2C3_EV_IRQHandler           			/* I2C3 event interrupt                                               */
  .word	I2C3_ER_IRQHandler           			/* I2C3 error interrupt                                               */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	DCMI_IRQHandler              			/* DCMI global interrupt                                              */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	FPU_IRQHandler               			/* Floating point interrupt                                           */
  .word	UART7_IRQHandler             			/* UART 7 global interrupt                                            */
  .word	UART8_IRQHandler             			/* UART 8 global interrupt                                            */
  .word	SPI4_IRQHandler              			/* SPI 4 global interrupt                                             */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	0                            			/* Reserved                                                           */
  .word	LCD_TFT_IRQHandler           			/* LTDC global interrupt                                              */
  .word	LCD_TFT_1_IRQHandler         			/* LTDC global error interrupt                                        */

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

  	.weak	NMI_Handler
	.thumb_set NMI_Handler,Default_Handler

  	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,Default_Handler

  	.weak	MemManage_Handler
	.thumb_set MemManage_Handler,Default_Handler

  	.weak	BusFault_Handler
	.thumb_set BusFault_Handler,Default_Handler

	.weak	UsageFault_Handler
	.thumb_set UsageFault_Handler,Default_Handler
	
	.weak	SVC_Handler
	.thumb_set SVC_Handler,Default_Handler

	.weak	DebugMon_Handler
	.thumb_set DebugMon_Handler,Default_Handler
	
	.weak	PendSV_Handler
	.thumb_set PendSV_Handler,Default_Handler

	.weak	SysTick_Handler
	.thumb_set SysTick_Handler,Default_Handler

	.weak	WWDG_IRQHandler
	.thumb_set WWDG_IRQHandler,Default_Handler
	
	.weak	TAMP_STAMP_IRQHandler
	.thumb_set TAMP_STAMP_IRQHandler,Default_Handler
	
	.weak	RTC_WKUP_IRQHandler
	.thumb_set RTC_WKUP_IRQHandler,Default_Handler
	
	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,Default_Handler
	
	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,Default_Handler
	
	.weak	EXTI0_IRQHandler
	.thumb_set EXTI0_IRQHandler,Default_Handler
	
	.weak	EXTI1_IRQHandler
	.thumb_set EXTI1_IRQHandler,Default_Handler
	
	.weak	EXTI2_IRQHandler
	.thumb_set EXTI2_IRQHandler,Default_Handler
	
	.weak	EXTI3_IRQHandler
	.thumb_set EXTI3_IRQHandler,Default_Handler
	
	.weak	EXTI4_IRQHandler
	.thumb_set EXTI4_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream0_IRQHandler
	.thumb_set DMA1_Stream0_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream1_IRQHandler
	.thumb_set DMA1_Stream1_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream2_IRQHandler
	.thumb_set DMA1_Stream2_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream3_IRQHandler
	.thumb_set DMA1_Stream3_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream4_IRQHandler
	.thumb_set DMA1_Stream4_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream5_IRQHandler
	.thumb_set DMA1_Stream5_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream6_IRQHandler
	.thumb_set DMA1_Stream6_IRQHandler,Default_Handler
	
	.weak	ADC_IRQHandler
	.thumb_set ADC_IRQHandler,Default_Handler
	
	.weak	CAN1_TX_IRQHandler
	.thumb_set CAN1_TX_IRQHandler,Default_Handler
	
	.weak	CAN1_RX0_IRQHandler
	.thumb_set CAN1_RX0_IRQHandler,Default_Handler
	
	.weak	CAN1_RX1_IRQHandler
	.thumb_set CAN1_RX1_IRQHandler,Default_Handler
	
	.weak	CAN1_SCE_IRQHandler
	.thumb_set CAN1_SCE_IRQHandler,Default_Handler
	
	.weak	EXTI9_5_IRQHandler
	.thumb_set EXTI9_5_IRQHandler,Default_Handler
	
	.weak	TIM1_BRK_TIM9_IRQHandler
	.thumb_set TIM1_BRK_TIM9_IRQHandler,Default_Handler
	
	.weak	TIM1_UP_TIM10_IRQHandler
	.thumb_set TIM1_UP_TIM10_IRQHandler,Default_Handler
	
	.weak	TIM1_TRG_COM_TIM11_IRQHandler
	.thumb_set TIM1_TRG_COM_TIM11_IRQHandler,Default_Handler
	
	.weak	TIM1_CC_IRQHandler
	.thumb_set TIM1_CC_IRQHandler,Default_Handler
	
	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,Default_Handler
	
	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,Default_Handler
	
	.weak	TIM4_IRQHandler
	.thumb_set TIM4_IRQHandler,Default_Handler
	
	.weak	I2C1_EV_IRQHandler
	.thumb_set I2C1_EV_IRQHandler,Default_Handler
	
	.weak	I2C1_ER_IRQHandler
	.thumb_set I2C1_ER_IRQHandler,Default_Handler
	
	.weak	I2C2_EV_IRQHandler
	.thumb_set I2C2_EV_IRQHandler,Default_Handler
	
	.weak	I2C2_ER_IRQHandler
	.thumb_set I2C2_ER_IRQHandler,Default_Handler
	
	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,Default_Handler
	
	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,Default_Handler
	
	.weak	USART1_IRQHandler
	.thumb_set USART1_IRQHandler,Default_Handler
	
	.weak	USART2_IRQHandler
	.thumb_set USART2_IRQHandler,Default_Handler
	
	.weak	USART3_IRQHandler
	.thumb_set USART3_IRQHandler,Default_Handler
	
	.weak	EXTI15_10_IRQHandler
	.thumb_set EXTI15_10_IRQHandler,Default_Handler
	
	.weak	RTC_Alarm_IRQHandler
	.thumb_set RTC_Alarm_IRQHandler,Default_Handler
	
	.weak	OTG_FS_WKUP_IRQHandler
	.thumb_set OTG_FS_WKUP_IRQHandler,Default_Handler
	
	.weak	TIM8_BRK_TIM12_IRQHandler
	.thumb_set TIM8_BRK_TIM12_IRQHandler,Default_Handler
	
	.weak	TIM8_UP_TIM13_IRQHandler
	.thumb_set TIM8_UP_TIM13_IRQHandler,Default_Handler
	
	.weak	TIM8_TRG_COM_TIM14_IRQHandler
	.thumb_set TIM8_TRG_COM_TIM14_IRQHandler,Default_Handler
	
	.weak	TIM8_CC_IRQHandler
	.thumb_set TIM8_CC_IRQHandler,Default_Handler
	
	.weak	DMA1_Stream7_IRQHandler
	.thumb_set DMA1_Stream7_IRQHandler,Default_Handler
	
	.weak	FMC_IRQHandler
	.thumb_set FMC_IRQHandler,Default_Handler
	
	.weak	TIM5_IRQHandler
	.thumb_set TIM5_IRQHandler,Default_Handler
	
	.weak	SPI3_IRQHandler
	.thumb_set SPI3_IRQHandler,Default_Handler
	
	.weak	UART4_IRQHandler
	.thumb_set UART4_IRQHandler,Default_Handler
	
	.weak	UART5_IRQHandler
	.thumb_set UART5_IRQHandler,Default_Handler
	
	.weak	TIM6_DAC_IRQHandler
	.thumb_set TIM6_DAC_IRQHandler,Default_Handler
	
	.weak	TIM7_IRQHandler
	.thumb_set TIM7_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream0_IRQHandler
	.thumb_set DMA2_Stream0_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream1_IRQHandler
	.thumb_set DMA2_Stream1_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream2_IRQHandler
	.thumb_set DMA2_Stream2_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream3_IRQHandler
	.thumb_set DMA2_Stream3_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream4_IRQHandler
	.thumb_set DMA2_Stream4_IRQHandler,Default_Handler
	
	.weak	ETH_IRQHandler
	.thumb_set ETH_IRQHandler,Default_Handler
	
	.weak	ETH_WKUP_IRQHandler
	.thumb_set ETH_WKUP_IRQHandler,Default_Handler
	
	.weak	CAN2_TX_IRQHandler
	.thumb_set CAN2_TX_IRQHandler,Default_Handler
	
	.weak	CAN2_RX0_IRQHandler
	.thumb_set CAN2_RX0_IRQHandler,Default_Handler
	
	.weak	CAN2_RX1_IRQHandler
	.thumb_set CAN2_RX1_IRQHandler,Default_Handler
	
	.weak	CAN2_SCE_IRQHandler
	.thumb_set CAN2_SCE_IRQHandler,Default_Handler
	
	.weak	OTG_FS_IRQHandler
	.thumb_set OTG_FS_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream5_IRQHandler
	.thumb_set DMA2_Stream5_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream6_IRQHandler
	.thumb_set DMA2_Stream6_IRQHandler,Default_Handler
	
	.weak	DMA2_Stream7_IRQHandler
	.thumb_set DMA2_Stream7_IRQHandler,Default_Handler
	
	.weak	USART6_IRQHandler
	.thumb_set USART6_IRQHandler,Default_Handler
	
	.weak	I2C3_EV_IRQHandler
	.thumb_set I2C3_EV_IRQHandler,Default_Handler
	
	.weak	I2C3_ER_IRQHandler
	.thumb_set I2C3_ER_IRQHandler,Default_Handler
	
	.weak	DCMI_IRQHandler
	.thumb_set DCMI_IRQHandler,Default_Handler
	
	.weak	FPU_IRQHandler
	.thumb_set FPU_IRQHandler,Default_Handler
	
	.weak	UART7_IRQHandler
	.thumb_set UART7_IRQHandler,Default_Handler
	
	.weak	UART8_IRQHandler
	.thumb_set UART8_IRQHandler,Default_Handler
	
	.weak	SPI4_IRQHandler
	.thumb_set SPI4_IRQHandler,Default_Handler
	
	.weak	LCD_TFT_IRQHandler
	.thumb_set LCD_TFT_IRQHandler,Default_Handler
	
	.weak	LCD_TFT_1_IRQHandler
	.thumb_set LCD_TFT_1_IRQHandler,Default_Handler
	
	.weak	SystemInit

/************************ (C) COPYRIGHT Ac6 *****END OF FILE****/
