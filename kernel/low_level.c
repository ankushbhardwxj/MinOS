//low level functions required by the I/O port
//stores =a data of AL in result and d stores port address
unsigned char port_byte_in(unsigned short port){
    unsigned char result;
    __asm__("in %%dx, %%al" : "=a " ( result ) : "d" ( port ));
    return result;
}
//load EAX with data nad EDX with port
void port_byte_out(unsigned short port, unsigned char data){
    __asm__("out %%al, %%dx" : :"a" ( data ) , "d" ( port ));
}

unsigned char port_word_in(unsigned short port){
    unsigned char result;
    __asm__("in %%dx, %%ax" : "=a" ( result ) : "d" ( port ));
    return result;
}
void port_word_out(unsigned short port, unsigned char data){
    __asm__("out %%ax, %%dx" : :"a" ( data ) , "d" ( port ));
}
