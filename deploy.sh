#!/bin/bash
#
# Genesys CX POC - Terraform Deployment Automation Script (Bash)
# Logs all operations to deployment.log in real-time
#
# Usage:
#   ./deploy.sh init
#   ./deploy.sh validate
#   ./deploy.sh plan
#   ./deploy.sh apply
#   ./deploy.sh destroy
#   ./deploy.sh output
#   ./deploy.sh all [--auto-approve]
#

set -e

# Configuration
LOG_FILE="deployment.log"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
ACTION="${1:-all}"
AUTO_APPROVE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if --auto-approve flag is present
if [[ "$2" == "--auto-approve" ]]; then
    AUTO_APPROVE=true
fi

# Function to write logs
write_log() {
    local message="$1"
    local level="${2:-INFO}"
    local log_entry="[$(date '+%Y-%m-%d %H:%M:%S')] $level: $message"
    
    # Write to console with color
    case $level in
        "SUCCESS")
            echo -e "${GREEN}$log_entry${NC}"
            ;;
        "ERROR")
            echo -e "${RED}$log_entry${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}$log_entry${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}$log_entry${NC}"
            ;;
        *)
            echo "$log_entry"
            ;;
    esac
    
    # Append to log file
    echo "$log_entry" >> "$LOG_FILE"
}

# Function to initialize log file
initialize_log() {
    cat > "$LOG_FILE" << EOF
================================================================================
GENESYS CX POC - REAL-TIME DEPLOYMENT LOG
================================================================================
Project: genesys-cx-poc
Owner: MALLIKARJUN08
Repository: https://github.com/MALLIKARJUN08/genesys-cx-poc
Branch: main
Log Started: $TIMESTAMP
Shell: $(echo $SHELL)
OS: $(uname -s)
================================================================================

EOF
    write_log "Deployment log initialized" "INFO"
}

# Terraform operations
execute_terraform_init() {
    write_log "========== TERRAFORM INIT ==========" "INFO"
    write_log "Initializing Terraform working directory" "INFO"
    
    if terraform init 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
        write_log "✓ Terraform init completed successfully" "SUCCESS"
    else
        write_log "✗ Terraform init failed" "ERROR"
        return 1
    fi
}

execute_terraform_validate() {
    write_log "========== TERRAFORM VALIDATE ==========" "INFO"
    write_log "Validating Terraform configuration" "INFO"
    
    if terraform validate 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
        write_log "✓ Terraform validation successful" "SUCCESS"
    else
        write_log "✗ Terraform validation failed" "ERROR"
        return 1
    fi
}

execute_terraform_plan() {
    write_log "========== TERRAFORM PLAN ==========" "INFO"
    write_log "Planning infrastructure changes" "INFO"
    
    if terraform plan 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
        write_log "✓ Terraform plan completed successfully" "SUCCESS"
    else
        write_log "✗ Terraform plan failed" "ERROR"
        return 1
    fi
}

execute_terraform_apply() {
    write_log "========== TERRAFORM APPLY ==========" "INFO"
    write_log "Applying infrastructure changes" "INFO"
    
    if [ "$AUTO_APPROVE" = true ]; then
        write_log "Executing: terraform apply -auto-approve" "INFO"
        if terraform apply -auto-approve 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
            write_log "✓ Terraform apply completed successfully" "SUCCESS"
        else
            write_log "✗ Terraform apply failed" "ERROR"
            return 1
        fi
    else
        write_log "Executing: terraform apply (manual approval required)" "INFO"
        if terraform apply 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
            write_log "✓ Terraform apply completed successfully" "SUCCESS"
        else
            write_log "✗ Terraform apply failed" "ERROR"
            return 1
        fi
    fi
}

execute_terraform_destroy() {
    write_log "========== TERRAFORM DESTROY ==========" "WARNING"
    write_log "Preparing to destroy infrastructure" "WARNING"
    
    if [ "$AUTO_APPROVE" = true ]; then
        write_log "Executing: terraform destroy -auto-approve" "WARNING"
        if terraform destroy -auto-approve 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
            write_log "✓ Terraform destroy completed successfully" "SUCCESS"
        else
            write_log "✗ Terraform destroy failed" "ERROR"
            return 1
        fi
    else
        write_log "Executing: terraform destroy (manual approval required)" "WARNING"
        if terraform destroy 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
            write_log "✓ Terraform destroy completed successfully" "SUCCESS"
        else
            write_log "✗ Terraform destroy failed" "ERROR"
            return 1
        fi
    fi
}

execute_terraform_output() {
    write_log "========== TERRAFORM OUTPUT ==========" "INFO"
    write_log "Retrieving Terraform outputs" "INFO"
    
    if terraform output -json 2>&1 | tee -a "$LOG_FILE" > /dev/null; then
        write_log "✓ Terraform output retrieved successfully" "SUCCESS"
    else
        write_log "✗ Terraform output retrieval failed" "ERROR"
        return 1
    fi
}

# Main function
main() {
    initialize_log
    
    write_log "Starting Terraform deployment with action: $ACTION" "INFO"
    write_log "Working directory: $(pwd)" "INFO"
    
    case $ACTION in
        init)
            execute_terraform_init
            ;;
        validate)
            execute_terraform_validate
            ;;
        plan)
            execute_terraform_plan
            ;;
        apply)
            execute_terraform_apply
            ;;
        destroy)
            execute_terraform_destroy
            ;;
        output)
            execute_terraform_output
            ;;
        all)
            execute_terraform_init
            sleep 2
            execute_terraform_validate
            sleep 2
            execute_terraform_plan
            sleep 2
            if [ "$AUTO_APPROVE" = true ]; then
                execute_terraform_apply
            else
                write_log "Skipping apply (use --auto-approve flag to auto-apply)" "WARNING"
            fi
            ;;
        *)
            write_log "Unknown action: $ACTION" "ERROR"
            write_log "Valid actions: init, validate, plan, apply, destroy, output, all" "INFO"
            exit 1
            ;;
    esac
    
    write_log "========== DEPLOYMENT EXECUTION COMPLETED ==========" "INFO"
    write_log "Log file: $LOG_FILE" "INFO"
    write_log "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" "INFO"
}

# Run main function
main
