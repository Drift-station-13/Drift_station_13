#ifndef YCOM_H
	#define YCOM_H
	
	#define OS_PATH_FORMAT_WSL
	// ycom_convert_os_path_format will convert WSL paths to windows paths & windows paths to WSL paths
	// C:\Users\Yori\Desktop\SpesMen\Drift_station_13\TOOLS\yori_tools --> /mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools (if runing in posix)
	// /mnt/c/Users/Yori/Desktop/SpesMen/Drift_station_13/TOOLS/yori_tools --> C:\Users\Yori\Desktop\SpesMen\Drift_station_13\TOOLS\yori_tools (if runing in win32)
	
	char * ycom_read_entire_file(char * path, int * len);
	void ycom_write_buff_to_file(char * path, char * buff, int size);
	char * ycom_convert_os_path_format(char * path);
#endif