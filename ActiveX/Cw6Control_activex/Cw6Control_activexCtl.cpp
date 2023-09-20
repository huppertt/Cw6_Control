// Cw6Control_activexCtl.cpp : Implementation of the CCw6Control_activexCtrl ActiveX Control class.

#include "stdafx.h"
#include "Cw6Control_activex.h"
#include "Cw6Control_activexCtl.h"
#include "Cw6Control_activexPpg.h"
#include "FTD2XX.H"
#include "Config.h"
#include "TdmStates.h"
#include <math.h>
#include "bool2hex.h"
#include "ReadThread.h"
#include "wait.h"
#include <afx.h>
#include "Cw6_Engine.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CCw6Control_activexCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map
 
BEGIN_MESSAGE_MAP(CCw6Control_activexCtrl, COleControl)
	//{{AFX_MSG_MAP(CCw6Control_activexCtrl)
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_EDIT, OnEdit)
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CCw6Control_activexCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CCw6Control_activexCtrl)
	DISP_PROPERTY(CCw6Control_activexCtrl, "isConnected", m_isConnected, VT_R4)
	DISP_PROPERTY(CCw6Control_activexCtrl, "isRunning", m_isRunning, VT_R4)
	DISP_PROPERTY(CCw6Control_activexCtrl, "samplesAvaliable", m_samplesAvaliable, VT_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetLaserState", SetLaserState, VT_EMPTY, VTS_R4 VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetLaserState", GetLaserState, VT_R4, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "StartDAQ", StartDAQ, VT_EMPTY, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "StopDAQ", StopDAQ, VT_EMPTY, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetDataRate", SetDataRate, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetDataRate", GetDataRate, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetDwellTime", SetDwellTime, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetDwellTime", GetDwellTime, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetState", SetState, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "ChangeState", ChangeState, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetDetGains", SetDetGains, VT_EMPTY, VTS_R4 VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "AllOff", AllOff, VT_I2, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetDetGains", GetDetGains, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetMLAct", SetMLAct, VT_EMPTY, VTS_R4 VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetDetGain", GetDetGain, VT_R4, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetUseTDML", SetUseTDML, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "getUseTDML", getUseTDML, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetTDMLStates", SetTDMLStates, VT_EMPTY, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetData", GetData, VT_R4, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "GetSamplesAvaliable", GetSamplesAvaliable, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "SetLogToFile", SetLogToFile, VT_EMPTY, VTS_R4)
	DISP_FUNCTION(CCw6Control_activexCtrl, "getNumAux", getNumAux, VT_R4, VTS_NONE)
	DISP_FUNCTION(CCw6Control_activexCtrl, "AllOn", AllOn, VT_EMPTY, VTS_NONE)
	//}}AFX_DISPATCH_MAP
END_DISPATCH_MAP()


UINT ReadThread (LPVOID pArg);

/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CCw6Control_activexCtrl, COleControl)
	//{{AFX_EVENT_MAP(CCw6Control_activexCtrl)
	EVENT_CUSTOM("StartCw6", FireStartCw6, VTS_NONE)
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

BEGIN_PROPPAGEIDS(CCw6Control_activexCtrl, 1)
	PROPPAGEID(CCw6Control_activexPropPage::guid)
END_PROPPAGEIDS(CCw6Control_activexCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CCw6Control_activexCtrl, "CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1",
	0x3b1fb2af, 0xf28f, 0x4dec, 0xb0, 0x2c, 0xd6, 0x1f, 0x86, 0x90, 0x3, 0xcf)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CCw6Control_activexCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DCw6Control_activex =
		{ 0x8e338152, 0x99b1, 0x41b8, { 0xb9, 0xf1, 0x56, 0x9a, 0x63, 0x2e, 0x1c, 0xe } };
const IID BASED_CODE IID_DCw6Control_activexEvents =
		{ 0xfb3124e2, 0x5a5b, 0x4736, { 0xb2, 0xcd, 0x34, 0xce, 0xbc, 0x26, 0xee, 0x21 } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwCw6Control_activexOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CCw6Control_activexCtrl, IDS_CW6CONTROL_ACTIVEX, _dwCw6Control_activexOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CCw6Control_activexCtrl

BOOL CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO: Verify that your control follows apartment-model threading rules.
	// Refer to MFC TechNote 64 for more information.
	// If your control does not conform to the apartment-model rules, then
	// you must modify the code below, changing the 6th parameter from
	// afxRegInsertable | afxRegApartmentThreading to afxRegInsertable.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_CW6CONTROL_ACTIVEX,
			IDB_CW6CONTROL_ACTIVEX,
			afxRegInsertable | afxRegApartmentThreading,
			_dwCw6Control_activexOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// Licensing strings

static const TCHAR BASED_CODE _szLicFileName[] = _T("Cw6Control_activex.lic");

static const WCHAR BASED_CODE _szLicString[] =
	L"Copyright (c) 2008 University of Pittsburgh";


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::VerifyUserLicense -
// Checks for existence of a user license

BOOL CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::VerifyUserLicense()
{
	return AfxVerifyLicFile(AfxGetInstanceHandle(), _szLicFileName,
		_szLicString);
}


//****************************************************************************************
// CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::GetLicenseKey -
// Returns a runtime licensing key

BOOL CCw6Control_activexCtrl::CCw6Control_activexCtrlFactory::GetLicenseKey(DWORD dwReserved,
	BSTR FAR* pbstrKey)
{
	if (pbstrKey == NULL)
		return FALSE;

	*pbstrKey = SysAllocString(_szLicString);
	return (*pbstrKey != NULL);
}


//****************************************************************************************
// CCw6Control_activexCtrl::CCw6Control_activexCtrl - Constructor

CCw6Control_activexCtrl::CCw6Control_activexCtrl()
{
	InitializeIIDs(&IID_DCw6Control_activex, &IID_DCw6Control_activexEvents);
	Loadem();  //Load the DLL and test for presence of Cw6
	
	m_stop_thread=false;
	FT_STATUS status=SendSerial("STOP\r\n");
	status =SendSerial("LASR 00000000\r\n");
	status =ResetDevice();
}


//****************************************************************************************
// CCw6Control_activexCtrl::~CCw6Control_activexCtrl - Destructor

CCw6Control_activexCtrl::~CCw6Control_activexCtrl()
{
	m_stop_thread=true;
	FT_STATUS status=SendSerial("STOP\r\n");
	status =SendSerial("LASR 00000000\r\n");
	status =ResetDevice();
	status =Close();
}


//****************************************************************************************
// CCw6Control_activexCtrl::OnDraw - Drawing function

void CCw6Control_activexCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	//pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	//pdc->Ellipse(rcBounds);

}


//****************************************************************************************
// CCw6Control_activexCtrl::DoPropExchange - Persistence support

void CCw6Control_activexCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

}


//****************************************************************************************
// CCw6Control_activexCtrl::OnResetState - Reset control to default state

void CCw6Control_activexCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange
}


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexCtrl message handlers
//****************************************************************************************
void CCw6Control_activexCtrl::LoadDLL()
{//This is the function to load the FTD driver

	m_hmodule = LoadLibrary("Ftd2xx.dll");	
	if(m_hmodule == NULL)
	{
		AfxMessageBox("Error: Can't Load ft8u245.dll");
		return;
	}

	m_pWrite = (PtrToWrite)GetProcAddress(m_hmodule, "FT_Write");
	if (m_pWrite == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_Write");
		return;
	}

	m_pRead = (PtrToRead)GetProcAddress(m_hmodule, "FT_Read");
	if (m_pRead == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_Read");
		return;
	}

	m_pOpen = (PtrToOpen)GetProcAddress(m_hmodule, "FT_Open");
	if (m_pOpen == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_Open");
		return;
	}

	m_pOpenEx = (PtrToOpenEx)GetProcAddress(m_hmodule, "FT_OpenEx");
	if (m_pOpenEx == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_OpenEx");
		return;
	}

	m_pListDevices = (PtrToListDevices)GetProcAddress(m_hmodule, "FT_ListDevices");
	if(m_pListDevices == NULL)
		{
			AfxMessageBox("Error: Can't Find FT_ListDevices");
			return;
		}

	m_pClose = (PtrToClose)GetProcAddress(m_hmodule, "FT_Close");
	if (m_pClose == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_Close");
		return;
	}

	m_pResetDevice = (PtrToResetDevice)GetProcAddress(m_hmodule, "FT_ResetDevice");
	if (m_pResetDevice == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_ResetDevice");
		return;
	}

	m_pPurge = (PtrToPurge)GetProcAddress(m_hmodule, "FT_Purge");
	if (m_pPurge == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_Purge");
		return;
	}

	m_pSetTimeouts = (PtrToSetTimeouts)GetProcAddress(m_hmodule, "FT_SetTimeouts");
	if (m_pSetTimeouts == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_SetTimeouts");
		return;
	}

	m_pGetQueueStatus = (PtrToGetQueueStatus)GetProcAddress(m_hmodule, "FT_GetQueueStatus");
	if (m_pGetQueueStatus == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_GetQueueStatus");
		return;
	}

	m_pSetDataCharacteristics = (PtrToSetDataCharacteristics)GetProcAddress(m_hmodule, "FT_SetDataCharacteristics");
	if (m_pSetDataCharacteristics == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_SetDataCharacteristics");
		return;
	}

	m_pSetBaudRate = (PtrToSetBaudRate)GetProcAddress(m_hmodule, "FT_SetBaudRate");
	if (m_pSetBaudRate == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_SetBaudRate");
		return;
	}

	m_pSetFlowControl = (PtrToSetFlowControl)GetProcAddress(m_hmodule, "FT_SetFlowControl");
	if (m_pSetFlowControl == NULL)
	{
		AfxMessageBox("Error: Can't Find FT_SetFlowControl");
		return;
	}

	m_pGetStatus = (PtrToGetStatus)GetProcAddress(m_hmodule, TEXT("FT_GetStatus"));
	if (m_pGetStatus == NULL)
	{
		AfxMessageBox(TEXT("Error: Can't Find FT_GetStatus"));
		return;
	}

	m_pSetEventNotification = (PtrToSetEventNotification)GetProcAddress(m_hmodule, TEXT("FT_SetEventNotification"));
	if (m_pSetEventNotification == NULL)
	{
		AfxMessageBox(TEXT("Error: Can't Find FT_SetEventNotification"));
		return;
	}

}	


//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::SetDataCharacteristics(UCHAR uWordLength,UCHAR uStopBits,UCHAR uParity)
{
	
	if (!m_pSetDataCharacteristics)
	{
		AfxMessageBox("FT_SetDataCharacteristics is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	return (*m_pSetDataCharacteristics)(m_ftHandle,uWordLength,uStopBits,uParity);
}

//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::SetFlowControl(USHORT usFlowControl, UCHAR uxon, UCHAR uxoff)
{
	
	if (!m_pSetFlowControl)
	{
		AfxMessageBox("FT_SetFlowControl is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	return (*m_pSetFlowControl)(m_ftHandle,usFlowControl, uxon, uxoff);
}

;
//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::OpenBy()
{
	
	FT_STATUS status;
	ULONG x=0;
	status = Open((PVOID)x);//load default device 0
	return status;
}

//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::Open(PVOID pvDevice)
{
	if (!m_pOpen)
	{
		AfxMessageBox("FT_Open is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	
	return (*m_pOpen)(pvDevice, &m_ftHandle );
}	

//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::Close()
{
	if (!m_pClose)
	{
		AfxMessageBox("FT_Close is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	
	return (*m_pClose)(m_ftHandle);
}	



//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::ResetDevice()
{
	if (!m_pResetDevice)
	{
		AfxMessageBox("FT_ResetDevice is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	
	return (*m_pResetDevice)(m_ftHandle);
}	



//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::SetBaudRate(ULONG dwMask)
{
	if (!m_pSetBaudRate)
	{
		AfxMessageBox("FT_setbaudrate is not valid!"); 
		return FT_INVALID_HANDLE;
	}

	return (*m_pSetBaudRate)(m_ftHandle, dwMask);
}	

//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::Purge(ULONG dwMask)
{
	if (!m_pPurge)
	{
		AfxMessageBox("FT_Purge is not valid!"); 
		return FT_INVALID_HANDLE;
	}

	return (*m_pPurge)(m_ftHandle, dwMask);
}	



//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::Write(LPVOID lpvBuffer, DWORD dwBuffSize, LPDWORD lpdwBytes)
{
	if (!m_pWrite)
	{
		AfxMessageBox("FT_Write is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	
	return (*m_pWrite)(m_ftHandle, lpvBuffer, dwBuffSize, lpdwBytes);
}	

//****************************************************************************************

FT_STATUS CCw6Control_activexCtrl::Read(LPVOID lpvBuffer, DWORD dwBuffSize, LPDWORD lpdwBytes)
{
	//ResetDevice();
	if (!m_pRead)
	{
		AfxMessageBox("FT_Read is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	
	return (*m_pRead)(m_ftHandle, lpvBuffer, dwBuffSize, lpdwBytes);
}	


//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::SendSerial(CString msg){

//This function issues the commands to the Cw6
	//ResetDevice();

	DWORD BytesWritten;
	DWORD BuffSize;
	LPVOID Buffer;
	Buffer=(char *)(LPCTSTR)msg;
	BuffSize=msg.GetLength();
	
	FT_STATUS status;
	status=Write(Buffer,BuffSize,&BytesWritten);

	return status;
}



//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::GetQueueStatus(LPDWORD dwMask)
{
	if (!m_pGetQueueStatus)
	{
		AfxMessageBox("FT_GetQueueStatus is not valid!"); 
		return FT_INVALID_HANDLE;
	}
	return (*m_pGetQueueStatus)(m_ftHandle, dwMask);
}	




//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::SetEventNotification(DWORD dwEventMask, PVOID pvArg)
{
	if (!m_pSetEventNotification)
	{
		AfxMessageBox(TEXT("FT_SetEventNotification is not valid!")); 
		return FT_INVALID_HANDLE;
	}

	return (*m_pSetEventNotification)(m_ftHandle, dwEventMask, pvArg);
}


//****************************************************************************************
FT_STATUS CCw6Control_activexCtrl::GetStatus(LPDWORD lpdwAmountInRxQueue, LPDWORD lpdwAmountInTxQueue, LPDWORD lpdwEventStatus )
{
	if (!m_pGetStatus)
	{
		AfxMessageBox(TEXT("FT_GetStatus is not valid!")); 
		return FT_INVALID_HANDLE;
	}

	return (*m_pGetStatus)(m_ftHandle, lpdwAmountInRxQueue, lpdwAmountInTxQueue, lpdwEventStatus);
}



float CCw6Control_activexCtrl::getNumAux() 
{
	// TODO: Add your dispatch handler code here

	return MAXAUX;
}

void CCw6Control_activexCtrl::AllOn() 
{
	// TODO: Add your dispatch handler code here
	FT_STATUS status;
	// TODO: Add your dispatch handler code here
	status =SendSerial("LASR FFFFFFFF\r\n");
}
