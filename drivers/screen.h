#define VIDEO_ADDRESS 0xb8000 //set video address for printing text / strings
//declare the size of the screen
#define MAX_ROWS 25
#define MAX_COLS 80
#define WHITE_ON_BLACK 0x0f //0x0f means 15 which indicates white color
#define RED_ON_WHITE 0xf4 //0xf4 represents red colour

//screen IO ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

//public kernel
void clear_screen(); //to clear the screen
void kprint_at(char *message, int col, int row); //print a message at specific place
void kprint(char *message);
