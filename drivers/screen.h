//define some constants to make code readable in screen.c
#define VIDEO_ADDRESS 0xb8000 //display buffer address
//define the screen resolution
#define MAX_ROWS 25
#define MAX_COLS 80
//set default color scheme - White on black
//color scheme number is 15 denoted by 0x0f
#define WHITE_ON_BLACK 0x0f

//screen device I/O ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5
