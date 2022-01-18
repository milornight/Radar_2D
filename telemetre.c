/*
 * telemetre.c
 *
 *  Created on: 29 nov. 2020
 *      Author: YANG
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "system.h"
#include "avalon_telemetre_mesure.h"
int main(){
	int distance;
	printf("Telemetre mesure\n");
	IOWR_AVALON_DISTANCE(AVALON_PWM_0_BASE,0x00);
	while(1){
		usleep(100000);
		distance = IORD_AVALON_DISTANCE(AVALON_PWM_0_BASE);
		printf("Distance = %d cm\n",distance);
	}
	return 0;
}



