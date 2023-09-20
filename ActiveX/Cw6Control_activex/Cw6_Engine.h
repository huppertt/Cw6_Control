//This header contains the main control codes for interfacing to the Cw6


//****************************************************************************************
void CCw6Control_activexCtrl::Loadem(){
//This is called by the constructor.  The purpose of this function is to set the defaults and initialization
//of the Cw6 device

	bool failedFlag=true;


	//These are the defaults for the system
	m_isConnected=0;
	m_isRunning=0;
	m_samplesAvaliable=0;
	m_datarate=25;
	m_useTDM=false; 
	m_dwelltime=3;
	SavetoFile=false;
	samplesperread=262;


	for(int id=0; id<MAXDETECTORS; id++)
		DetGains[id]=0;
	for(id=0; id<MAXSOURCES; id++)
		LaserStates[id]=false;
	for(id=0; id<MAXDETECTORS*MAXSOURCES; id++)
		MeasLst[id]=true;  //by default record all signals

	LoadDLL();

	//open the device
	FT_STATUS status = OpenBy();
	ResetDevice();
	
	if(status!=FT_OK)
	{
		failedFlag=false;
	}


	//Set all the buffer defaults for the CW6

	status = SetDataCharacteristics(FT_BITS_8,FT_STOP_BITS_1,FT_PARITY_ODD);
	if(status!=FT_OK)
	{
		failedFlag=false;
	}
	status = SetBaudRate(FT_BAUD_9600);
	if(status!=FT_OK)
	{
		failedFlag=false;
	}

	status = SetFlowControl(FT_FLOW_NONE,1,1);
	if(status!=FT_OK)
	{
		failedFlag=false;
	}
	
	if(!failedFlag)
	{
		AfxMessageBox("FAILED to initialize Cw6");
		m_isConnected=0;
	}
	else{
		m_isConnected=1;
	}

	//Turn off all lasers to start
	status =SendSerial("LASR 00000000\r\n");
	SetDataRate(m_datarate);

	for(int StateIdx=0; StateIdx<NUMSTATES; StateIdx++)
	SetState(StateIdx); 


	m_hEventClose	= CreateEvent(NULL, FALSE, FALSE, NULL);
	pThreadRead	= AfxBeginThread(ReadThread, this, THREAD_PRIORITY_BELOW_NORMAL);
}


//****************************************************************************************
void CCw6Control_activexCtrl::SetLaserState(float LaserIdx, float LaserState) 
{
	// TODO: Add your dispatch handler code here

FT_STATUS status;


// TODO: Add your dispatch handler code here
	if(LaserState==1)
		LaserStates[int(LaserIdx)]=true;
	else
		LaserStates[int(LaserIdx)]=false;

	CString lsrmsg;

	CString msg;
	msg=bool2hex(LaserStates);

	lsrmsg.Format(_T("LASR %s\r\n"),msg);
	status =SendSerial(lsrmsg);
	

}
//****************************************************************************************
float CCw6Control_activexCtrl::GetLaserState(float LaserIdx) 
{
	if(LaserStates[int(LaserIdx)])
		return 1;

	return 0;
}

//****************************************************************************************
void CCw6Control_activexCtrl::StartDAQ() 
{
FT_STATUS status;

	
if(SavetoFile){
		//If auto-logging data
	
	char * pfilename ="D:\\Cw6\\TempDataFiles\\Cw6Data.cw6";
	CFileException e;

	if(!SavetoFileFile.Open(pfilename,CFile::modeCreate|CFile::modeWrite,&e)){
		//failed to open
		SavetoFile=false;
		AfxMessageBox("Failed to open data log file: CW6!"); 
	}
}

	//Clear out the buffer first;
	ResetDevice();


	SendMLtoDevice();


	while(!DataBuffer.empty())
		DataBuffer.pop();
	
	m_samplesAvaliable=0;
	
	if(m_useTDM)
		status =SendSerial("SEQ1 1\r\n");
	else{
		status =SendSerial("SEQ1 0\r\n");
		SetState(0);
	}
	
	Purge(FT_PURGE_RX);
	sleep(200);
	
	
	status =SendSerial("RUN_\r\n");
	
	FireStartCw6();
	m_samplesAvaliable=0;
	if(status==FT_OK)
		m_isRunning=true;
	else
		m_isRunning=false; 

}

//****************************************************************************************
void CCw6Control_activexCtrl::StopDAQ() 
{
FT_STATUS status;

status =SendSerial("STOP\r\n");

	if(status==FT_OK)
		m_isRunning=false;

sleep(200);
SetState(0);
sleep(200);
ChangeState(0);

if(SavetoFile){
	SavetoFileFile.Close();
}


}

//****************************************************************************************
void CCw6Control_activexCtrl::SetDataRate(float DataRate) 
{
FT_STATUS status;

	CString msg;
	msg.Format("RATE %f\r\n",DataRate);
	status =SendSerial(msg);

	if(status==FT_OK)
		m_datarate=DataRate;
}

float CCw6Control_activexCtrl::GetDataRate() 
{
	return m_datarate;
}

void CCw6Control_activexCtrl::SetDwellTime(float DwellTime) 
{
	// TODO: Add your dispatch handler code here
	m_dwelltime=DwellTime;
}

float CCw6Control_activexCtrl::GetDwellTime() 
{
	// TODO: Add your dispatch handler code here

	return m_dwelltime;
}

void CCw6Control_activexCtrl::SetState(float StateIdx) 
{
	// TODO: Add your dispatch handler code here
	// TODO: Add your dispatch handler code here
	if(StateIdx<=NUMSTATES){
	
	m_tdmstates[int(StateIdx)].dwelltime=m_dwelltime;
	
	for(int idx=0; idx<MAXDETECTORS; idx++)
		m_tdmstates[int(StateIdx)].DetGain[idx]=DetGains[idx];
	
	for(idx=0; idx<MAXSOURCES; idx++)
		m_tdmstates[int(StateIdx)].LaserStates[idx]=LaserStates[idx];
	
	for(idx=0; idx<MAXDETECTORS*MAXSOURCES; idx++)
		m_tdmstates[int(StateIdx)].measlst[idx]=MeasLst[idx];
	}

	SetTDMLStates(); 
}

//****************************************************************************************
void CCw6Control_activexCtrl::ChangeState(float StateIdx) 
{
// TODO: Add your dispatch handler code here
	if(StateIdx<=NUMSTATES){
		m_dwelltime=m_tdmstates[int(StateIdx)].dwelltime;
	
		for(int idx=0; idx<MAXDETECTORS; idx++){
			DetGains[idx]=m_tdmstates[int(StateIdx)].DetGain[idx];
			SetDetGains(float(idx),DetGains[idx]); 
		}
	
		for(idx=0; idx<MAXSOURCES; idx++){
			LaserStates[idx]=m_tdmstates[int(StateIdx)].LaserStates[idx];
			SetLaserState(float(idx),LaserStates[idx]);
		}
	
		for(idx=0; idx<MAXDETECTORS*MAXSOURCES; idx++){
			MeasLst[idx]=m_tdmstates[int(StateIdx)].measlst[idx];
			//SetMLAct(float(idx),MeasLst[idx]);
		}
	
	}

}

//****************************************************************************************
void CCw6Control_activexCtrl::SetDetGains(float DetIdx, float DetGain) 
{
	DetGains[int(DetIdx)]=DetGain;
	
	FT_STATUS status;

	CString msg;
	msg.Format("SETG %d %d\r\n",int(DetIdx+1),int(DetGain));
	status =SendSerial(msg);
}

//****************************************************************************************
short CCw6Control_activexCtrl::AllOff() 
{

	FT_STATUS status;
	// TODO: Add your dispatch handler code here
	status =SendSerial("LASR 00000000\r\n");

//	for(int idx=0; idx<MAXSOURCES; idx++)
//		SetLaserState(idx,0); 

	return 0;
}

//****************************************************************************************
float CCw6Control_activexCtrl::GetDetGains() 
{
	// TODO: Add your dispatch handler code here
	//float gain;
	//gain=DetGains[int(DetIndex)];
	return 0; //gain;  %OPPS!
	//This function was replaced by: CCw6Control_activexCtrl::GetDetGain(float DetIdx) 
}

//****************************************************************************************
void CCw6Control_activexCtrl::SetMLAct(float MLidx, float ActBool) 
{
	// TODO: Add your dispatch handler code here
	if(ActBool==1){
		MeasLst[int(MLidx)]=true;
	}
	else{
		MeasLst[int(MLidx)]=false;
	}

	samplesperread=0;
	for(int idx=0; idx<MAXSOURCES*MAXDETECTORS; idx++){
		if(MeasLst[idx])
			samplesperread++;

	}

}


//****************************************************************************************
float CCw6Control_activexCtrl::GetDetGain(float DetIdx) 
{
// TODO: Add your dispatch handler code here
	float gain;
	gain=DetGains[int(DetIdx)];
	return gain;
}


//****************************************************************************************
void CCw6Control_activexCtrl::SetUseTDML(float UseTDML) 
{
	if(UseTDML==0)
		m_useTDM=false;
	else
		m_useTDM=true;

	SetTDMLStates();
}

//****************************************************************************************
float CCw6Control_activexCtrl::getUseTDML() 
{
	// TODO: Add your dispatch handler code here

	if(m_useTDM)
		return 1;
	else
		return 0;
}


//****************************************************************************************
void CCw6Control_activexCtrl::SetTDMLStates() 
{
	// TODO: Add your dispatch handler code here

	//This function loads the TDM states into the Cw6

	FT_STATUS status;
	

if(!m_useTDM){
		status =SendSerial("SEQ1 0\r\n");
	return;
}

status =SendSerial("SEQ1 1\r\n");

sleep(100);

CString msg;
CString msgtmp;
int DetIdx;
CString lasmsg;
CString lasmsg2="0000";
int a;

	for(int stateNum=0; stateNum<NUMSTATES; stateNum++){
		//Send the laser status
		msg="";
		lasmsg=bool2hex(m_tdmstates[stateNum].LaserStates);
		for(a=0; a<4;a++)
			lasmsg2.SetAt(a,lasmsg.GetAt(4+a));

		msg.Format("LSR%d %s\r\n",stateNum+1,lasmsg2);
		status =SendSerial(msg);
		sleep(100);

		//Send the dwell time
	}
	for(stateNum=0; stateNum<NUMSTATES; stateNum++){
		msg="";
		msg.Format("REC%d %d\r\n",stateNum+1,int(m_tdmstates[stateNum].dwelltime));
		status =SendSerial(msg);
		sleep(100);
	}
	for(stateNum=0; stateNum<NUMSTATES; stateNum++){
		msg="";
		msg.Format("GST%d",stateNum+1);

		
		for(DetIdx=0; DetIdx<16; DetIdx=DetIdx+2){
			msgtmp.Format(" %d",int(m_tdmstates[stateNum].DetGain[DetIdx]));
			msg=msg+msgtmp;
		}
		for(DetIdx=1; DetIdx<16; DetIdx=DetIdx+2){
			msgtmp.Format(" %d",int(m_tdmstates[stateNum].DetGain[DetIdx]));
			msg=msg+msgtmp;
		}
		for(DetIdx=8; DetIdx<MAXDETECTORS; DetIdx=DetIdx+2){
			msgtmp.Format(" %d",int(m_tdmstates[stateNum].DetGain[DetIdx]));
			msg=msg+msgtmp;
		}
		for(DetIdx=9; DetIdx<MAXDETECTORS; DetIdx=DetIdx+2){
			msgtmp.Format(" %d",int(m_tdmstates[stateNum].DetGain[DetIdx]));
			msg=msg+msgtmp;
		}

		for(DetIdx=0; DetIdx<32-MAXDETECTORS; DetIdx++){
			msgtmp.Format(" %d",0);
			msg=msg+msgtmp;
		}
		msg=msg+"\r\n";
		status =SendSerial(msg);
		sleep(500);
	}
	
}

//****************************************************************************************
float CCw6Control_activexCtrl::GetSamplesAvaliable() 
{
	return m_samplesAvaliable; //samplesAvaliable;
}

//****************************************************************************************
float CCw6Control_activexCtrl::GetData(float nSamples) 
{
	// TODO: Add your dispatch handler code here

	double Data;

	if(m_samplesAvaliable>0){
		Data=DataBuffer.front();
		DataBuffer.pop();
		m_samplesAvaliable-=1;
	}
	else
		Data=9999;  //Default for bad data

	return (float)Data;
}

//****************************************************************************************
bool CCw6Control_activexCtrl::isrunning(){
	if(m_isRunning==1)
		return 1;
	else
		return 0;
}

//****************************************************************************************
void CCw6Control_activexCtrl::SendMLtoDevice(){
	//This function is called OnStart and needs to send the active ML to the Cw6

	FT_STATUS status;
	

	bool DetMask[MAXDETECTORS];
	bool SrcMask[MAXSOURCES];

	//first mask all the detectors
	for(int idx=0; idx<MAXDETECTORS; idx++){
		DetMask[idx]=false;
	}

	int cnt=0;


	CString lsrmsg;
	CString msg;
	
	//Laser frq mapping
	//[1 9 2 10 3 11 4 12 5 13 6 14 7 15 8 16 17 25 18 26 19 27 20 28 21 29 22 30 23 31 24 32];

	for(idx=0; idx<MAXDETECTORS; idx++){
		for(int srcidx=0; srcidx<MAXSOURCES; srcidx++){
			SrcMask[srcidx]=MeasLst[cnt];
			if(SrcMask[srcidx])
				DetMask[idx]=true;

			cnt++;
		}
		msg=bool2hex(SrcMask);

		lsrmsg.Format(_T("DSRC %d %08s\r\n"),idx+1,msg);
		//AfxMessageBox(lsrmsg);
		status =SendSerial(lsrmsg);
		sleep(50);
	}


	msg=bool2hex(DetMask);
	lsrmsg.Format(_T("DSEL %08s\r\n"),msg);
	status =SendSerial(lsrmsg);
	sleep(50);

	
}


//****************************************************************************************
void CCw6Control_activexCtrl::SetLogToFile(float UseLog) 
{
	// TODO: Add your dispatch handler code here
	if(UseLog==1)
		SavetoFile=true;
	else
		SavetoFile=false;

}

//****************************************************************************************
void CCw6Control_activexCtrl::AddData(double str,int cnt){
	
	DataBuffer.push(str);
	m_samplesAvaliable+=1;

	if(SavetoFile){
		char logstr[32];
		if(moduls(m_samplesAvaliable,samplesperread)==0)
			sprintf(logstr,"%f       \n\r",str);
		else
			sprintf(logstr,"%f       ",str);

		SavetoFileFile.Write(logstr,32);	
	
	}
	
}
