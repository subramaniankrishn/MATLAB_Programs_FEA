// MyHelloDlg.cpp : implementation file
//

#include "stdafx.h"
#include "App_hello.h"
#include "MyHelloDlg.h"
#include "afxdialogex.h"
#include "string.h"
#include "string"
using namespace std;

// CMyHelloDlg dialog

IMPLEMENT_DYNAMIC(CMyHelloDlg, CDialogEx)

CMyHelloDlg::CMyHelloDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(IDD_DIALOG1, pParent)
{

}

CMyHelloDlg::~CMyHelloDlg()
{
}

void CMyHelloDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CMyHelloDlg, CDialogEx)
	ON_BN_CLICKED(IDC_BUTTON1, &CMyHelloDlg::OnBnClickedButton1)
END_MESSAGE_MAP()


// CMyHelloDlg message handlers

static int _numTimesPressed = 0;

void CMyHelloDlg::OnBnClickedButton1()
{
	CString cstr;
	GetDlgItemText(IDC_STATIC, cstr);
	if (_numTimesPressed<=1)
		cstr = _T("You executed 1 time ");
	else
	{
		char char_arr[1024];
		sprintf_s(char_arr, "You executed %d times", _numTimesPressed);
		cstr = char_arr;
	}

	_numTimesPressed++;

	SetDlgItemText(IDC_STATIC, cstr);
}
