VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} form045_Indemnity 
   Caption         =   "Indemnity Review"
   ClientHeight    =   4860
   ClientLeft      =   -528
   ClientTop       =   -2172
   ClientWidth     =   6048
   OleObjectBlob   =   "form045_Indemnity.frx":0000
End
Attribute VB_Name = "form045_Indemnity"
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
    Dim pPage As MSForms.Page
    
    'Clear user form
    'SOURCE: https://www.mrexcel.com/board/threads/loop-through-controls-on-a-userform.427103/
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
        Me.txtDate_Recv.value = Format(.Range(92).value, "dd-mmm-yyyy")
        Me.txtDate_Sent_Contracts.value = Format(.Range(93).value, "dd-mmm-yyyy")
        Me.txtDate_Comp.value = Format(.Range(94).value, "dd-mmm-yyyy")
        Me.txtReminder.value = .Range(95).value
    End With
    
    'Access version control
    Call LogLastAccess
    
    'Depress and make toggle green on nav bar
    Me.tglReviews.value = True
    Me.tglReviews.BackColor = vbGreen
    Me.tglIndemnity.value = True
    Me.tglIndemnity.BackColor = vbGreen
    
    'Run date validation on data entered
    Call txtDate_Recv_AfterUpdate
    Call txtDate_Sent_Contracts_AfterUpdate
    Call txtDate_Comp_AfterUpdate
    
End Sub

Private Sub txtDate_Recv_AfterUpdate()
    'PURPOSE: Validate date entered
    Dim err As String
    
    err = Date_Validation(Me.txtDate_Recv.value)
    
    'Display error message
    Me.errDate_Recv.Caption = err
    
    'Change date format displayed
    If IsDate(Me.txtDate_Recv.value) Then
        Me.txtDate_Recv.value = Format(Me.txtDate_Recv.value, "dd-mmm-yyyy")
    End If
    
End Sub

Private Sub txtDate_Sent_Contracts_AfterUpdate()
    'PURPOSE: Validate date entered
    Dim err As String
    
    err = Date_Validation(Me.txtDate_Sent_Contracts.value, Me.txtDate_Recv.value, _
            "Date entered earlier than date Received")
    
    'Display error message
    Me.errDate_Sent_Contracts.Caption = err
    
    'Change date format displayed
    If IsDate(Me.txtDate_Sent_Contracts.value) Then
        Me.txtDate_Sent_Contracts.value = Format(Me.txtDate_Sent_Contracts.value, "dd-mmm-yyyy")
    End If
    
End Sub

Private Sub txtDate_Comp_AfterUpdate()
    'PURPOSE: Validate date entered
    Dim err As String
    
    err = Date_Validation(Me.txtDate_Comp.value, Me.txtDate_Sent_Contracts.value, _
            "Date entered earlier than date Sent")
    
    'Display error message
    Me.errDate_Comp.Caption = err
    
    'Change date format displayed
    If IsDate(Me.txtDate_Comp.value) Then
        Me.txtDate_Comp.value = Format(Me.txtDate_Comp.value, "dd-mmm-yyyy")
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
        
        .Range(92) = String_to_Date(Me.txtDate_Recv.value)
        .Range(93) = String_to_Date(Me.txtDate_Sent_Contracts.value)
        .Range(94) = String_to_Date(Me.txtDate_Comp.value)
        .Range(95) = Me.txtReminder.value
        
        'Update version control
        .Range(96) = Now
        .Range(97) = Username
    End With
    
    'Access version control
    Call LogLastAccess
    
    Call UserForm_Initialize

End Sub


'----------------- Navigation section Toggles ----------------

Private Sub tglNav_Click()
    'PURPOSE: Closes current form and open Nav form
    Unload form041_Recruitment
    
    form00_Nav.Show False
End Sub

Private Sub tglStudyDetail_Click()
    'PURPOSE: Closes current form and open Study Details form
    Unload form045_Indemnity
    
    form01_StudyDetail.Show False
End Sub

Private Sub tglCDA_FS_Click()
    'PURPOSE: Closes current form and open CDA / FS form
    Unload form045_Indemnity
    
    form02_CDA_FS.Show False
End Sub

Private Sub tglSiteSelect_Click()
    'PURPOSE: Closes current form and open Site Select form
    Unload form045_Indemnity
    
    form03_SiteSelect.Show False
End Sub

Private Sub tglRecruitment_Click()
    'PURPOSE: Closes current form and open Recruitment form
    Unload form045_Indemnity
    
    form041_Recruitment.Show False
End Sub

Private Sub tglEthics_Click()
    'PURPOSE: Closes current form and open Ethics form
    Unload form045_Indemnity
    
    form042_Ethics.Show False
End Sub

Private Sub tglGovernance_Click()
    'PURPOSE: Closes current form and open Indemnity form
    Unload form045_Indemnity
    
    form043_Governance.Show False
End Sub

Private Sub tglBudget_Click()
    'PURPOSE: Closes current form and open Budget form
    Unload form045_Indemnity
    
    form044_Budget.Show False
End Sub

Private Sub tglCTRA_Click()
    'PURPOSE: Closes current form and open CTRA form
    Unload form045_Indemnity
    
    form05_CTRA.Show False
End Sub

Private Sub tglFinDisc_Click()
    'PURPOSE: Closes current form and open Fin. Disc. form
    Unload form045_Indemnity
    
    form06_FinDisc.Show False
End Sub

Private Sub tglSIV_Click()
    'PURPOSE: Closes current form and open SIV form
    Unload form045_Indemnity
    
    form07_SIV.Show False
End Sub

