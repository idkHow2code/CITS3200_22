VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form07_SIV 
   Caption         =   "Financial Disclosure"
   ClientHeight    =   5016
   ClientLeft      =   -432
   ClientTop       =   -1884
   ClientWidth     =   7368
   OleObjectBlob   =   "form07_SIV.frx":0000
End
Attribute VB_Name = "form07_SIV"
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
                    ctrl.value = False
                Case TypeOf ctrl Is MSForms.TextBox
                    ctrl.value = ""
                Case TypeOf ctrl Is MSForms.Label
                    'Empty error captions
                    If Left(ctrl.Name, 3) = "err" Then
                        ctrl.Caption = ""
                    End If
                Case TypeOf ctrl Is MSForms.ComboBox
                    ctrl.value = ""
                    ctrl.Clear
                Case TypeOf ctrl Is MSForms.ListBox
                    ctrl.value = ""
                    ctrl.Clear
            End Select
    Next ctrl
    
    'Read information from register table
    With RegTable.ListRows(RowIndex)
        Me.txtStudyName.value = .Range(10).value
        Me.txtSIV_Date.value = Format(.Range(112).value, "dd-mmm-yyyy")
        Me.txtReminder.value = .Range(113).value
    End With
    
    'Access version control
    Call LogLastAccess
    
    'Depress and make toggle green on nav bar
    Me.tglSIV.value = True
    Me.tglSIV.BackColor = vbGreen
    
    'Run date validation on data entered
    Call txtSIV_date_AfterUpdate
    
End Sub
Private Sub txtSIV_date_AfterUpdate()
    'PURPOSE: Validate date entered
    Dim err As String
    
    err = Date_Validation(Me.txtSIV_Date.value)
    
    'Display error message
    Me.errSIV_Date.Caption = err
    
    'Change date format displayed
    If err = vbNullString Then
        Me.txtSIV_Date.value = Format(Me.txtSIV_Date.value, "dd-mmm-yyyy")
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
        
        .Range(112) = String_to_Date(Me.txtSIV_Date.value)
        .Range(113) = Me.txtReminder.value
        
        'Update version control
        .Range(114) = Now
        .Range(115) = Username
        
        'Change study status based on SIV date saved
        If Me.txtSIV_Date.value <> vbNullString And String_to_Date(Me.txtSIV_Date.value) > Now _
            And .Range(8).value = "Commenced" Then
            
            .Range(8) = "Current"
            'Update version control
            .Range(15) = .Range(114).value
            .Range(16) = .Range(115).value
        
        ElseIf Me.txtSIV_Date.value <> vbNullString And String_to_Date(Me.txtSIV_Date.value) < Now _
            And .Range(8).value = "Current" Then
            
            .Range(8) = "Commenced"
            'Update version control
            .Range(15) = .Range(114).value
            .Range(16) = .Range(115).value
        End If
        
    End With
    
    'Access version control
    Call LogLastAccess
    
    Call UserForm_Initialize

End Sub


'----------------- Navigation section Toggles ----------------

Private Sub tglNav_Click()
    'PURPOSE: Closes current form and open Nav form
    Unload form07_SIV
    
    form00_Nav.Show False
End Sub

Private Sub tglStudyDetail_Click()
    'PURPOSE: Closes current form and open Study Details form
    Unload form07_SIV
    
    form01_StudyDetail.Show False
End Sub

Private Sub tglCDA_FS_Click()
    'PURPOSE: Closes current form and open CDA / FS form
    Unload form07_SIV
    
    form02_CDA_FS.Show False
End Sub

Private Sub tglSiteSelect_Click()
    'PURPOSE: Closes current form and open Site Selection form
    Unload form07_SIV
    
    form03_SiteSelect.Show False
End Sub

Private Sub tglReviews_Click()
    'PURPOSE: Closes current form and open Reviews form - Recruitment tab
    Unload form07_SIV
    
    form041_Recruitment.Show False
End Sub

Private Sub tglCTRA_Click()
    'PURPOSE: Closes current form and open CTRA form
    Unload form07_SIV
    
    form05_CTRA.Show False
End Sub

Private Sub tglFinDisc_Click()
    'PURPOSE: Closes current form and open SIV form
    Unload form07_SIV
    
    form06_FinDisc.Show False
End Sub

