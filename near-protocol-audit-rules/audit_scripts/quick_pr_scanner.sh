#!/bin/bash

# Quick PR Scanner v1.0
# Purpose: Fast health check for cursor rules quick-audit-commands.mdc
# Focus: Rapid red flag detection in 1-2 minutes
# Usage: script_logged quick_pr_scanner.sh <start_pr> <end_pr>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_pr> <end_pr>"
    echo "Purpose: Fast PR health check for cursor quick-audit-commands"
    echo "Focus: Rapid red flag detection"
    exit 1
fi

start_pr=$1
end_pr=$2

echo "⚡ QUICK PR HEALTH SCAN: PRs $start_pr-$end_pr"
echo "🎯 Purpose: Fast red flag detection for immediate decisions"
echo ""

# Quick PR discovery (minimal processing)
pr_list=()
pr_count=0

echo "🔍 Scanning for PRs..."
for pr_num in $(seq $start_pr $end_pr); do
    if git log --grep="Merge pull request #$pr_num" --oneline -1 >/dev/null 2>&1; then
        pr_list+=($pr_num)
        pr_count=$((pr_count + 1))
        echo "  ✅ Found PR #$pr_num"
    fi
done

if [ $pr_count -eq 0 ]; then
    echo "  ❌ No PRs found in range"
    echo "✅ SCAN COMPLETE: No PRs to analyze"
    exit 0
fi

echo "  📊 Found $pr_count PRs to scan"
echo ""

# Fast timing check (red flag detector)
echo "⚡ RAPID TIMING CHECK"
rapid_flags=0
timing_alerts=()

prev_timestamp=""
prev_pr=""

for pr_num in "${pr_list[@]}"; do
    merge_commit=$(git log --grep="Merge pull request #$pr_num" --format="%H" -1)
    timestamp=$(git log --format="%at" -1 $merge_commit)
    date_str=$(git log --format="%ad" --date=format:"%m/%d %H:%M" -1 $merge_commit)
    
    if [ ! -z "$prev_timestamp" ]; then
        time_diff=$((timestamp - prev_timestamp))
        if [ $time_diff -lt 3600 ]; then  # Less than 1 hour
            minutes=$((time_diff / 60))
            rapid_flags=$((rapid_flags + 1))
            timing_alerts+=("⚠️  RAPID: PR #$prev_pr → #$pr_num ($minutes min)")
            echo "  🔴 RAPID SUBMISSION: PR #$prev_pr → #$pr_num ($minutes minutes)"
        fi
    fi
    
    prev_timestamp=$timestamp
    prev_pr=$pr_num
done

if [ $rapid_flags -eq 0 ]; then
    echo "  ✅ No rapid submissions detected"
else
    echo "  🚨 FOUND $rapid_flags rapid submission(s)"
fi

echo ""

# Quick file overlap check (basic detection)
echo "⚡ QUICK FILE OVERLAP CHECK"
overlap_flags=0
overlap_alerts=()

# Create temp file for quick analysis
temp_files="/tmp/quick_files_$$"
> "$temp_files"

for pr_num in "${pr_list[@]}"; do
    merge_commit=$(git log --grep="Merge pull request #$pr_num" --format="%H" -1)
    
    # Get parent commits for diff
    parents=$(git log --format="%P" -1 $merge_commit)
    parent1=$(echo $parents | cut -d' ' -f1)
    parent2=$(echo $parents | cut -d' ' -f2)
    
    if [ ! -z "$parent2" ]; then
        # Get changed files and tag with PR number
        git diff --name-only $parent1..$parent2 2>/dev/null | while read file; do
            if [ ! -z "$file" ]; then
                echo "$pr_num|$file" >> "$temp_files"
            fi
        done
    fi
done

# Check for file overlaps
if [ -s "$temp_files" ]; then
    # Find files that appear in multiple PRs
    cut -d'|' -f2 "$temp_files" | sort | uniq -d > "/tmp/overlap_$$"
    
    if [ -s "/tmp/overlap_$$" ]; then
        while read overlap_file; do
            overlap_flags=$((overlap_flags + 1))
            prs_with_file=$(grep "|$overlap_file$" "$temp_files" | cut -d'|' -f1 | sort | uniq | tr '\n' ' ')
            overlap_alerts+=("🔴 OVERLAP: $overlap_file (PRs: $prs_with_file)")
            echo "  🔴 FILE OVERLAP: $overlap_file in PRs: $prs_with_file"
        done < "/tmp/overlap_$$"
        
        echo "  🚨 FOUND $overlap_flags file overlap(s)"
    else
        echo "  ✅ No file overlaps detected"
    fi
    
    rm -f "/tmp/overlap_$$"
else
    echo "  ⚠️  No file data available for analysis"
fi

rm -f "$temp_files"

echo ""

# Quick decision scoring
echo "🎯 QUICK DECISION SUPPORT"
total_risk_flags=$((rapid_flags + overlap_flags))

# Quick decision logic
if [ $total_risk_flags -ge 3 ]; then
    risk_level="HIGH"
    decision_color="🔴"
    recommended_action="ESCALATE: Use system-gaming-audit.mdc for comprehensive analysis"
elif [ $total_risk_flags -ge 1 ]; then
    risk_level="MEDIUM"
    decision_color="🟡"
    recommended_action="INVESTIGATE: Consider deeper analysis or team discussion"
else
    risk_level="LOW"
    decision_color="🟢"
    recommended_action="CONTINUE: Normal monitoring sufficient"
fi

echo "  📊 Risk Flags: $total_risk_flags total"
echo "  $decision_color Risk Level: $risk_level"
echo "  🎯 Recommendation: $recommended_action"

echo ""

# Summary for cursor rules
echo "📋 QUICK SCAN SUMMARY"
echo "  - PRs Scanned: $pr_count"
echo "  - Rapid Submissions: $rapid_flags"
echo "  - File Overlaps: $overlap_flags"
echo "  - Risk Level: $risk_level"
echo "  - Next Action: $recommended_action"

# Output alerts for cursor rules logging
if [ ${#timing_alerts[@]} -gt 0 ] || [ ${#overlap_alerts[@]} -gt 0 ]; then
    echo ""
    echo "🚨 ALERTS FOR CURSOR RULES:"
    printf '%s\n' "${timing_alerts[@]}"
    printf '%s\n' "${overlap_alerts[@]}"
fi

echo ""
echo "✅ QUICK SCAN COMPLETE"
echo "⏱️  Scan completed in under 2 minutes for immediate decision support" 