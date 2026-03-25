#!/usr/bin/env powershell
<#
.SYNOPSIS
    Genesys CX POC - Terraform Deployment Automation Script
    Logs all operations to deployment.log in real-time

.DESCRIPTION
    This script automates Terraform operations and logs each step to deployment.log
    with real-time timestamps

.EXAMPLE
    .\deploy.ps1 -Action "init"
    .\deploy.ps1 -Action "plan"
    .\deploy.ps1 -Action "apply"
    .\deploy.ps1 -Action "destroy"
    .\deploy.ps1 -Action "validate"
    .\deploy.ps1 -Action "all"

.NOTES
    Generated: 2026-03-25
    Project: genesys-cx-poc
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("init", "validate", "plan", "apply", "destroy", "output", "all")]
    [string]$Action = "all",
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove = $false
)

# Configuration
$LogFile = "deployment.log"
$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommandPath
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Function to write logs
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Level`: $Message"
    
    # Write to console
    Write-Host $logEntry
    
    # Append to log file
    Add-Content -Path $LogFile -Value $logEntry
}

# Function to log command execution
function Execute-Command {
    param(
        [string]$Description,
        [string]$Command,
        [string]$Arguments = ""
    )
    
    Write-Log "========== $Description ==========" "INFO"
    Write-Log "COMMAND: $Command $Arguments" "INFO"
    
    try {
        $output = & $Command $Arguments.Split() 2>&1
        
        # Log output
        foreach ($line in $output) {
            Write-Log $line "OUTPUT"
        }
        
        Write-Log "✓ $Description completed successfully" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "✗ $Description failed: $_" "ERROR"
        return $false
    }
}

# Initialize log file
function Initialize-Log {
    $header = @"
================================================================================
GENESYS CX POC - REAL-TIME DEPLOYMENT LOG
================================================================================
Project: genesys-cx-poc
Owner: MALLIKARJUN08
Repository: https://github.com/MALLIKARJUN08/genesys-cx-poc
Branch: main
Log Started: $Timestamp
PowerShell Version: $($PSVersionTable.PSVersion)
================================================================================

"@
    
    Set-Content -Path $LogFile -Value $header
    Write-Log "Deployment log initialized" "INFO"
}

# Main execution logic
function Main {
    Initialize-Log
    
    Write-Log "Starting Terraform deployment with action: $Action" "INFO"
    
    # Change to project directory
    Set-Location $ProjectRoot
    Write-Log "Working directory: $(Get-Location)" "INFO"
    
    # Execute based on action
    switch ($Action) {
        "init" {
            Execute-TerraformInit
        }
        "validate" {
            Execute-TerraformValidate
        }
        "plan" {
            Execute-TerraformPlan
        }
        "apply" {
            Execute-TerraformApply
        }
        "destroy" {
            Execute-TerraformDestroy
        }
        "output" {
            Execute-TerraformOutput
        }
        "all" {
            Execute-TerraformInit
            Start-Sleep -Seconds 2
            Execute-TerraformValidate
            Start-Sleep -Seconds 2
            Execute-TerraformPlan
            Start-Sleep -Seconds 2
            if ($AutoApprove) {
                Execute-TerraformApply
            }
            else {
                Write-Log "Skipping apply (use -AutoApprove flag to auto-apply)" "WARNING"
            }
        }
    }
    
    Write-Log "========== DEPLOYMENT EXECUTION COMPLETED ==========" "INFO"
    Write-Log "Log file: $LogFile" "INFO"
    Write-Log "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" "INFO"
}

# Terraform operations
function Execute-TerraformInit {
    Write-Log "---------- TERRAFORM INIT ----------" "INFO"
    Write-Log "Initializing Terraform working directory" "INFO"
    
    $initOutput = terraform init 2>&1
    
    foreach ($line in $initOutput) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform init completed successfully" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform init failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

function Execute-TerraformValidate {
    Write-Log "---------- TERRAFORM VALIDATE ----------" "INFO"
    Write-Log "Validating Terraform configuration" "INFO"
    
    $validateOutput = terraform validate 2>&1
    
    foreach ($line in $validateOutput) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform validation successful" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform validation failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

function Execute-TerraformPlan {
    Write-Log "---------- TERRAFORM PLAN ----------" "INFO"
    Write-Log "Planning infrastructure changes" "INFO"
    
    $planOutput = terraform plan 2>&1
    
    foreach ($line in $planOutput) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform plan completed successfully" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform plan failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

function Execute-TerraformApply {
    Write-Log "---------- TERRAFORM APPLY ----------" "INFO"
    Write-Log "Applying infrastructure changes" "INFO"
    
    if ($AutoApprove) {
        $applyOutput = terraform apply -auto-approve 2>&1
        Write-Log "Executing: terraform apply -auto-approve" "INFO"
    }
    else {
        $applyOutput = terraform apply 2>&1
        Write-Log "Executing: terraform apply (manual approval required)" "INFO"
    }
    
    foreach ($line in $applyOutput) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform apply completed successfully" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform apply failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

function Execute-TerraformDestroy {
    Write-Log "---------- TERRAFORM DESTROY ----------" "WARNING"
    Write-Log "Preparing to destroy infrastructure" "WARNING"
    
    if ($AutoApprove) {
        $destroyOutput = terraform destroy -auto-approve 2>&1
        Write-Log "Executing: terraform destroy -auto-approve" "WARNING"
    }
    else {
        $destroyOutput = terraform destroy 2>&1
        Write-Log "Executing: terraform destroy (manual approval required)" "WARNING"
    }
    
    foreach ($line in $destroyOutput) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform destroy completed successfully" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform destroy failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

function Execute-TerraformOutput {
    Write-Log "---------- TERRAFORM OUTPUT ----------" "INFO"
    Write-Log "Retrieving Terraform outputs" "INFO"
    
    $outputData = terraform output -json 2>&1
    
    foreach ($line in $outputData) {
        Write-Host $line
        Add-Content -Path $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] OUTPUT: $line"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✓ Terraform output retrieved successfully" "SUCCESS"
    }
    else {
        Write-Log "✗ Terraform output retrieval failed with exit code: $LASTEXITCODE" "ERROR"
    }
}

# Run main function
Main
