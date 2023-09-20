// Cw6Control_activexPpg.cpp : Implementation of the CCw6Control_activexPropPage property page class.

#include "stdafx.h"
#include "Cw6Control_activex.h"
#include "Cw6Control_activexPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CCw6Control_activexPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CCw6Control_activexPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CCw6Control_activexPropPage)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CCw6Control_activexPropPage, "CW6CONTROLACTIVEX.Cw6ControlactivexPropPage.1",
	0x472bf005, 0xc47a, 0x4231, 0x87, 0x97, 0x78, 0x9c, 0xa6, 0x89, 0x83, 0x75)


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexPropPage::CCw6Control_activexPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CCw6Control_activexPropPage

BOOL CCw6Control_activexPropPage::CCw6Control_activexPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_CW6CONTROL_ACTIVEX_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexPropPage::CCw6Control_activexPropPage - Constructor

CCw6Control_activexPropPage::CCw6Control_activexPropPage() :
	COlePropertyPage(IDD, IDS_CW6CONTROL_ACTIVEX_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CCw6Control_activexPropPage)
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexPropPage::DoDataExchange - Moves data between page and properties

void CCw6Control_activexPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CCw6Control_activexPropPage)
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexPropPage message handlers
