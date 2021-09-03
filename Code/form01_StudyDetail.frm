VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form01_StudyDetail 
   Caption         =   "Study Details"
   ClientHeight    =   3432
   ClientLeft      =   -384
   ClientTop       =   -1656
   ClientWidth     =   4260
   OleObjectBlob   =   "form01_StudyDetail.frx":0000
End
Attribute VB_Name = "form01_StudyDetail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Option Explicit

Private Sub UserForm_Activate()
    'PURPOSE: Reposition userform to Top Left of application Window and fix size
    'source: https://www.mrexcel.com/board/threads/userform-startup-position.671108/
    'Me.StartUpPosition = 0
    'Me.Top = Application.Top + 25
    'Me.Left = Application.Left + 25
    Me.Top = UserFormTopPos
    Me.Left = UserFormLeftPos
    Me.Height = UHeight
    Me.Width = UWidth

End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    'PURPOSE: On Close Userform this code saves the last Userform position to Defined Names
    'SOURCE: https://answers.microsoft.com/en-us/msoffice/forum/all/saving-last-position-of-userform/9399e735-9a9e-47c4-a1e0-e0d5cedd15ca
    UserFormTopPos = Me.Top
    UserFormLeftPos = Me.Left
End Sub

Private Sub UserForm_Initialize()
    'PURPOSE: Clear form on initialization
    'Source: https://www.contextures.com/xlUserForm02.html
    'Source: https://www.contextures.com/Excel-VBA-ComboBox-Lists.html
    Dim ctrl As MSForms.Control

    'Clear user form
    'source: https://www.mrexcel.com/board/threads/loop-through-controls-on-a-userform.427103/
    For Each ctrl In Me.Controls
        Select Case True
                Case TypeOf ctrl Is MSForms.CheckBox
                    ctrl.Value = False
                Case TypeOf ctrl Is MSForms.TextBox
                    ctrl.Value = ""
                Case TypeOf ctrl Is MSForms.ComboBox
                    ctrl.Value = ""
                    ctrl.Clear
                Case TypeOf ctrl Is MSForms.ListBox
                    ctrl.Value = ""
                    ctrl.Clear
            End Select
    Next ctrl
    
    'Highlight tab selected
    Me.tglStudyDetail.Value = True
    Me.tglStudyDetail.BackColor = vbGreen
    
    'Read information from register table
'    Me.txtSponsor
'    Me.txtCRO
'    Me.txtStudyName
'    Me.
    
End Sub

Private Sub cmdClose_Click()
    'PURPOSE: Closes current form
    Unload Me
    
    'Edit LastAccess log
    Call LogLastAccess
    
End Sub

Private Sub cmdEdit_Click()
    'PURPOSE: Apply changes into Register table
    With RegTable.ListRows(RowIndex)
        .Range(1) = RowIndex
        .Range(2) = Now
        .Range(3) = Username
        .Range(8) = "Current"
        .Range(9) = Me.txtProtocolNum.Value
        .Range(10) = StudyName
        .Range(11) = Me.txtSponsor.Value
        .Range(14) = .Range(2).Value
        .Range(15) = .Range(3).Value
    End With
    
End Sub


'----------------- Navigation section Toggles ----------------

Private Sub tglNav_Click()
    'PURPOSE: Closes current form and open Nav form
    Unload form01_StudyDetail
    
    form00_Nav.Show False
    
    'Edit LastAccess log
    Call LogLastAccess
    
End Sub

Private Sub tglCDA_FS_Click()
    'PURPOSE: Closes current form and open CDA / FS form
    Unload form01_StudyDetail
    
    form02_CDA_FS.Show False
End Sub

Private Sub tglSiteSelect_Click()
    'PURPOSE: Closes current form and open Site Select form
    Unload form01_StudyDetail
    
    form03_SiteSelect.Show False
End Sub

Private Sub tglReviews_Click()
    'PURPOSE: Closes current form and open Reviews form - Recruitment tab
    Unload form01_StudyDetail
    
    form041_Recruitment.Show False
End Sub

Private Sub tglCTRA_Click()
    'PURPOSE: Closes current form and open CTRA form
    Unload form01_StudyDetail
    
    form05_CTRA.Show False
End Sub

Private Sub tglFinDisc_Click()
    'PURPOSE: Closes current form and open Fin. Disc. form
    Unload form01_StudyDetail
    
    form06_FinDisc.Show False
End Sub

Private Sub tglSIV_Click()
    'PURPOSE: Closes current form and open SIV form
    Unload form01_StudyDetail
    
    form07_SIV.Show False
End Sub



