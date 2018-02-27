#pragma once


// CMyHelloDlg dialog

class CMyHelloDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CMyHelloDlg)

public:
	CMyHelloDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CMyHelloDlg();

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_DIALOG1 };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButton1();
};
