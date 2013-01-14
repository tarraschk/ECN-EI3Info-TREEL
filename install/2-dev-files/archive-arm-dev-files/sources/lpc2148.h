#ifndef LPC2148_CONTROL_REGISTERS_DEFINED
#define LPC2148_CONTROL_REGISTERS_DEFINED

//---------------------------------------------------------------------------*

#include "processor-defines.h"

//---------------------------------------------------------------------------*

/* Vectored Interrupt Controller (VIC) */
#define VICIRQStatus   (*((volatile uint32 *) 0xFFFFF000))
#define VICFIQStatus   (*((volatile uint32 *) 0xFFFFF004))
#define VICRawIntr     (*((volatile uint32 *) 0xFFFFF008))
#define VICIntSelect   (*((volatile uint32 *) 0xFFFFF00C))
#define VICIntEnable   (*((volatile uint32 *) 0xFFFFF010))
#define VICIntEnClr    (*((volatile uint32 *) 0xFFFFF014))
#define VICSoftInt     (*((volatile uint32 *) 0xFFFFF018))
#define VICSoftIntClr  (*((volatile uint32 *) 0xFFFFF01C))
#define VICProtection  (*((volatile uint32 *) 0xFFFFF020))
#define VICVectAddr    (*((volatile uint32 *) 0xFFFFF030))
#define VICDefVectAddr (*((volatile uint32 *) 0xFFFFF034))

#define VICVect(INDEX) (*((volatile uint32 *) (0xFFFFF100 + ((INDEX) << 2))))

#define VICVectAddr0   (*((volatile uint32 *) 0xFFFFF100))
#define VICVectAddr1   (*((volatile uint32 *) 0xFFFFF104))
#define VICVectAddr2   (*((volatile uint32 *) 0xFFFFF108))
#define VICVectAddr3   (*((volatile uint32 *) 0xFFFFF10C))
#define VICVectAddr4   (*((volatile uint32 *) 0xFFFFF110))
#define VICVectAddr5   (*((volatile uint32 *) 0xFFFFF114))
#define VICVectAddr6   (*((volatile uint32 *) 0xFFFFF118))
#define VICVectAddr7   (*((volatile uint32 *) 0xFFFFF11C))
#define VICVectAddr8   (*((volatile uint32 *) 0xFFFFF120))
#define VICVectAddr9   (*((volatile uint32 *) 0xFFFFF124))
#define VICVectAddr10  (*((volatile uint32 *) 0xFFFFF128))
#define VICVectAddr11  (*((volatile uint32 *) 0xFFFFF12C))
#define VICVectAddr12  (*((volatile uint32 *) 0xFFFFF130))
#define VICVectAddr13  (*((volatile uint32 *) 0xFFFFF134))
#define VICVectAddr14  (*((volatile uint32 *) 0xFFFFF138))
#define VICVectAddr15  (*((volatile uint32 *) 0xFFFFF13C))

#define VICVectCntl(INDEX) (*((volatile uint32 *) (0xFFFFF200 + ((INDEX) << 2))))

#define VICVectCntl0   (*((volatile uint32 *) 0xFFFFF200))
#define VICVectCntl1   (*((volatile uint32 *) 0xFFFFF204))
#define VICVectCntl2   (*((volatile uint32 *) 0xFFFFF208))
#define VICVectCntl3   (*((volatile uint32 *) 0xFFFFF20C))
#define VICVectCntl4   (*((volatile uint32 *) 0xFFFFF210))
#define VICVectCntl5   (*((volatile uint32 *) 0xFFFFF214))
#define VICVectCntl6   (*((volatile uint32 *) 0xFFFFF218))
#define VICVectCntl7   (*((volatile uint32 *) 0xFFFFF21C))
#define VICVectCntl8   (*((volatile uint32 *) 0xFFFFF220))
#define VICVectCntl9   (*((volatile uint32 *) 0xFFFFF224))
#define VICVectCntl10  (*((volatile uint32 *) 0xFFFFF228))
#define VICVectCntl11  (*((volatile uint32 *) 0xFFFFF22C))
#define VICVectCntl12  (*((volatile uint32 *) 0xFFFFF230))
#define VICVectCntl13  (*((volatile uint32 *) 0xFFFFF234))
#define VICVectCntl14  (*((volatile uint32 *) 0xFFFFF238))
#define VICVectCntl15  (*((volatile uint32 *) 0xFFFFF23C))

/* Pin Connect Block */
#define PINSEL0        (*((volatile uint32 *) 0xE002C000))
#define PINSEL1        (*((volatile uint32 *) 0xE002C004))

/* General Purpose Input/Output (GPIO) */
#define IO0PIN          (*((volatile uint32 *) 0xE0028000))
#define IO0SET          (*((volatile uint32 *) 0xE0028004))
#define IO0DIR          (*((volatile uint32 *) 0xE0028008))
#define IO0CLR          (*((volatile uint32 *) 0xE002800C))

#define IO1PIN          (*((volatile uint32 *) 0xE0028010))
#define IO1SET          (*((volatile uint32 *) 0xE0028014))
#define IO1DIR          (*((volatile uint32 *) 0xE0028018))
#define IO1CLR          (*((volatile uint32 *) 0xE002801C))

/* Fast General Purpose Input/Output (GPIO) */
#define FIODIR         (*((volatile uint32 *) 0x3FFFC000))
#define FIOMASK        (*((volatile uint32 *) 0x3FFFC010))
#define FIOPIN         (*((volatile uint32 *) 0x3FFFC014))
#define FIOSET         (*((volatile uint32 *) 0x3FFFC018))
#define FIOCLR         (*((volatile uint32 *) 0x3FFFC01C))

/* Memory Accelerator Module (MAM) */
#define MAMCR          (*((volatile uint8 *) 0xE01FC000))
#define MAMTIM         (*((volatile uint8 *) 0xE01FC004))
#define MEMMAP         (*((volatile uint8 *) 0xE01FC040))

/* Phase Locked Loop (PLL) */
#define PLLCON         (*((volatile uint8 *) 0xE01FC080))
#define PLLCFG         (*((volatile uint8 *) 0xE01FC084))
#define PLLSTAT        (*((volatile uint16 *) 0xE01FC088))
#define PLLFEED        (*((volatile uint8 *) 0xE01FC08C))

/* APB Divider */
#define APBDIV         (*((volatile uint8 *) 0xE01FC100))

/* Power Control */
#define PCON           (*((volatile uint8 *) 0xE01FC0C0))
#define PCONP          (*((volatile uint32 *) 0xE01FC0C4))

/* External Interrupts */
#define EXTINT         (*((volatile uint8 *) 0xE01FC140))
#define EXTWAKE        (*((volatile uint8 *) 0xE01FC144))
#define EXTMODE        (*((volatile uint8 *) 0xE01FC148))
#define EXTPOLAR       (*((volatile uint8 *) 0xE01FC14C))

/* Timer 0 */
#define T0IR           (*((volatile uint8 *) 0xE0004000))
#define T0TCR          (*((volatile uint8 *) 0xE0004004))
#define T0TC           (*((volatile uint32 *) 0xE0004008))
#define T0PR           (*((volatile uint32 *) 0xE000400C))
#define T0PC           (*((volatile uint32 *) 0xE0004010))
#define T0MCR          (*((volatile uint16 *) 0xE0004014))
#define T0MR0          (*((volatile uint32 *) 0xE0004018))
#define T0MR1          (*((volatile uint32 *) 0xE000401C))
#define T0MR2          (*((volatile uint32 *) 0xE0004020))
#define T0MR3          (*((volatile uint32 *) 0xE0004024))
#define T0CCR          (*((volatile uint16 *) 0xE0004028))
#define T0CR0          (*((volatile uint32 *) 0xE000402C))
#define T0CR1          (*((volatile uint32 *) 0xE0004030))
#define T0CR2          (*((volatile uint32 *) 0xE0004034))
#define T0CR3          (*((volatile uint32 *) 0xE0004038))
#define T0EMR          (*((volatile uint16 *) 0xE000403C))
#define T0CTCR         (*((volatile uint8 *) 0xE0004070))
#define T0PWMCON       (*((volatile uint32 *) 0xE0004074))

/* Timer 1 */
#define T1IR           (*((volatile uint8 *) 0xE0008000))
#define T1TCR          (*((volatile uint8 *) 0xE0008004))
#define T1TC           (*((volatile uint32 *) 0xE0008008))
#define T1PR           (*((volatile uint32 *) 0xE000800C))
#define T1PC           (*((volatile uint32 *) 0xE0008010))
#define T1MCR          (*((volatile uint16 *) 0xE0008014))
#define T1MR0          (*((volatile uint32 *) 0xE0008018))
#define T1MR1          (*((volatile uint32 *) 0xE000801C))
#define T1MR2          (*((volatile uint32 *) 0xE0008020))
#define T1MR3          (*((volatile uint32 *) 0xE0008024))
#define T1CCR          (*((volatile uint16 *) 0xE0008028))
#define T1CR0          (*((volatile uint32 *) 0xE000802C))
#define T1CR1          (*((volatile uint32 *) 0xE0008030))
#define T1CR2          (*((volatile uint32 *) 0xE0008034))
#define T1CR3          (*((volatile uint32 *) 0xE0008038))
#define T1EMR          (*((volatile uint16 *) 0xE000803C))
#define T1CTCR         (*((volatile uint8 *) 0xE0008070))
#define T1PWMCON       (*((volatile uint32 *) 0xE0008074))

/* Universal Asynchronous Receiver Transmitter 0 (UART0) */
#define U0RBR          (*((volatile uint8 *) 0xE000C000))
#define U0THR          (*((volatile uint8 *) 0xE000C000))
#define U0DLL          (*((volatile uint8 *) 0xE000C000))
#define U0DLM          (*((volatile uint8 *) 0xE000C004))
#define U0IER          (*((volatile uint32 *) 0xE000C004))
#define U0IIR          (*((volatile uint32 *) 0xE000C008))
#define U0FCR          (*((volatile uint8 *) 0xE000C008))
#define U0LCR          (*((volatile uint8 *) 0xE000C00C))
#define U0LSR          (*((volatile uint8 *) 0xE000C014))
#define U0SCR          (*((volatile uint8 *) 0xE000C01C))
#define U0ACR          (*((volatile uint32 *) 0xE000C020))
#define U0FDR          (*((volatile uint32 *) 0xE000C028))
#define U0TER          (*((volatile uint8 *) 0xE000C030))

/* Universal Asynchronous Receiver Transmitter 1 (UART1) */
#define U1RBR          (*((volatile uint8 *) 0xE0010000))
#define U1THR          (*((volatile uint8 *) 0xE0010000))
#define U1DLL          (*((volatile uint8 *) 0xE0010000))
#define U1DLM          (*((volatile uint8 *) 0xE0010004))
#define U1IER          (*((volatile uint32 *) 0xE0010004))
#define U1IIR          (*((volatile uint32 *) 0xE0010008))
#define U1FCR          (*((volatile uint8 *) 0xE0010008))
#define U1LCR          (*((volatile uint8 *) 0xE001000C))
#define U1MCR          (*((volatile uint8 *) 0xE0010010))
#define U1LSR          (*((volatile uint8 *) 0xE0010014))
#define U1MSR          (*((volatile uint8 *) 0xE0010018))
#define U1SCR          (*((volatile uint8 *) 0xE001001C))
#define U1ACR          (*((volatile uint32 *) 0xE0010020))
#define U1FDR          (*((volatile uint32 *) 0xE0010028))
#define U1TER          (*((volatile uint8 *) 0xE0010030))

/* Inter-Integrated Circuit interface 0 (I2C0) */
#define I2C0CONSET     (*((volatile uint8 *) 0xE001C000))
#define I2C0STAT       (*((volatile uint8 *) 0xE001C004))
#define I2C0DAT        (*((volatile uint8 *) 0xE001C008))
#define I2C0ADR        (*((volatile uint8 *) 0xE001C00C))
#define I2C0SCLH       (*((volatile uint16 *) 0xE001C010))
#define I2C0SCLL       (*((volatile uint16 *) 0xE001C014))
#define I2C0CONCLR     (*((volatile uint8 *) 0xE001C018))

/* Serial Peripheral Interface 0 (SPI0) */
#define S0SPCR         (*((volatile uint16 *) 0xE0020000))
#define S0SPSR         (*((volatile uint8 *) 0xE0020004))
#define S0SPDR         (*((volatile uint16 *) 0xE0020008))
#define S0SPCCR        (*((volatile uint8 *) 0xE002000C))
#define S0SPINT        (*((volatile uint8 *) 0xE002001C))

/* Real Time Clock (RTC) */
#define ILR            (*((volatile uint8 *) 0xE0024000))
#define CTC            (*((volatile uint16 *) 0xE0024004))
#define CCR            (*((volatile uint8 *) 0xE0024008))
#define CIIR           (*((volatile uint8 *) 0xE002400C))
#define AMR            (*((volatile uint8 *) 0xE0024010))
#define CTIME0         (*((volatile uint32 *) 0xE0024014))
#define CTIME1         (*((volatile uint32 *) 0xE0024018))
#define CTIME2         (*((volatile uint32 *) 0xE002401C))
#define SEC            (*((volatile uint8 *) 0xE0024020))
#define MIN            (*((volatile uint8 *) 0xE0024024))
#define HOUR           (*((volatile uint8 *) 0xE0024028))
#define DOM            (*((volatile uint8 *) 0xE002402C))
#define DOW            (*((volatile uint8 *) 0xE0024030))
#define DOY            (*((volatile uint16 *) 0xE0024034))
#define MONTH          (*((volatile uint8 *) 0xE0024038))
#define YEAR           (*((volatile uint16 *) 0xE002403C))
#define ALSEC          (*((volatile uint8 *) 0xE0024060))
#define ALMIN          (*((volatile uint8 *) 0xE0024064))
#define ALHOUR         (*((volatile uint8 *) 0xE0024068))
#define ALDOM          (*((volatile uint8 *) 0xE002406C))
#define ALDOW          (*((volatile uint8 *) 0xE0024070))
#define ALDOY          (*((volatile uint16 *) 0xE0024074))
#define ALMON          (*((volatile uint8 *) 0xE0024078))
#define ALYEAR         (*((volatile uint16 *) 0xE002407C))
#define PREINT         (*((volatile uint16 *) 0xE0024080))
#define PREFRAC        (*((volatile uint16 *) 0xE0024084))

/* Analog/Digital Converter (ADC) */
#define AD0CR           (*((volatile uint32 *) 0xE0034000))
#define AD0GDR          (*((volatile uint32 *) 0xE0034004))
#define AD0INTEN        (*((volatile uint32 *) 0xE003400C))
#define AD0DR0          (*((volatile uint32 *) 0xE0034010))
#define AD0DR1          (*((volatile uint32 *) 0xE0034014))
#define AD0DR2          (*((volatile uint32 *) 0xE0034018))
#define AD0DR3          (*((volatile uint32 *) 0xE003401C))
#define AD0DR4          (*((volatile uint32 *) 0xE0034020))
#define AD0DR5          (*((volatile uint32 *) 0xE0034024))
#define AD0DR6          (*((volatile uint32 *) 0xE0034028))
#define AD0DR7          (*((volatile uint32 *) 0xE003402C))
#define AD0STAT         (*((volatile uint32 *) 0xE0034030))

/* Inter-Integrated Circuit interface 1 (I2C1) */
#define I2C1CONSET     (*((volatile uint8 *) 0xE005C000))
#define I2C1STAT       (*((volatile uint8 *) 0xE005C004))
#define I2C1DAT        (*((volatile uint8 *) 0xE005C008))
#define I2C1ADR        (*((volatile uint8 *) 0xE005C00C))
#define I2C1SCLH       (*((volatile uint16 *) 0xE005C010))
#define I2C1SCLL       (*((volatile uint16 *) 0xE005C014))
#define I2C1CONCLR     (*((volatile uint8 *) 0xE005C018))

/* Synchronous Serial Port interface (SSP) */
#define SSPCR0         (*((volatile uint16 *) 0xE0068000))
#define SSPCR1         (*((volatile uint8 *) 0xE0068004))
#define SSPDR          (*((volatile uint16 *) 0xE0068008))
#define SSPSR          (*((volatile uint8 *) 0xE006800C))
#define SSPCPSR        (*((volatile uint8 *) 0xE0068010))
#define SSPIMSC        (*((volatile uint8 *) 0xE0068014))
#define SSPRIS         (*((volatile uint8 *) 0xE0068018))
#define SSPMIS         (*((volatile uint8 *) 0xE006801C))
#define SSPICR         (*((volatile uint8 *) 0xE0068020))

/* Timer 2 */
#define T2IR           (*((volatile uint8 *) 0xE0070000))
#define T2TCR          (*((volatile uint8 *) 0xE0070004))
#define T2TC           (*((volatile uint32 *) 0xE0070008))
#define T2PR           (*((volatile uint32 *) 0xE007000C))
#define T2PC           (*((volatile uint32 *) 0xE0070010))
#define T2MCR          (*((volatile uint16 *) 0xE0070014))
#define T2MR0          (*((volatile uint32 *) 0xE0070018))
#define T2MR1          (*((volatile uint32 *) 0xE007001C))
#define T2MR2          (*((volatile uint32 *) 0xE0070020))
#define T2MR3          (*((volatile uint32 *) 0xE0070024))
#define T2CCR          (*((volatile uint16 *) 0xE0070028))
#define T2CR0          (*((volatile uint32 *) 0xE007002C))
#define T2CR1          (*((volatile uint32 *) 0xE0070030))
#define T2CR2          (*((volatile uint32 *) 0xE0070034))
#define T2EMR          (*((volatile uint16 *) 0xE007003C))
#define T2CTCR         (*((volatile uint8 *) 0xE0070070))
#define T2PWMCON       (*((volatile uint32 *) 0xE0070074))

/* Timer 3 */
#define T3IR           (*((volatile uint8 *) 0xE0074000))
#define T3TCR          (*((volatile uint8 *) 0xE0074004))
#define T3TC           (*((volatile uint32 *) 0xE0074008))
#define T3PR           (*((volatile uint32 *) 0xE007400C))
#define T3PC           (*((volatile uint32 *) 0xE0074010))
#define T3MCR          (*((volatile uint16 *) 0xE0074014))
#define T3MR0          (*((volatile uint32 *) 0xE0074018))
#define T3MR4          (*((volatile uint32 *) 0xE007401C))
#define T3MR2          (*((volatile uint32 *) 0xE0074020))
#define T3MR3          (*((volatile uint32 *) 0xE0074024))
#define T3CCR          (*((volatile uint16 *) 0xE0074028))
#define T3CR0          (*((volatile uint32 *) 0xE007402C))
#define T3CR1          (*((volatile uint32 *) 0xE0074030))
#define T3CR2          (*((volatile uint32 *) 0xE0074034))
#define T3EMR          (*((volatile uint16 *) 0xE007403C))
#define T3CTCR         (*((volatile uint8 *) 0xE0074070))
#define T3PWMCON       (*((volatile uint32 *) 0xE0074074))

/* Reset Source Identification */
#define RSIR           (*((volatile uint8 *) 0xE01FC180))

/* Code Security Protection */
#define CPSR           (*((volatile uint32 *) 0xE01FC184))

/* Syscon Miscellaneous */
#define SCS            (*((volatile uint32 *) 0xE01FC1A0))

/* Watchdog timer */
#define WDMOD          (*((volatile uint8 *) 0xE0000000))
#define WDTC           (*((volatile uint32 *) 0xE0000004))
#define WDFEED         (*((volatile uint8 *) 0xE0000008))
#define WDTV           (*((volatile uint32 *) 0xE000000C))

#endif

