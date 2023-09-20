#if !defined(AFX_CW6CONTROL_ACTIVEXCTL_H__79C227EB_1100_4D9A_BB13_1B2CC9D5E831__INCLUDED_)
#define AFX_CW6CONTROL_ACTIVEXCTL_H__79C227EB_1100_4D9A_BB13_1B2CC9D5E831__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// Cw6Control_activexCtl.h : Declaration of the CCw6Control_activexCtrl ActiveX Control class.
#include "FTD2XX.H"
#include "Config.h"
#include "TdmStates.h"
#include <queue>
#include <cstdlib>

#define COM_BUF_SIZE	256

typedef struct ComBuffer {
	char cBuf[COM_BUF_SIZE];
	int size;
} COMBUFFER, *PCOMBUFFER;

#define TEXTSIZE 256

using namespace std;

/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexCtrl : See Cw6Control_activexCtl.cpp for implementation.

class CCw6Control_activexCtrl : public COleControl
{
	DECLARE_DYNCREATE(CCw6Control_activexCtrl)

// Constructor
public:
	CCw6Control_activexCtrl();

	void SetTDMStates();
	void AddData(double,int);
	float DetGains[MAXDETECTORS];
	bool LaserStates[MAXSOURCES];
	bool MeasLst[MAXDETECTORS*MAXSOURCES];
	float m_datarate;
	bool m_useTDM;
	float m_dwelltime;
	int samplesperread;
	
	bool SavetoFile;
	CFile SavetoFileFile;	
	
	CTdmStates m_tdmstates[NUMSTATES];

	bool m_stop_thread;
	bool isrunning();

	CWinThread * pThreadRead;
	HANDLE m_hEventClose;

	queue<double> DataBuffer;
	

	FT_STATUS CCw6Control_activexCtrl::OpenBy();
	FT_STATUS CCw6Control_activexCtrl::Write(LPVOID, DWORD, LPDWORD);
	FT_STATUS CCw6Control_activexCtrl::SendSerial(CString);
	FT_STATUS CCw6Control_activexCtrl::Read(LPVOID, DWORD, LPDWORD);
	FT_STATUS SetEventNotification(DWORD, PVOID);
	FT_STATUS GetStatus(LPDWORD, LPDWORD, LPDWORD);	


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCw6Control_activexCtrl)
	public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();
	//}}AFX_VIRTUAL

// Implementation
protected:
	~CCw6Control_activexCtrl();
	void SendMLtoDevice();

	BEGIN_OLEFACTORY(CCw6Control_activexCtrl)        // Class factory and guid
		virtual BOOL VerifyUserLicense();
		virtual BOOL GetLicenseKey(DWORD, BSTR FAR*);
	END_OLEFACTORY(CCw6Control_activexCtrl)

	DECLARE_OLETYPELIB(CCw6Control_activexCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CCw6Control_activexCtrl)     // Property page IDs
	DECLARE_OLECTLTYPE(CCw6Control_activexCtrl)		// Type name and misc status

HMODULE m_hmodule;
	FT_HANDLE m_ftHandle;
	void LoadDLL();
	void Loadem();


	typedef FT_STATUS (WINAPI *PtrToOpen)(PVOID, FT_HANDLE *); 
	PtrToOpen m_pOpen; 
	FT_STATUS Open(PVOID);

	typedef FT_STATUS (WINAPI *PtrToOpenEx)(PVOID, DWORD, FT_HANDLE *); 
	PtrToOpenEx m_pOpenEx; 
	FT_STATUS OpenEx(PVOID, DWORD);

	typedef FT_STATUS (WINAPI *PtrToListDevices)(PVOID, PVOID, DWORD);
	PtrToListDevices m_pListDevices; 
	FT_STATUS ListDevices(PVOID, PVOID, DWORD);

	typedef FT_STATUS (WINAPI *PtrToClose)(FT_HANDLE);
	PtrToClose m_pClose;
	FT_STATUS Close();

	typedef FT_STATUS (WINAPI *PtrToRead)(FT_HANDLE, LPVOID, DWORD, LPDWORD);
	PtrToRead m_pRead;
	//FT_STATUS Read(LPVOID, DWORD, LPDWORD);

	typedef FT_STATUS (WINAPI *PtrToWrite)(FT_HANDLE, LPVOID, DWORD, LPDWORD);
	PtrToWrite m_pWrite;
	//FT_STATUS Write(LPVOID, DWORD, LPDWORD);

	typedef FT_STATUS (WINAPI *PtrToResetDevice)(FT_HANDLE);
	PtrToResetDevice m_pResetDevice;
	FT_STATUS ResetDevice();
	
	typedef FT_STATUS (WINAPI *PtrToPurge)(FT_HANDLE, ULONG);
	PtrToPurge m_pPurge;
	FT_STATUS Purge(ULONG);
	
	typedef FT_STATUS (WINAPI *PtrToSetTimeouts)(FT_HANDLE, ULONG, ULONG);
	PtrToSetTimeouts m_pSetTimeouts;
	FT_STATUS SetTimeouts(ULONG, ULONG);

	typedef FT_STATUS (WINAPI *PtrToGetQueueStatus)(FT_HANDLE, LPDWORD);
	PtrToGetQueueStatus m_pGetQueueStatus;
	FT_STATUS GetQueueStatus(LPDWORD);

	typedef FT_STATUS (WINAPI *PtrToSetBaudRate)(FT_HANDLE, ULONG);
	PtrToSetBaudRate m_pSetBaudRate;
	FT_STATUS SetBaudRate(ULONG);

	typedef FT_STATUS (WINAPI *PtrToSetDataCharacteristics)(FT_HANDLE, UCHAR, UCHAR, UCHAR);
	PtrToSetDataCharacteristics m_pSetDataCharacteristics;
	FT_STATUS SetDataCharacteristics(UCHAR, UCHAR, UCHAR);

	typedef FT_STATUS (WINAPI *PtrToSetFlowControl)(FT_HANDLE, USHORT, UCHAR, UCHAR);
	PtrToSetFlowControl m_pSetFlowControl;
	FT_STATUS SetFlowControl(USHORT, UCHAR, UCHAR);

	typedef FT_STATUS (WINAPI *PtrToSetEventNotification)(FT_HANDLE, DWORD, PVOID);
	PtrToSetEventNotification m_pSetEventNotification;
	//FT_STATUS SetEventNotification(DWORD, PVOID);
	
	typedef FT_STATUS (WINAPI *PtrToGetStatus)(FT_HANDLE, LPDWORD, LPDWORD, LPDWORD);
	PtrToGetStatus m_pGetStatus;
	//FT_STATUS GetStatus(LPDWORD, LPDWORD, LPDWORD);	
	
// Message maps
	//{{AFX_MSG(CCw6Control_activexCtrl)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

// Dispatch maps
	//{{AFX_DISPATCH(CCw6Control_activexCtrl)
	float m_isConnected;
	float m_isRunning;
	float m_samplesAvaliable;
	afx_msg void SetLaserState(float LaserIdx, float LaserState);
	afx_msg float GetLaserState(float LaserIdx);
	afx_msg void StartDAQ();
	afx_msg void StopDAQ();
	afx_msg void SetDataRate(float DataRate);
	afx_msg float GetDataRate();
	afx_msg void SetDwellTime(float DwellTime);
	afx_msg float GetDwellTime();
	afx_msg void SetState(float StateIdx);
	afx_msg void ChangeState(float StateIdx);
	afx_msg void SetDetGains(float DetIdx, float DetGain);
	afx_msg short AllOff();
	afx_msg float GetDetGains();
	afx_msg void SetMLAct(float MLidx, float ActBool);
	afx_msg float GetDetGain(float DetIdx);
	afx_msg void SetUseTDML(float UseTDML);
	afx_msg float getUseTDML();
	afx_msg void SetTDMLStates();
	afx_msg float GetData(float nSamples);
	afx_msg float GetSamplesAvaliable();
	afx_msg void SetLogToFile(float UseLog);
	afx_msg float getNumAux();
	afx_msg void AllOn();
	//}}AFX_DISPATCH
	DECLARE_DISPATCH_MAP()

// Event maps
	//{{AFX_EVENT(CCw6Control_activexCtrl)
	void FireStartCw6()
		{FireEvent(eventidStartCw6,EVENT_PARAM(VTS_NONE));}
	//}}AFX_EVENT
	DECLARE_EVENT_MAP()

// Dispatch and event IDs
public:
	enum {
	//{{AFX_DISP_ID(CCw6Control_activexCtrl)
	dispidIsConnected = 1L,
	dispidIsRunning = 2L,
	dispidSamplesAvaliable = 3L,
	dispidSetLaserState = 4L,
	dispidGetLaserState = 5L,
	dispidStartDAQ = 6L,
	dispidStopDAQ = 7L,
	dispidSetDataRate = 8L,
	dispidGetDataRate = 9L,
	dispidSetDwellTime = 10L,
	dispidGetDwellTime = 11L,
	dispidSetState = 12L,
	dispidChangeState = 13L,
	dispidSetDetGains = 14L,
	dispidAllOff = 15L,
	dispidGetDetGains = 16L,
	dispidSetMLAct = 17L,
	dispidGetDetGain = 18L,
	dispidSetUseTDML = 19L,
	dispidGetUseTDML = 20L,
	dispidSetTDMLStates = 21L,
	dispidGetData = 22L,
	dispidGetSamplesAvaliable = 23L,
	dispidSetLogToFile = 24L,
	dispidGetNumAux = 25L,
	dispidAllOn = 26L,
	eventidStartCw6 = 1L,
	//}}AFX_DISP_ID
	};
};



//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CW6CONTROL_ACTIVEXCTL_H__79C227EB_1100_4D9A_BB13_1B2CC9D5E831__INCLUDED)
