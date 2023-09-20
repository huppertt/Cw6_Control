//
//	Name: ReadThread
//
//
//	Purpose:	Continually receives characters from the serial port if available
//				Also checks for unplug events (new feature in driver)
//

#include "FTD2XX.H"
#include "Config.h"
#include "ieee2float.h"


UINT ReadThread (LPVOID pArg) 
{
    DWORD dwBytes = 0, dwError;
    BYTE szText[TEXTSIZE], *pPtr;
	CCw6Control_activexCtrl *pMyHndl = (CCw6Control_activexCtrl *)pArg;

	CString str;
	FT_STATUS ftStatus;
	HANDLE hEvent; 
	DWORD EventMask, dwWaitReturn; 
	HANDLE ahEvents[2];

	hEvent = CreateEvent( 	 
				NULL, 
				false, // auto-reset event 
				false, // non-signalled state 
				NULL 
				); 

	ahEvents[0] = hEvent;
	ahEvents[1] = pMyHndl->m_hEventClose;
	EventMask = FT_EVENT_RXCHAR | FT_NOTIFY_ON_UNPLUG; 
	ftStatus = pMyHndl->SetEventNotification(EventMask, hEvent); 

	bool ReadRunning = true;
	
	//
	// Infinite loop to read from port until close
	//
unsigned char localchar[4];
double f;


    while (ReadRunning & !pMyHndl->m_stop_thread) {
		DWORD dwRxQueue, dwTxQueue, dwEventStatus;
		char cBuf[16384];
    
		pPtr = szText;
		if(pMyHndl->isrunning()){
					
			ahEvents[0] = hEvent;
		ahEvents[1] = pMyHndl->m_hEventClose;
		dwWaitReturn = WaitForMultipleObjects(2, ahEvents, FALSE, INFINITE);

		if((dwWaitReturn - WAIT_OBJECT_0) == 0) {
			//
			// Read/Unplug Event
			//

			ftStatus = pMyHndl->GetStatus(&dwRxQueue, &dwTxQueue, &dwEventStatus);
			if(ftStatus == FT_OK) {
				if(dwEventStatus & FT_EVENT_RXCHAR) {
				if(dwRxQueue) {
					ftStatus = pMyHndl->Read(
								cBuf, 
								(4*static_cast<int>(dwRxQueue/4)), 
								&dwBytes);
					
					if(ftStatus == FT_OK) {
						
						if(dwBytes) {
							for(int i = 0; i < dwBytes; i+=4) {
								
								localchar[0]=cBuf[i];
								localchar[1]=cBuf[i+1];
								localchar[2]=cBuf[i+2];
								localchar[3]=cBuf[i+3];

								f=ieee2float(localchar,1);
								
								pMyHndl->AddData(f,1);	
								}
							dwBytes = 0;
						}		
					}
				}
			}
			else {
				dwBytes = 0;
				dwError = ::GetLastError();
				if((dwError == ERROR_GEN_FAILURE) || (dwError == ERROR_INVALID_HANDLE)) {
						ReadRunning=false;
			}
						
			}
			}
				
			}
			EventMask = FT_EVENT_RXCHAR | FT_NOTIFY_ON_UNPLUG; 
			ftStatus = pMyHndl->SetEventNotification(EventMask, hEvent); 
		}
	
    }

    return 0;
}

