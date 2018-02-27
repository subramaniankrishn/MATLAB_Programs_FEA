
// App_helloView.cpp : implementation of the CApp_helloView class
//

#include "stdafx.h"
// SHARED_HANDLERS can be defined in an ATL project implementing preview, thumbnail
// and search filter handlers and allows sharing of document code with that project.
#ifndef SHARED_HANDLERS
#include "App_hello.h"
#endif

#include "App_helloDoc.h"
#include "App_helloView.h"
#include "MyHelloDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CApp_helloView

IMPLEMENT_DYNCREATE(CApp_helloView, CView)

BEGIN_MESSAGE_MAP(CApp_helloView, CView)
	// Standard printing commands
	ON_COMMAND(ID_FILE_PRINT, &CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, &CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, &CApp_helloView::OnFilePrintPreview)
	ON_WM_CONTEXTMENU()
	ON_WM_RBUTTONUP()
	ON_COMMAND(ID_TOOLS_HELLO, &CApp_helloView::OnToolsHello)
END_MESSAGE_MAP()

// CApp_helloView construction/destruction

CApp_helloView::CApp_helloView()
{
	// TODO: add construction code here

}

CApp_helloView::~CApp_helloView()
{
}

BOOL CApp_helloView::PreCreateWindow(CREATESTRUCT& cs)
{
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	return CView::PreCreateWindow(cs);
}

// CApp_helloView drawing

void CApp_helloView::OnDraw(CDC* /*pDC*/)
{
	CApp_helloDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	if (!pDoc)
		return;

	// TODO: add draw code for native data here
}


// CApp_helloView printing


void CApp_helloView::OnFilePrintPreview()
{
#ifndef SHARED_HANDLERS
	AFXPrintPreview(this);
#endif
}

BOOL CApp_helloView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// default preparation
	return DoPreparePrinting(pInfo);
}

void CApp_helloView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add extra initialization before printing
}

void CApp_helloView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// TODO: add cleanup after printing
}

void CApp_helloView::OnRButtonUp(UINT /* nFlags */, CPoint point)
{
	ClientToScreen(&point);
	OnContextMenu(this, point);
}

void CApp_helloView::OnContextMenu(CWnd* /* pWnd */, CPoint point)
{
#ifndef SHARED_HANDLERS
	theApp.GetContextMenuManager()->ShowPopupMenu(IDR_POPUP_EDIT, point.x, point.y, this, TRUE);
#endif
}


// CApp_helloView diagnostics

#ifdef _DEBUG
void CApp_helloView::AssertValid() const
{
	CView::AssertValid();
}

void CApp_helloView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CApp_helloDoc* CApp_helloView::GetDocument() const // non-debug version is inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CApp_helloDoc)));
	return (CApp_helloDoc*)m_pDocument;
}
#endif //_DEBUG


// CApp_helloView message handlers


void CApp_helloView::OnToolsHello()
{
	CMyHelloDlg dlg;
	dlg.DoModal();
}
