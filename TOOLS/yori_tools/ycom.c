#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "ycom.h"

char * ycom_read_entire_file(char * path, int * len){
	FILE *fp;
	int fs = 0;

	fp = fopen(path, "rb");
	if(fp==0){
		printf("ycom_read_entire_file> can't open: %s\n", path);
		exit(-1);
	}
	fseek(fp, 0, SEEK_END);
	fs = ftell(fp);
	rewind(fp);

	char * out = malloc(fs + 1);
	if(out==0){
		printf("ycom_read_entire_file> malloc failed, while opening: %s\n", path);
		exit(-1);
	}
	fread(out, 1, fs, fp);
	out[fs] = 0;
	
	fclose(fp);
	*len = fs;
	return out;
}

void ycom_write_buff_to_file(char * path, char * buff, int size){
	FILE *fp;
	fp = fopen(path, "wb");
	if(fp==0){
		printf("ycom_write_buff_to_file> can't write to: %s\n", path);
		exit(-1);
	}
	fwrite(buff, size, 1, fp);
	fclose(fp);
}

char * ycom_convert_os_path_format(char * path){
	// this is usefull for WSL: C:\Users\Yori\Desktop\SpesMen\Drift_station_13\TOOLS\yori_tools --> /mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools
	#ifdef OS_PATH_FORMAT_WSL
		int path_len = strlen(path);
		#ifdef _WIN32
			if(path[0] == '/' && path[1] == 'm' && path[2] == 'n' && path[3] == 't' && path[4] == '/' && path[6] == '/'){
				char drive = path[5];
				if(drive>=97 && drive<=122){
					drive = drive -32; // converts it to an upper case
				}
				char * ret_path = malloc(path_len);
				// Building our new path
				sprintf(ret_path, "%c:\\%s", drive, path + 7);
				path = ret_path;
			}
		#else
			//C:\Users\Yori\Desktop\SpesMen\Drift_station_13\TOOLS\yori_tools --> /mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools
			if(path[1] == ':' && path[2] == '\\'){
				char drive = path[0];
				if(drive>=65 && drive<=90){
					drive = drive +32; // converts it to an lower case
				}
				char * ret_path = malloc(path_len + 10);
				sprintf(ret_path, "/mnt/%c/%s", drive, path + 3);
				path = ret_path;
			}
		#endif
	#endif
	for(int i = 0; path[i] != 0; i++){
		#ifdef _WIN32
			if(path[i] == '/'){
				path[i] = '\\';
			}
		#else
			if(path[i] == '\\'){
				path[i] = '/';
			}
		#endif
	}
	return path;
}