#include <time.h>

void sleep(int timewait){

clock_t goal=timewait+clock();
while(goal>clock());

}