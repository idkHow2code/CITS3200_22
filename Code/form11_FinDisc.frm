VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form11_FinDisc 
   Caption         =   "Financial Disclosure"
   ClientHeight    =   5010
   ClientLeft      =   -480
   ClientTop       =   -1980
   ClientWidth     =   7320
   OleObjectBlob   =   "form11_FinDisc.frx":0000
End
Attribute VB_Name = "form11_FinDisc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub UserForm_Activate()
    'PURPOSE: Reposition userform to Top Left of application Window and fix size
    'source: https://www.mrexcel.com/board/threads/userform-startup-position.671108/
    Me.Top = UserFormTopPos
    Me.Left = UserFormLeftPos
    Me.Height = UHeight
    Me.Width = UWidth

End Sub

Private Sub UserForm_Deactivate()
    'Store form position
    UserFormTopPos = Me.Top
    UserFormLeftPos = Me.Left
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
                Case TypeOf ctrl Is MSForms.Label
                    'Empty error captions
                    If Left(ctrl.Name, 3) = "err" Then
                        ctrl.Caption = ""
                    End If
                Case TypeOf ctrl Is MSForms.ComboBox
                    ctrl.Value = ""
                    ctrl.Clear
                Case TypeOf ctrl Is MSForms.ListBox
                    ctrl.Value = ""
                    ctrl.Clear
            End Select
    Next ctrl
    
    'Read information from register table
    With RegTable.ListRows(RowIndex)
        Me.txtStudyName.Value = .Range(10).Value
        Me.txtFinDisc_Complete.Value = Format(.Range(108).Value, "dd-mmm-yyyy")
        Me.txtReminder.Value = .Range(109).Value
    End With
    
    'Access version control
    Call LogLastAccess
    
    'Depress and make toggle green on nav bar
    Me.tglFinDisc.Value = True
    Me.tglFinDisc.BackColor = vbGreen
    
    'Run date validation on data entered
    Call txtFinDisc_Complete_AfterUpdate
    
End Sub

Private Sub txtFinDisc_Complete_AfterUpdate()
    'PURPOSE: Validate date entered
    Dim err As String
    
    err = Date_Validation(Me.txtFinDisc_Complete)
    
    'Display error message
    Me.errFinDisc_Complete.Caption = err
    
    'Change date format displayed
    If IsDate(Me.txtFinDisc_Complete.Value) Then
        Me.txtFinDisc_Complete.Value = Format(Me.txtFinDisc_Complete.Value, "dd-mmm-yyyy")
    End If
    
End Sub

Private Sub cmdClose_Click()
    'PURPOSE: Closes current form
    
    'Access version control
    Call LogLastAccess
    
    Unload Me
    
End Sub

Private Sub cmdEdit_Click()
    'PURPOSE: Apply changes into Register table
    With RegTable.ListRows(RowIndex)
        
        .Range(108) = String_to_Date(Me.txtFinDisc_Complete.Value)
        .Range(109) = Me.txtReminder.Value
        
        'Apply completion status
        .Range(138).Value = IsDate(.Range(108).Value)
    
        'Update version control
        .Range(110) = Now
        .Range(111) = Username
    End With
    
    'Access version control
    Call LogLastAccess
    
    Call UserForm_Initialize

End Sub


'----------------- Navigation section Toggles ----------------

Private Sub tglNav_Click()
    'PURPOSE: Closes current form and open Nav form
    Unload form06_FinDisc
    
    form00_Nav.Show False
End Sub

Private Sub tglStudyDetail_Click()
    'PURPOSE: Closes current form and open Study Details form
    Unload form06_FinDisc
    
    form01_StudyDetail.Show False
End Sub

Private Sub tglCDA_FS_Click()
    'PURPOSE: Closes current form and open CDA / FS form
    Unload form06_FinDisc
    
    form02_CDA_FS.Show False
    form02_CDA_FS.multiCDA_FS.Value = 0
End Sub

Private Sub tglSiteSelect_Click()
    'PURPOSE: Closes current form and open Site Selection form
    Unload form06_FinDisc
    
    form03_SiteSelect.Show False
End Sub

Private Sub tglReviews_Click()
    'PURPOSE: Closes current form and open Reviews form - Recruitment tab
    Unload form06_FinDisc
    
    form041_Recruitment.Show False
End Sub

Private Sub tglCTRA_Click()
    'PURPOSE: Closes current form and open CTRA form
    Unload form06_FinDisc
    
    form05_CTRA.Show False
End Sub

Private Sub tglSIV_Click()
    'PURPOSE: Closes current form and open SIV form
    Unload form06_FinDisc
    
    form07_SIV.Show False
End Sub
