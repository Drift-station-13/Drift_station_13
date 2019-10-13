/*
	YORI MAP TOOL
	this was written for Drift station 13.
	TODO:
		- mapmerge ? [_]
		- dmm2tgm ? [_]
		- step fixer [X] ymap_rm_step
		- remove blank var blocks {} // 2nd pass [_]
	Compiling command: tcc ymap.c ymap_rm_step.c ycom.c
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ycom.h"

#include "ymap.h"

void proc_map(char * path){
	// load map
	char * file_path = path;
	int map_size = 0;
	char * map = ycom_read_entire_file(file_path, &map_size);
	if(map_size == 0){
		printf("map file is empty\n");
		exit(-1);
	}
	if(map == 0){
		printf("fucking map read returned a empty buffer.\n");
		exit(-1);
	}
	// mem for new map buff
	int extra_chars = 1024;
	char * new_map = malloc(map_size + 1 + extra_chars);
	memset(new_map, 0, map_size + 1 + extra_chars);
	// proc map
	map_remove_step_vars(map, map_size, new_map);
	// save map to file
	ycom_write_buff_to_file(file_path, new_map, strlen(new_map));
	printf("step_x & step_y removed from %s\n", path);
	// free ram used for map & new map
	free(map);
	free(new_map);
}

int main(int argc, char* argv[]){
	printf("Ymap DS13 2019, vr dev 1.\n");

	
	#ifdef DEV_NO_PRAM
		printf("Build with DEV_NO_PRAM defined.\n");
		printf("NEW PATH: %s\n", ycom_convert_os_path_format("/mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools/test.dmm"));
		proc_map("/mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools/test.dmm");
		return 0;
	#endif
	int i = 1;
	while(i < argc){
		printf("processing (%i/%i): %s\n", i, argc - 1, argv[i]);
		proc_map(argv[i]);
		i++;
	}
	
	if(argc < 2){
		printf("error: no maps or params where passed in.");
		return 0;
	}
	
	return 0;
}