// TdmStates.h: interface for the CTdmStates class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TDMSTATES_H__61B059F3_6EC7_4498_A576_FF29824DD875__INCLUDED_)
#define AFX_TDMSTATES_H__61B059F3_6EC7_4498_A576_FF29824DD875__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Config.h"

class CTdmStates  
{
public:
	CTdmStates();
	virtual ~CTdmStates();

	float dwelltime;
	bool measlst[MAXDETECTORS*MAXSOURCES];
	float DetGain[MAXDETECTORS];
	bool LaserStates[MAXSOURCES];
	
};

#endif // !defined(AFX_TDMSTATES_H__61B059F3_6EC7_4498_A576_FF29824DD875__INCLUDED_)
