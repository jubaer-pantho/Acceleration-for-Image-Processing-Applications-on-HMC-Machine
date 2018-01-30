#define __STDC_FORMAT_MACROS
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <ctype.h>
#include <time.h>
#include <iostream>
#include <picodrv.h>
#include <pico_errors.h>
#include "../libim/im_short.h"
#include "../libim/im_color.h"
#include "../libim/im_float.h"
#include "../libim/im_complex.h"
#include <sys/time.h>

using namespace std;

uint16_t *image8;
im_short Input;
im_short Output;
int size16; 
int sizeImage;

void read_regs(PicoDrv* pico){
        int err;
        uint32_t buf_in[1];
        for(uint32_t address = 0x00010000; address <= 0x000100D4; address += 0x4){
                if((err = pico->ReadDeviceAbsolute(address, buf_in, 4)) != 4){
                        fprintf(stderr, "Error Reading: %d\n",err);
                }
                printf("Pico adress: %08x Content: %08x \n",address,buf_in[0]);
        }
}

/* Write the specified data to the PicoBus register at the specified address */
void write_reg(uint32_t address,uint32_t data, PicoDrv* pico){
        int err;
        printf("Trying to write %08x at Pico address %08x \n",data,address);
        if((err = pico->WriteDeviceAbsolute(address, &data, 4)) != 4){
                fprintf(stderr, "Error Writing: %d\n",err);
        }
        printf("Wrote %08x at Pico address %08x \n",data,address);

}


uint16_t *buf_out;
void read_ram(uint32_t address, uint32_t size, PicoDrv* pico){
        printf("Calling ReadRam() \n");
        
        char ibuf[1024];
        int err;

        buf_out = (uint16_t *) malloc(size);
        for(int i = 0; i < size; i= i + 16){
                if((i+ 16) < size) {
                        if ((err = pico->ReadRam(address + i, &buf_out[i/sizeof(uint16_t)], 16, 0)) < 0){fprintf(stderr, "Error Reading: %s\n",PicoErrors_FullError(err, ibuf, sizeof(ibuf)));}
		}
                else{
                        if ((err = pico->ReadRam(address + i, &buf_out[i/sizeof(uint16_t)], size-i, 0)) < 0){fprintf(stderr, "Error Reading: %s\n",PicoErrors_FullError(err, ibuf, sizeof(ibuf)));}
                }
		
        }
}


void write_ram(uint32_t address, uint32_t size, PicoDrv* pico){
        printf("Calling WriteRam() \n");
        uint16_t *buf_in;
        char ibuf[1024];
        int err;

        buf_in = (uint16_t *) malloc(size);
        for(int i = 0; i < (size/sizeof(uint16_t)); i++){
                buf_in[i] = Input.Data1D[i];

        }

        for(int i = 0; i < size; i= i + 1024){
                if((i + 1024) < size){
                        if ((err = pico->WriteRam(address + i, &buf_in[i/sizeof(uint16_t)], 1024, 0)) < 0) {fprintf(stderr, "Error Writing: %s\n",PicoErrors_FullError(err, ibuf, sizeof(ibuf)));};
                }
                else{
                        if ((err = pico->WriteRam(address + i, &buf_in[i/sizeof(uint16_t)], size-i, 0)) < 0) {fprintf(stderr, "Error Writing: %s\n",PicoErrors_FullError(err, ibuf, sizeof(ibuf)));};
                }
        }

}


int main(int argc, char* argv[]){
    int i, err;
    char ibuf[1024];    // Necessary for the Pico Framework
        PicoDrv* pico[6];       // Necessary for the Pico Framework
        uint32_t model = 0x510; // Necessary for the Pico Framework
        uint32_t hmc_address;
        uint32_t vector_size;
        uint32_t ticks;

	string Name1 ("sample.jpg");
	Input.ReadJpg((char *)Name1.c_str());
	sizeImage = Input.NumPixels;
    
        if(argc != 2){
                printf("no HMC address specified \n");
                return 0;
        }

        hmc_address = strtoul(argv[1],NULL,0);
        vector_size = sizeImage/8;

        printf("specified HMC address: %08x \n",hmc_address);
        printf("Finding an FPGA matching model = 0x%0X\n", model);
        if ((err = FindPico(model, pico)) < 0) {fprintf(stderr, "Error finding: %s\n",PicoErrors_FullError(err, ibuf, sizeof(ibuf)));};
        printf("Found FPGA.\n");
		

	clock_t begin = clock();	
        write_ram(hmc_address,16*vector_size,pico[0]); // changes
	clock_t end = clock();
	double time_writing = double(end-begin) / CLOCKS_PER_SEC;
		
		printf("Register values before operation:\n");
		read_regs(pico[0]);
		
        write_reg(0x00010000,hmc_address,pico[0]);      // Send address to FPGA
        write_reg(0x00010018,vector_size,pico[0]);      // Send vector size to FPGA
        printf("Enabling operation \n");
        write_reg(0x00010004,0xFFFFFFFF,pico[0]);       // Send start signal to FPGA
        
        
        sleep(3);       // Wait 6 seconds (magic number) for the FPGA to finish

	printf("Results of operation:\n");
        read_regs(pico[0]);
        hmc_address = vector_size*16;

	begin = clock();
        read_ram(hmc_address,vector_size*16*2,pico[0]);       // Check the result     
	end = clock();
	double time_read = double(end-begin) / CLOCKS_PER_SEC;
	
  
		Output.ReadJpg((char *)Name1.c_str());
		   for (int i=0;i< Input.NumPixels;i++)
			{
				Output.Data1D[i] =0;				
			}
			
			for (int i=0;i< Output.NumPixels;i++)
			{
				Output.Data1D[i] = (int) buf_out[i];				
			}
			string Name2 ("output1.jpg");
			Output.WriteJpg((char *)Name2.c_str());
			
printf("Time to write: %lf\n",time_writing);
printf("Time to read: %lf\n",time_read);


	/* Read the clock cycles needed and calculate the read data throughput */
	if((err = pico[0]->ReadDeviceAbsolute(0x00010008, &ticks, 4)) != 4){
			fprintf(stderr, "Error Reading: %d\n",err);
	}
	printf("ticks: %d \n",ticks);
	double time = ((ticks) / 4.0)/1000; // Time in ms
	printf("measured time: %f ms\n",time);
	double rate = vector_size*16/(time*1000); // Write data rate in MB/s
	printf("measured read data rate: %f MB/s \n",rate*2);
	printf("measured write data rate: %f MB/s \n",rate);	
	
    return 0;
}
