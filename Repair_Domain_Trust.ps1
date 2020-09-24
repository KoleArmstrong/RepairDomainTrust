# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TITLE: Repair Domain Trust
# DESCRIPTION: Identifeies if a PC's trust relationship has failed, and if it has then fix it.
# AUTHOR NAME: Kole Armstrong
# -----------------------------------------------------------------------------
# REVISION HISTORY
# 2020-9-23: Alpha
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# -----------------------------------------------------------------------------
# FUNCTION NAME: N/A
# DESCRIPTION: N/A
# -----------------------------------------------------------------------------


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN SCRIPT BODY
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#This cmdlet prompts for Admin Domain creds, this will be useful for when we have to reauthenticate the PC's trust relationship back to the domain
$localCredential=Get-Credential

#This command searches for all computers in AD and for each one it filters its name and current status.
@(Get-ADComputer -Filter *).foreach({
    
    $output=@{ComputerName=$_.Name}

    if(-not(Test-Connection -ComputerName $_.Name -Quiet -Count 1)) { $output.Status = 'Offline'
    }else{

#This command will use the Test-ComputerSecureChannel cmdlet to tests its relationship with the domain and will use the admin credentials to authenticate itself. 
    $trustStatus = Invoke-Command -ComputerName $_.Name -ScriptBlock {Test-ComputerSecureChannel} -Credential $localCredential
    $output.Status = $trustStatus
    }

    [pscustomobject]$output

    })

