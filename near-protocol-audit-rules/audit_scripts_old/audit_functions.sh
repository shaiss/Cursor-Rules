#!/bin/bash

# Git command wrapper for logging
git_logged() {
    local timestamp=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
    echo "GIT_CMD [$timestamp]: git $*" | tee -a logs/commands/git_commands.log
    cd .. && git "$@" 2>&1 | tee -a audit_20250602_231029_dfca0b0d/logs/commands/git_output.log && cd audit_20250602_231029_dfca0b0d
    local exit_code=$?
    echo "GIT_EXIT [$timestamp]: $exit_code" | tee -a logs/commands/git_commands.log
    echo "---" | tee -a logs/commands/git_commands.log
    return $exit_code
}

# Decision logging function
log_decision() {
    local decision="$1"
    local reasoning="$2" 
    local alternatives="$3"
    local timestamp=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
    
    echo "DECISION_POINT [$timestamp]" | tee -a logs/decisions/decisions.log
    echo "Decision: $decision" | tee -a logs/decisions/decisions.log
    echo "Reasoning: $reasoning" | tee -a logs/decisions/decisions.log
    echo "Alternatives Considered: $alternatives" | tee -a logs/decisions/decisions.log
    echo "---" | tee -a logs/decisions/decisions.log
}

# Pattern discovery logging
log_pattern() {
    local pattern_type="$1"
    local evidence="$2"
    local confidence="$3"
    local implications="$4"
    local timestamp=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
    
    echo "PATTERN_DISCOVERY [$timestamp]" | tee -a logs/patterns/patterns.log
    echo "Type: $pattern_type" | tee -a logs/patterns/patterns.log
    echo "Evidence: $evidence" | tee -a logs/patterns/patterns.log
    echo "Confidence: $confidence" | tee -a logs/patterns/patterns.log
    echo "Implications: $implications" | tee -a logs/patterns/patterns.log
    echo "---" | tee -a logs/patterns/patterns.log
}

# Progress tracking function
log_progress() {
    local phase="$1"
    local progress_status="$2"
    local notes="$3"
    local timestamp=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
    
    echo "PROGRESS [$timestamp]: $phase - $progress_status" | tee -a audit_progress.log
    echo "Notes: $notes" | tee -a audit_progress.log
    echo "---" | tee -a audit_progress.log
} 