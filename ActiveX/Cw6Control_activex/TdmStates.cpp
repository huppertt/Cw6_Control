// TdmStates.cpp: implementation of the CTdmStates class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "TdmStates.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTdmStates::CTdmStates()
{

	dwelltime=25;
	
	for(int idx=0; idx<MAXDETECTORS*MAXSOURCES; idx++)
		measlst[idx]=false;

	for(idx=0; idx<MAXDETECTORS; idx++)
		DetGain[idx]=1;
	
	for(idx=0; idx<MAXSOURCES; idx++)
		LaserStates[idx]=false;

}

CTdmStates::~CTdmStates()
{

}
