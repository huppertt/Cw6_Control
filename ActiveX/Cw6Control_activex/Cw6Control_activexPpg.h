#if !defined(AFX_CW6CONTROL_ACTIVEXPPG_H__B3D53F57_117D_450F_9F35_1EF9289000EB__INCLUDED_)
#define AFX_CW6CONTROL_ACTIVEXPPG_H__B3D53F57_117D_450F_9F35_1EF9289000EB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

// Cw6Control_activexPpg.h : Declaration of the CCw6Control_activexPropPage property page class.

////////////////////////////////////////////////////////////////////////////
// CCw6Control_activexPropPage : See Cw6Control_activexPpg.cpp.cpp for implementation.

class CCw6Control_activexPropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CCw6Control_activexPropPage)
	DECLARE_OLECREATE_EX(CCw6Control_activexPropPage)

// Constructor
public:
	CCw6Control_activexPropPage();

// Dialog Data
	//{{AFX_DATA(CCw6Control_activexPropPage)
	enum { IDD = IDD_PROPPAGE_CW6CONTROL_ACTIVEX };
	//}}AFX_DATA

// Implementation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Message maps
protected:
	//{{AFX_MSG(CCw6Control_activexPropPage)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CW6CONTROL_ACTIVEXPPG_H__B3D53F57_117D_450F_9F35_1EF9289000EB__INCLUDED)
