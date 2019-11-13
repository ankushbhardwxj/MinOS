#include "screen.h"
#include "../kernel/low_level.c"
/********Helper functions ***********/
int get_screen_offset(int col, int row){
    //we write bytes to those internal device registers
    int offset;
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    return offset;
}

int get_cursor(){
    //device uses control register as an index to select
    //its internal registers, of which we are interested in
    //reg 14: which is high byte of cursor offset
    //reg 15: which is low byte of the cursor offset
    port_byte_out(REG_SCREEN_CTRL,14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8;
    port_byte_out(REG_SCREEN_CTRL,15);
    offset += port_byte_in(REG_SCREEN_DATA);
    //since cursor offset returned by VGA hardware is number of char,
    //we multiply by 2 to convert it to char cell offset
    return offset*2;
}

int set_cursor(int offset){
    offset /= 2; //convert cell offset to char offset
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
    port_byte_out(REG_SCREEN_CTRL, 15);
    return offset;
}


/*******Scrolling functions ***********/
// void memory_copy(char * source, char * dest, int no_bytes){
//     int i;
//     for(i=0;i<no_bytes;i++){
//         *(dest + i) = *(source + i);
//     }
// }

// int handle_scrolling(int cursor_offset){
//     //if cursor is within the screen return it unmodified
//     if(cursor_offset< MAX_ROWS*MAX_COLS*2) return cursor_offset;
//     //shuffle the rows back one
//     int i;
//     for(i=1;i<MAX_ROWS;i++){
//         memory_copy((get_screen_offset(0,i) + VIDEO_ADDRESS),
//             (get_screen_offset(0,i-1) + VIDEO_ADDRESS),
//             (MAX_COLS*2)
//         );
//     }
//     //blank the last line by setting all bytes to 0
//     char *last_line = get_screen_offset(0,MAX_ROWS-1) + VIDEO_ADDRESS;
//     for(i=0;i<MAX_COLS*2;i++){
//         last_line[i] = 0;
//     }
//     cursor_offset -= 2*MAX_COLS;
//     return cursor_offset;
// }

/*********Print functions************/
//print a char on the screen at col, row, or at cursor position
void print_char(char character, int col, int row, char attribute_byte){
    //create a byte pointer to the start of video memory
    //this byte is the ascii code of the character
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
    //if attribute byte is zero, assume default style
    //attribute byte defines the color scheme
    if(!attribute_byte)
        attribute_byte = WHITE_ON_BLACK;
    //get the video memory offset for the screen location
    int offset;
    //if col and row are non negative then use for offset
    //other wise use current cursor position
    if(col>=0 && row>=0){
        offset = get_screen_offset(col,row);
    }else{
        offset = get_cursor();
    }
    //if we see a newline character, set offset to the end of the 
    //curr row so it will be advanced to the first column of the 
    //next row.Otherwise, write the char and its attribute byte to
    //video memory at our calculated offset.
    if(character == '\n'){
        int rows = offset / (2*MAX_COLS);
        offset = get_screen_offset(79, rows);
    }else{
        vidmem[offset] = character;
        vidmem[offset+1] = attribute_byte;
    }
    //update the offset to the next char cell, which is two bytes
    //ahead of curr cell. 
    offset += 2;
    //make scrolling adjustment, for when we reach bottom of screen
   // offset = handle_scrolling(offset);
    //update the cursor position on the screen device
    set_cursor(offset);
}

void clear_screen(){
    int row = 0; int col = 0;
    for(row=0;row<MAX_ROWS;row++){
        for(col=0;col<MAX_COLS;col++){
            print_char(' ',col,row,WHITE_ON_BLACK);
        }
    }

    set_cursor(get_screen_offset(0,0));
}

/*******String print functions*********/
void print_at(char* message, int col, int row){
    //update cursor if col and row not negative
    if(col>=0 && row >=0) 
        set_cursor(get_screen_offset(col,row));
    
    int i = 0;
    while(message[i]!=0){
        print_char(message[i++], col, row, WHITE_ON_BLACK);
    }
}

void print(char *message){
    print_at(message, -1, -1);
}