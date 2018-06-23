#include <stdio.h>
#include <fcntl.h>  //open
#include <unistd.h> //getopt
#include <string.h> //memset
#include <stdlib.h> //strtol

//gcc genlogo.c -o .gen_header;./.gen_header logo_header.bin -t 60 -w 1920 -h 1080 -a 0x22000000 -s 0x40000;rm .gen_header


typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

typedef struct __attribute__((packed)) {
    u8 	magic_prefix[4];       //"LOGO"
    u32 dipslay_buffer_size;   //Hex
    u64 dipslay_buffer_start;  //Hex
    u16 width;            //Dec
    u16 high;             //Dec
    u8 pixel_clock;      //Dec
    u8 padding[11];
}  ST_LOGO_HEADER;

ST_LOGO_HEADER logo_header;

int main(int argc, char *argv[]) {
    int fd;
	int result;
    int i=0;
	printf("sizeof header: %lu\n", sizeof(ST_LOGO_HEADER));
    memset(&logo_header, 0, sizeof(ST_LOGO_HEADER));
	memcpy(logo_header.magic_prefix,"LOGO",4);

    while((result = getopt(argc, argv, "w:h:t:a:s:")) != -1 ) 
	{
        switch(result) {
        case 'w': {
            logo_header.width=strtol(optarg, NULL, 10);
        }
        break;
        case 'h': {
            logo_header.high=strtol(optarg, NULL, 10);
        }
        break;
        case 't': {
            logo_header.pixel_clock=strtol(optarg, NULL, 10);
        }
        break;
        case 'a': {
            logo_header.dipslay_buffer_start=strtol(optarg, NULL, 16);
        }
        break;
        case 's': {
            logo_header.dipslay_buffer_size=strtol(optarg, NULL, 16);
        }
        break;
        default:
			printf("no argv");
        }
    }

	
    fd = open(argv[argc-1],  O_CREAT | O_RDWR | O_TRUNC, 0777);
	if(fd ==-1)
	{
		printf("open %s failed\n", argv[argc-1]);
		return 0;
	}
    write(fd, &logo_header, sizeof(ST_LOGO_HEADER));
    close(fd);

	printf("dipslay_start=0x%08x\n", (unsigned int)(logo_header.dipslay_buffer_start));
	printf("dipslay_size=0x%08x\n", (unsigned int)(logo_header.dipslay_buffer_size));
	printf("width=%d \thex:0x%04x\n", logo_header.width, logo_header.width);
	printf("high=%d \thex:0x%04x\n", logo_header.high, logo_header.high);
	printf("pixel_clock=%d \thex:0x%02x\n", logo_header.pixel_clock, logo_header.pixel_clock);

    return 0;
}
