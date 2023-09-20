#include "Config.h"
#include <math.h>
#include <iostream>
using namespace std;

double moduls(double a, double b)
{
	int result = static_cast<int>( a / b );
	return a - static_cast<double>( result ) * b;
}

CString bool2hex(bool valueIn[MAXSOURCES]){

	char temp[8];
	char tmp2;

	int cnt;
	cnt=0;
	for(int idx=0; idx<MAXSOURCES; idx++){
	if(valueIn[idx]==true)
		cnt+=int(pow(double(2),idx));
	}
	
	
	int val;
	for(int idx=7; idx>-1; idx=idx-1){
		char tmp2;
		val=static_cast<int>(cnt/pow(double(16),idx));
		//val=cnt/pow(double(16),idx);
		
		sprintf(&tmp2,"%X",val);
		temp[idx]=tmp2;
		cnt=int(cnt) % int(pow(double(16),idx));
	}
	
	CString valueOut;
	valueOut="";
	for(int idx=7; idx>-1; idx=idx-1){
		valueOut+=temp[idx];
	}
	
	return valueOut;
}

