#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ycom.h"

#include "ymap.h"

// checks if char is in POS of array, returns false if out of bounds.
bool array_if_in_pos(char* arr, int arr_size, int x, char chr){
	if(x > 0 && x < arr_size){
		if(arr[x] == chr){
			return true;
		}
	}
	return false;
}

int new_file_char = 0;
void add_char(char * map, char chr){
	map[new_file_char] = chr;
	new_file_char++;
}

void map_remove_step_vars(char * map, int map_size, char * new_map){
	// RESET GLOBALS
	new_file_char = 0;
	
	int i = -1;
	int line_count = 1;
	
	//parser state
	int skip_chars = 0; // Skiped chars still get added to file
	bool comment_skip = false;
	bool parsing_key = false;
	bool parsing_key_obj_vars = false;
	bool skip_until_semi_colon = false; // Skiped chars do not get added. the var name is a bit of a lie it also ends on '}' but will still include it
	bool skip_string_in_key_var_obj = false;
	char skip_string_in_key_var_obj_end_char = '_';
	
	//parser loop
	printf("\n");
	while(i<map_size){
		i++;
		//printf("%c[2K", 27);
		//printf("(%i/%i)\n", i, map_size);
		char chr = map[i];
		
		if(skip_until_semi_colon){
			if(chr == ';'){
				skip_until_semi_colon = false;
			}else if(chr == '}'){
				add_char(new_map, chr);
				skip_until_semi_colon = false;
			}
			continue;
		}
		// if newline
		if(chr == '\n'){
			comment_skip = false;
			line_count++;
			add_char(new_map, chr);
			continue;
		}else if(comment_skip || skip_chars > 0){
			skip_chars--;
			add_char(new_map, chr);
			continue;
		}
		// if comment
		if(chr == '/' && array_if_in_pos(map, map_size, i+1, '/')){
			comment_skip = true;
			add_char(new_map, chr);
			continue;
		}
		// "XXX" = (     // aka the start key def
		if(chr == '"' && array_if_in_pos(map, map_size, i+4, '"') && array_if_in_pos(map, map_size, i+6, '=') && array_if_in_pos(map, map_size, i+8, '(')){
			skip_chars = 8;
			parsing_key = true;
			add_char(new_map, chr);
			continue;
		}
		// PARSING INSIDE OF KEY DEF
		if(parsing_key){
			// fast forward string
			if(chr == '"' || "'"){
				if(skip_string_in_key_var_obj == false || skip_string_in_key_var_obj_end_char == chr){
					if(skip_string_in_key_var_obj){
						skip_string_in_key_var_obj = false;
						skip_string_in_key_var_obj_end_char = '_';
					}else{
						skip_string_in_key_var_obj = true;
						skip_string_in_key_var_obj_end_char = chr;
					}
				}
				add_char(new_map, chr);
				continue;
			}
			if(skip_string_in_key_var_obj){
				add_char(new_map, chr);
				continue;
			}
			// ends the key
			if(chr == ')'){
				parsing_key = false;
				add_char(new_map, chr);
				continue;
			}
			//obj, tile or terf var def
			if(chr == '{'){
				parsing_key_obj_vars = true;
			}
				
				if(parsing_key_obj_vars){
					//step_x step_y
					if(chr == 's' && array_if_in_pos(map, map_size, i+1, 't') && array_if_in_pos(map, map_size, i+2, 'e') && array_if_in_pos(map, map_size, i+3, 'p') && array_if_in_pos(map, map_size, i+4, '_')){
						if(array_if_in_pos(map, map_size, i+5, 'x') || array_if_in_pos(map, map_size, i+5, 'y')){
							skip_until_semi_colon = true;
							continue;
						}
					}
				}
			
			if(chr == '}'){
				parsing_key_obj_vars = false;
			}
			
			add_char(new_map, chr);
			continue;
		}
		add_char(new_map, chr);
	}
}