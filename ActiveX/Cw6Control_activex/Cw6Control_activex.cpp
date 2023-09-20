// Cw6Control_activex.cpp : Implementation of CCw6Control_activexApp and DLL registration.

#include "stdafx.h"
#include "Cw6Control_activex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


CCw6Control_activexApp NEAR theApp;

const GUID CDECL BASED_CODE _tlid =
		{ 0x250d0b4c, 0xd2df, 0x44f0, { 0x8c, 0x93, 0xc7, 0x89, 0x49, 0xd1, 0xe7, 0x4 } };
const WORD _wVerMajor = 1;
const WORD _wVerMinor = 0;


////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexApp::InitInstance - DLL initialization

BOOL CCw6Control_activexApp::InitInstance()
{
	BOOL bInit = COleControlModule::InitInstance();

	if (bInit)
	{
	
	}

	return bInit;
}


////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexApp::ExitInstance - DLL termination

int CCw6Control_activexApp::ExitInstance()
{
	return COleControlModule::ExitInstance();
}


/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleRegisterTypeLib(AfxGetInstanceHandle(), _tlid))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(TRUE))
		return ResultFromScode(SELFREG_E_CLASS);

	return NOERROR;
}


/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleUnregisterTypeLib(_tlid, _wVerMajor, _wVerMinor))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(FALSE))
		return ResultFromScode(SELFREG_E_CLASS);

	return NOERROR;
}

