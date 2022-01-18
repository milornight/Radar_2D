/*
 * servomoteur.cpp
 *
 *  Created on: 6 janv. 2021
 *      Author: YANG Liyun
 */

#include "servomoteur.hpp"
#include "system.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
//#include <sys/man.h>

//#define iowrite32(v,a) *((unsigned int*)(a)) = (v)
//#define ioread32(a) (*((unsigned int*)(a)))

//#define AVALON_SERVOMO_0_POSITION
//#define FPGA_REGS_SPAN 0x100

int main(){
	volatile unsigned int position;
	//unsigned int angle;
	//unsigned int angle2;

	//volatile unsigned int *avalon_servomo_addr=NULL;
	printf("Commence la mesure\n");
	//avalon_servomo_addr = mmap(NULL,FPGA_REGS_SPAN, (PROT_READ | PROT_WRITE),MAP_SHARED, fd, HW_REGS_BASE);
	while(1){
		usleep(10000);
		IOWD_AVALON_ANGLE((position&0xFF),AVALON_SERVOMO_0_BASE);
		//angle = IORD_AVALON_ANGLE(AVALON_SERVOMO_0_BASE);
		//angle2 = *(unsigned int*)angle;
		position ++;
		if (position > 180){
			position = 0;
		}
		printf("\POSITION = %d\n",position);
		//printf("Angle = %x \t %d \n", angle&0xFFFF, angle2&0xFFFF);
	}
}




