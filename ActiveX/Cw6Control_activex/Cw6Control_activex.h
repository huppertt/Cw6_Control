#if !defined(AFX_CW6CONTROL_ACTIVEX_H__D5FDAA2C_1C6F_46BC_A85C_9237B618FAB4__INCLUDED_)
#define AFX_CW6CONTROL_ACTIVEX_H__D5FDAA2C_1C6F_46BC_A85C_9237B618FAB4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// Cw6Control_activex.h : main header file for CW6CONTROL_ACTIVEX.DLL

#if !defined( __AFXCTL_H__ )
	#error include 'afxctl.h' before including this file
#endif

#include "resource.h"       // main symbols
#include "FTD2XX.H"

/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexApp : See Cw6Control_activex.cpp for implementation.

class CCw6Control_activexApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CW6CONTROL_ACTIVEX_H__D5FDAA2C_1C6F_46BC_A85C_9237B618FAB4__INCLUDED)
