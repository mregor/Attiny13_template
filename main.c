/*
 * tiny13_board_blink
 * Демо-прошивка отладочной платы на ATtiny13
 * с целью проверки работоспособности МК.
 * Мигаем светодиодом.
 */ 

// 1.2 MHz (default) built in resonator
#define F_CPU 1200000UL
#define __AVR_ATtiny13A__

#include <avr/io.h>
#include <util/delay.h>

#define LED_BIT1 _BV(PB4)
#define LED_BIT2 _BV(PB3)

int main()
{
	uint8_t i = 0;
	DDRB |= (LED_BIT1 | LED_BIT2); // OUTPUT

	while (1)
	{
		for(i=0; i<3; i++)
		{
			PORTB |= LED_BIT1;
			_delay_ms(70);
			PORTB &= ~LED_BIT1;
			_delay_ms(70);
		}
		_delay_ms(150);

		for(i=0; i<3; i++)
		{
			PORTB |= LED_BIT2;
			_delay_ms(70);
			PORTB &= ~LED_BIT2;
			_delay_ms(70);
		}
		_delay_ms(150);
	}
}