
// App_helloView.h : interface of the CApp_helloView class
//

#pragma once


class CApp_helloView : public CView
{
protected: // create from serialization only
	CApp_helloView();
	DECLARE_DYNCREATE(CApp_helloView)

// Attributes
public:
	CApp_helloDoc* GetDocument() const;

// Operations
public:

// Overrides
public:
	virtual void OnDraw(CDC* pDC);  // overridden to draw this view
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
protected:
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);

// Implementation
public:
	virtual ~CApp_helloView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generated message map functions
protected:
	afx_msg void OnFilePrintPreview();
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnContextMenu(CWnd* pWnd, CPoint point);
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnToolsHello();
};

#ifndef _DEBUG  // debug version in App_helloView.cpp
inline CApp_helloDoc* CApp_helloView::GetDocument() const
   { return reinterpret_cast<CApp_helloDoc*>(m_pDocument); }
#endif

